part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchClassDetailData extends AttendanceEvent {
  final String classCode;

  FetchClassDetailData(this.classCode);
  @override
  List<Object?> get props => [classCode];
}

class RecordAttendance extends AttendanceEvent {
  final String sessionId;
  final bool isGeofence;

  RecordAttendance({
    required this.sessionId,
    required this.isGeofence,
  });
  @override
  List<Object?> get props => [sessionId, isGeofence];
}

class FetchClassSession extends AttendanceEvent {
  final String classCode;

  FetchClassSession(this.classCode);
  @override
  List<Object?> get props => [classCode];
}

class FetchClassAbsence extends AttendanceEvent {
  final String sessionId;

  FetchClassAbsence(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}
