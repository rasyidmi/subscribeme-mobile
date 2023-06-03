
const addEvent = '/add-event';
class Routes {
  static const main = '/home';
  static const maintenance = '/maintenance';
  static const login = '/login';
  static const loginConfirmation = '/login-confirmation';
  static const register = '/register';
  static const setting = '/setting';
  static const courseDetail = '/course-detail';
  static const classDetail = '/class-detail';

  static const adminMenu ='/admin';
  static const addCourse = '$adminMenu/add-course';
  static const adminViewCourses = '$adminMenu/view-courses';
  static const adminCourseDetail = '$adminMenu/view-detail-course';

  static const subscribeCourse = '/enroll-course';
  
  static const addEventDetail = '$addEvent/detail';

  static const ssoWebView = '/sso-web-view';
}