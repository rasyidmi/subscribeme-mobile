import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/commons/styles/themes.dart';
import 'package:subscribeme_mobile/repositories/auth_repository.dart';
import 'package:subscribeme_mobile/routes_factory.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:subscribeme_mobile/service_locator/repository_providers.dart';
import 'package:subscribeme_mobile/service_locator/service_locator.dart';
import 'package:subscribeme_mobile/widgets/dismiss_keyboard.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  setupLocator();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: ColorPalettes.white));

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('in')],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: BlocProvider<AuthBloc>(
        create: (context) {
          final repository = RepositoryProvider.of<AuthRepository>(context);
          return AuthBloc(repository);
        },
        child: DismissKeyboard(
          child: MaterialApp(
            title: 'SubscribeMe',
            theme: appTheme,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
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
