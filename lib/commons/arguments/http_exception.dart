import 'package:subscribeme_mobile/commons/constants/response_status.dart';

class SubsHttpException {
  ResponseStatus status;
  String? message;

  SubsHttpException(this.status, this.message);
}