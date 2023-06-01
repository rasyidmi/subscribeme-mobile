import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/screens/screens.dart';
import 'package:subscribeme_mobile/screens/settings_screen.dart';
import 'package:subscribeme_mobile/screens/sso_web_view_screen.dart';
import 'package:subscribeme_mobile/screens/wrapper_screen.dart';

Widget getScreenByName(String name) {
  switch (name) {
    case Routes.home:
      return const MainScreen();
    case Routes.login:
      return const LoginScreen();
    case Routes.loginConfirmation:
      return const LoginConfirmationScreen();
    case Routes.maintenance:
      return const MaintenanceScreen();
    // case Routes.courseDetail:
    //   return const CourseDetailScreen();
    case Routes.classDetail:
      return const ClassDetailScreen();
    case Routes.addCourse:
      return const AddCourseScreen();
    case Routes.adminViewCourses:
      return const AdminViewCourses();
    // case Routes.adminCourseDetail:
    //   return const AdminViewCourseDetail();
    // case Routes.addEventDetail:
    //   return const AddEventDetailScreen();
    case Routes.setting:
      return const SettingsScreen();
    case Routes.ssoWebView:
      return const SSOWebViewScreen();
    default:
      return const WrapperScreen();
  }
}
