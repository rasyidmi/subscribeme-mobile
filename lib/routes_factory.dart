import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/screens/screens.dart';

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
    case Routes.ssoWebView:
      return const SSOWebViewScreen();
    case Routes.lectureClassDetail:
      return const LectureClassDetailScreen();
    case Routes.lectureAttendance:
      return const LectureAttendanceScreen();
    case Routes.addAttendance:
      return const AddAttendanceScreen();
    case Routes.lecture:
      return const LectureMainScreen();
    case Routes.onBoarding:
      return const OnboardingMainScreen();
    default:
      return const WrapperScreen();
  }
}
