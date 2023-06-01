import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['BASE_URL']!;
final ssoUrl = dotenv.env['SSO_URL'];
final serviceUrl = dotenv.env['SERVICE_URL'];