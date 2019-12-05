import 'dart:async';
import 'dart:core' as prefix0;

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:core';

import 'package:webview_project/utils/Kkiapay.dart';

void hello(params) {
  print(params);
  print('voici les informations lier au paiement');
}

final obj = {
  "amount": "1",
  "callback": "http://redirect.kkiapay.me",
  "data": "Leonel zegue",
  "host": "co.opensi.medical",
  "key": "f1e7270098f811e99eae1f0cfc677927",
  "name": "HNS Iiyama",
  "phone": "97000000",
  "reason": "Paiement d\u0027un rendez-vous",
  "sandbox": true,
  "sdk": "android",
  "theme": "#2ba359",
  "url": "https://api.kkiapay.me/utils/file/zse2kUp6hgdDRps1OBpkSHxRE"
};

final Kkiapay kkiapay = Kkiapay(
    apikey: 'f1e7270098f811e99eae1f0cfc677927',
    sandbox: true,
    sucessCallback: hello);

final url =
    'https://widget.kkiapay.me/?=eyJhbW91bnQiOiIxIiwiY2FsbGJhY2siOiJodHRwOi8vcmVkaXJlY3Qua2tpYXBheS5tZSIsImRhdGEiOiJMZW9uZWwgemVndWUiLCJob3N0IjoiY28ub3BlbnNpLm1lZGljYWwiLCJrZXkiOiJmMWU3MjcwMDk4ZjgxMWU5OWVhZTFmMGNmYzY3NzkyNyIsIm5hbWUiOiJITlMgSWl5YW1hIiwicGhvbmUiOiI5NzAwMDAwMCIsInJlYXNvbiI6IlBhaWVtZW50IGRcdTAwMjd1biByZW5kZXotdm91cyIsInNhbmRib3giOnRydWUsInNkayI6ImFuZHJvaWQiLCJ0aGVtZSI6IiMyYmEzNTkiLCJ1cmwiOiJodHRwczovL2FwaS5ra2lhcGF5Lm1lL3V0aWxzL2ZpbGUvenNlMmtVcDZoZ2REUnBzMU9CcGtTSHhSRSJ9';

// void main() => runApp());
void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Myapp(),
    );
  }
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String encodedvalue;
  @override
  void initState() {
    encodedvalue = kkiapay.convertObjectToBase64(obj);

    super.initState();
  }

  String getTransactionId(String url) {
    final link = Uri.parse(url);
    return link.queryParameters['transaction_id'];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('salut les gens'),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://widget.kkiapay.me/?=$encodedvalue',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webview) async {
            _controller.complete(webview);
          },
          navigationDelegate: (NavigationRequest request) {
            print('request is there');
            final transactionId = getTransactionId(request.url);
            kkiapay.getTransactionInfo(transactionId).then((response) {
              // print

              if (response['status'] == 'SUCCESS') {
                Navigator.pop(context);
                return hello(response);
              }
            }).catchError((onError) {
              print(onError);
              print('Internal Server Error');
            });
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
        ),
      ),
    );
  }
}