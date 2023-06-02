import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/attendance.dart';
import 'package:subscribeme_mobile/models/attendance_slot.dart';

class AttendanceApi {
  final _attendancePath = '/absence';

  Future<List<Attendance>> getUserAttendanceHistory(String classCode) async {
    final response = await RequestHelper.get('$_attendancePath/$classCode');
    List<Attendance> attendanceList = [];
    if (response.status == ResponseStatus.success &&
        response.data!["data"] != null) {
      for (var i = 0; i < response.data!["data"].length; i++) {
        final attendanceData = Attendance.fromJson(response.data!["data"][i]);
        attendanceList.add(attendanceData);
      }
    }

    return attendanceList;
  }

  Future<AttendanceSlot?> checkAttendanceIsOpen(String classCode) async {
    final response =
        await RequestHelper.get('$_attendancePath/check/$classCode');
    if (response.status == ResponseStatus.success) {
      final attendanceSlot = AttendanceSlot.fromJson(response.data!["data"]);
      return attendanceSlot;
    }
    return null;
  }

  Future<bool> recordAttendance({
    required String sessionId,
    required String deviceId,
    double? latitude,
    double? longitude,
  }) async {
    Map<String, dynamic> data = {
      "class_session_id": sessionId,
      "device_code": deviceId,
      "latitude": latitude,
      "longitude": longitude,
    };

    final response = await RequestHelper.put(_attendancePath, data);
    return response.status == ResponseStatus.success;
  }
}
