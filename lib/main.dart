import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/commons/styles/themes.dart';
import 'package:subscribeme_mobile/repositories/auth_repository.dart';
import 'package:subscribeme_mobile/routes_factory.dart';
import 'package:subscribeme_mobile/service_locator/repository_providers.dart';
import 'package:subscribeme_mobile/service_locator/service_locator.dart';
import 'service_locator/navigation_service.dart';
import 'package:subscribeme_mobile/widgets/dismiss_keyboard.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  // Initialize date formatting to Bahasa Indonesia.
  await initializeDateFormatting('id_ID', null);

  setupLocator();

  // Get device id and store it using Shared Preference.
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String deviceId;
  if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    deviceId = iosDeviceInfo.identifierForVendor!;
    await prefs.setString("deviceId", deviceId);
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    deviceId = androidDeviceInfo.id;
    await prefs.setString("deviceId", deviceId);
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: ColorPalettes.white));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) {
              final repository = RepositoryProvider.of<AuthRepository>(context);
              return AuthBloc(repository);
            },
          ),
        ],
        child: DismissKeyboard(
          child: MaterialApp(
            title: 'SubscribeMe',
            theme: appTheme,
            navigatorKey: locator<NavigationService>().navigatorKey,
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => getScreenByName(settings.name!),
              );
            },
          ),
        ),
      ),
    );
  }
}
