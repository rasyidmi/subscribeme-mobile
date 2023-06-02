import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscribeme_mobile/blocs/bloc_state.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/attendance.dart';
import 'package:subscribeme_mobile/models/attendance_slot.dart';
import 'package:subscribeme_mobile/repositories/attendance_repository.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository _attendanceRepository;

  AttendanceBloc(this._attendanceRepository) : super(AttendanceInit()) {
    on<FetchClassDetailData>(_onFetchClassDetailDataHandler);
    on<RecordAttendance>(_onRecordAttendanceHandler);
  }

  Future<void> _onFetchClassDetailDataHandler(
      FetchClassDetailData event, Emitter<AttendanceState> emit) async {
    emit(FetchClassDetailDataLoading());
    try {
      final attendanceList =
          await _attendanceRepository.getUserAttendanceHistory(event.classCode);
      final attendanceSlot =
          await _attendanceRepository.checkAttendanceIsOpen(event.classCode);
      emit(FetchClassDetailDataSuccess(
        attendanceList: attendanceList,
        attendanceSlot: attendanceSlot,
      ));
    } on SubsHttpException catch (e) {
      emit(FetchClassDetailDataFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: $f');
      emit(
          const FetchClassDetailDataFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onRecordAttendanceHandler(
      RecordAttendance event, Emitter<AttendanceState> emit) async {
    emit(RecordAttendanceLoading());
    try {
      // Get device id.
      final prefs = await SharedPreferences.getInstance();
      final deviceId = prefs.getString("deviceId");
      Position? position;
      // If lecture enable geofencing, fetch lat and lon.
      if (event.isGeofence) {
        position = await _determinePosition();
      }
      final response = await _attendanceRepository.recordAttendance(
        sessionId: event.sessionId,
        deviceId: deviceId!,
        latitude: position?.latitude,
        longitude: position?.longitude,
      );
      if (response) {
        emit(RecordAttendanceSuccess());
      } else {
        emit(const RecordAttendanceFailed(status: ResponseStatus.failed));
      }
    } on SubsHttpException catch (e) {
      emit(RecordAttendanceFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: $f');
      emit(
          const FetchClassDetailDataFailed(status: ResponseStatus.maintenance));
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      throw SubsHttpException(
        ResponseStatus.locationServiceDisabled,
        'Location services are disabled.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        throw SubsHttpException(
          ResponseStatus.locationServiceDisabled,
          'Location permissions are denied.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw SubsHttpException(
        ResponseStatus.locationServiceDisabled,
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
