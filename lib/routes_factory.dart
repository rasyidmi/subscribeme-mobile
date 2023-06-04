import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/screens/lecture_class_detail_screen.dart';
import 'package:subscribeme_mobile/screens/lecture_class_screen.dart';
import 'package:subscribeme_mobile/screens/subscribe_course_screen.dart';
import 'package:subscribeme_mobile/screens/screens.dart';
import 'package:subscribeme_mobile/screens/settings_screen.dart';
import 'package:subscribeme_mobile/screens/sso_web_view_screen.dart';
import 'package:subscribeme_mobile/screens/wrapper_screen.dart';

Widget getScreenByName(String name) {
  switch (name) {
    case Routes.main:
      return const MainScreen();
    case Routes.login:
      return const LoginScreen();
    case Routes.loginConfirmation:
      return const LoginConfirmationScreen();
    case Routes.maintenance:
      return const MaintenanceScreen();
    case Routes.subscribeCourse:
      return const SubscribeCourseScreen();
    case Routes.courseDetail:
      return const CourseDetailScreen();
    case Routes.classDetail:
      return const ClassDetailScreen();
    case Routes.setting:
      return const SettingsScreen();
    case Routes.ssoWebView:
      return const SSOWebViewScreen();
    case Routes.lectureClass:
      return const LectureClassScreen();
    case Routes.lectureClassDetail:
      return const LectureClassDetailScreen();
    default:
      return const WrapperScreen();
  }
}
