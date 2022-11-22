import 'package:equatable/equatable.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';

abstract class BlocState extends Equatable {
  final ResponseStatus? status;
  final String? message;

  const BlocState({this.status = ResponseStatus.success, this.message});
  @override
  List<Object?> get props => [status, message];

}