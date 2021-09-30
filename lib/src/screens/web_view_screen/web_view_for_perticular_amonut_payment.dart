import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewForPerticularAmountPayment extends StatefulWidget {
  const WebViewForPerticularAmountPayment({Key? key, required this.url})
      : super(key: key);
  final String url;
  @override
  WebViewForPerticularAmountPaymentState createState() =>
      WebViewForPerticularAmountPaymentState();
}

class WebViewForPerticularAmountPaymentState
    extends State<WebViewForPerticularAmountPayment> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.url,
        navigationDelegate: (NavigationRequest request) {
          if (request.url == 'http://exit.com/') {
            Navigator.pop(context, true);
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
