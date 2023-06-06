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

  @override
  List<Object?> get props => [attendanceList, attendanceSlot];
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

class FetchClassSessionSuccess extends AttendanceState {
  final List<AttendanceSlot> sessionList;

  const FetchClassSessionSuccess(this.sessionList);

  @override
  List<Object?> get props => [sessionList];
}

class FetchClassSessionLoading extends AttendanceState {}

class FetchClassSessionFailed extends AttendanceState {
  const FetchClassSessionFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class FetchClassAbsenceSuccess extends AttendanceState {
  final Map<String,dynamic> sessionData;

  const FetchClassAbsenceSuccess(this.sessionData);

  @override
  List<Object?> get props => [sessionData];
}

class FetchClassAbsenceLoading extends AttendanceState {}

class FetchClassAbsenceFailed extends AttendanceState {
  const FetchClassAbsenceFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class CreateAttendanceSuccess extends AttendanceState {}

class CreateAttendanceLoading extends AttendanceState {}

class CreateAttendanceFailed extends AttendanceState {
  const CreateAttendanceFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}
