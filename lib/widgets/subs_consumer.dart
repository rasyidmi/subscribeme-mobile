import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/bloc_state.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/routes.dart';

class SubsConsumer<C extends BlocBase<S>, S extends BlocState>
    extends StatelessWidget {
  final BlocWidgetBuilder<S> builder;
  final BlocWidgetListener<S>? listener;
  final BlocBuilderCondition<S>? buildWhen;
  final BlocListenerCondition<S>? listenWhen;

  const SubsConsumer({
    Key? key,
    required this.builder,
    this.listener,
    this.buildWhen,
    this.listenWhen,
  }) : super(key: key);

  void _listener(BuildContext context, BlocState state) {
    final status = state.status;

    if (status == ResponseStatus.success) {
      listener?.call(context, state as S);
      return;
    } else if (status == ResponseStatus.timeout) {
      log('Timeout');
      return;
    } else if (status == ResponseStatus.maintenance) {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.maintenance, (route) => false);
    } else if (status == ResponseStatus.unauthorized) {
      log('Unauthorized');
      return;
    } else {
      listener?.call(context, state as S);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<C, S>(
      buildWhen: buildWhen,
      builder: builder,
      listenWhen: listenWhen,
      listener: _listener,
    );
  }
}