import 'package:subscribeme_mobile/api/attendance_api.dart';
import 'package:subscribeme_mobile/models/attendance.dart';
import 'package:subscribeme_mobile/models/attendance_slot.dart';

class AttendanceRepository {
  final AttendanceApi _attendanceApi;

  AttendanceRepository(this._attendanceApi);

  Future<List<Attendance>> getUserAttendanceHistory(String classCode) async {
    return _attendanceApi.getUserAttendanceHistory(classCode);
  }

  Future<AttendanceSlot?> checkAttendanceIsOpen(String classCode) async {
    return _attendanceApi.checkAttendanceIsOpen(classCode);
  }

  Future<bool> recordAttendance({
    required String sessionId,
    required String deviceId,
    double? latitude,
    double? longitude,
  }) {
    return _attendanceApi.recordAttendance(
      sessionId: sessionId,
      deviceId: deviceId,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<List<AttendanceSlot>> getClassSession(String classCode) async {
    return _attendanceApi.getClassSession(classCode);
  }

  Future<Map<String, dynamic>> getClassAbsence(String sessionId) async {
    return _attendanceApi.getClassAbsence(sessionId);
  }

  Future<bool> createAttendance({
    required String classCode,
    required int duration,
    required DateTime startTime,
    required bool isGeofence,
    double? latitude,
    double? longitude,
  }) async {
    return _attendanceApi.createAttendance(
      classCode: classCode,
      duration: duration,
      startTime: startTime,
      isGeofence: isGeofence,
    );
  }
}
