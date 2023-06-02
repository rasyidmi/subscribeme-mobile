part of 'attendance_bloc.dart';

abstract class AttendanceState extends BlocState {
  const AttendanceState({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class AttendanceInit extends AttendanceState {}

class FetchClassDetailDataSuccess extends AttendanceState {
  final List<Attendance> attendanceList;
  final AttendanceSlot? attendanceSlot;

  const FetchClassDetailDataSuccess({
    required this.attendanceList,
    this.attendanceSlot,
  });
}

class FetchClassDetailDataLoading extends AttendanceState {}

class FetchClassDetailDataFailed extends AttendanceState {
  const FetchClassDetailDataFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class RecordAttendanceSuccess extends AttendanceState {}

class RecordAttendanceLoading extends AttendanceState {}

class RecordAttendanceFailed extends AttendanceState {
   const RecordAttendanceFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}
