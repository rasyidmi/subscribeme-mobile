import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/bloc_state.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';

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
    } else if (status == ResponseStatus.autoLoginFailed) {
      log('Auto login failed.');
    } else if (status == ResponseStatus.tokenExpire) {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.login, (route) => false);
      SubsFlushbar.showFailed(context, LocaleKeys.expired_session.tr());
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
