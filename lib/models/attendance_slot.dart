class AttendanceSlot {
  final String id;
  final bool isGeofence;

  AttendanceSlot({
    required this.id,
    required this.isGeofence,
  });

  factory AttendanceSlot.fromJson(Map<String, dynamic> json) => AttendanceSlot(
        id: json["id"],
        isGeofence: json["is_geofence"],
      );
}
