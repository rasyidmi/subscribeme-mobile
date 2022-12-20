import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/locale/locale_bloc.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppbar(title: LocaleKeys.settings_screen_language.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(LocaleKeys.settings_screen_bahasa.tr(),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: context.locale.toString() == 'id'
                          ? FontWeight.bold
                          : FontWeight.normal)),
              onTap: context.locale.toString() != 'id'
                  ? () {
                      BlocProvider.of<LocaleBloc>(context)
                          .add(SetNewLocale('in'));
                      setState(() {
                        context.setLocale(const Locale('in'));
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(LocaleKeys.settings_screen_english.tr(),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: context.locale.toString() == 'en'
                          ? FontWeight.bold
                          : FontWeight.normal)),
              onTap: context.locale.toString() != 'en'
                  ? () {
                      BlocProvider.of<LocaleBloc>(context)
                          .add(SetNewLocale('en'));
                      setState(() {
                        context.setLocale(const Locale('en'));
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
