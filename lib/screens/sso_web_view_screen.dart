import 'dart:async';

import 'package:subscribeme_mobile/api/api_constants.dart';

import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/service_locator/navigation_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:subscribeme_mobile/service_locator/service_locator.dart';

class SSOWebViewScreen extends StatefulWidget {
  const SSOWebViewScreen({Key? key}) : super(key: key);

  @override
  State<SSOWebViewScreen> createState() => _SSOWebViewScreenState();
}

class _SSOWebViewScreenState extends State<SSOWebViewScreen> {
  bool isLogin = false;
  ValueNotifier<int> progressCounter = ValueNotifier<int>(0);
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  // final controller = WebViewController()
  //   ..clearCache()
  //   ..clearLocalStorage()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setBackgroundColor(const Color(0x00000000))
  //   ..setNavigationDelegate(
  //     NavigationDelegate(
  //       onProgress: (progress) {
  //         loadingProgress = progress;
  //       },
  //       onWebResourceError: (WebResourceError error) {},
  //       onNavigationRequest: (NavigationRequest request) async {
  //         if (request.url.startsWith(serviceUrl!)) {
  //           Uri ssoUri = Uri.parse(request.url);
  //           final ssoTicket = ssoUri.queryParameters["ticket"];
  //           await WebViewCookieManager().clearCookies();
  //           // log(ssoTicket.toString());
  //           locator<NavigationService>()
  //               .navigatorKey
  //               .currentState!
  //               .pop(ssoTicket);
  //           return NavigationDecision.prevent;
  //         } else if (request.url.startsWith(ssoUrl!)) {
  //           return NavigationDecision.navigate;
  //         }
  //         return NavigationDecision.prevent;
  //       },
  //     ),
  //   )
  //   ..loadRequest(Uri.parse('$ssoUrl/login?service=$serviceUrl'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SSO Login",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: '$ssoUrl/login?service=$serviceUrl',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (webViewController) async {
              webViewController.clearCache();
              await CookieManager().clearCookies();
              controller.complete(webViewController);
            },
            navigationDelegate: _navigationDelegate,
            onPageFinished: _onPageFinish,
            onProgress: _onProgress,
          ),
          ValueListenableBuilder(
            valueListenable: progressCounter,
            builder: (context, int progress, _) {
              if (progress == 100) {
                return const SizedBox();
              }
              return LinearProgressIndicator(
                color: ColorPalettes.primary,
                backgroundColor: Colors.transparent,
                value: progress / 100,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onProgress(int progress) {
    setState(() {
      progressCounter.value = progress;
    });
  }

  void _onPageFinish(String url) {
    if (url.startsWith(serviceUrl!)) {
      Uri ssoUri = Uri.parse(url);
      final ssoTicket = ssoUri.queryParameters["ticket"];
      locator<NavigationService>().navigatorKey.currentState!.pop(ssoTicket);
    }
  }

  NavigationDecision _navigationDelegate(NavigationRequest request) {
    if (request.url.startsWith(serviceUrl!) ||
        request.url.startsWith(ssoUrl!)) {
      return NavigationDecision.navigate;
    }
    return NavigationDecision.prevent;
  }
}
