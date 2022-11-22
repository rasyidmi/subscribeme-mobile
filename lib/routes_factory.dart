import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/screens/screens.dart';

Widget getScreenByName(String name) {
  switch (name) {
    case Routes.home:
      return const MainScreen();
    case Routes.register:
      return const RegisterScreen();
    case Routes.maintenance:
      return const MaintenanceScreen();
    case Routes.courseDetail:
      return const CourseDetailScreen();
    case Routes.classDetail:
      return const ClassDetailScreen();
    case Routes.addCourse:
      return const AddCourseScreen();
    case Routes.adminViewCourses:
      return const AdminViewCourses();
    case Routes.adminCourseDetail:
      return const AdminViewCourseDetail();
    case Routes.addEventDetail:
      return const AddEventDetailScreen();
    default:
      return const LoginScreen();
  }
}