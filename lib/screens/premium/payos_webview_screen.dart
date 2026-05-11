import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayosWebviewScreen extends StatefulWidget {
  final String url;
  final String successUrl;
  final String cancelUrl;

  const PayosWebviewScreen({
    super.key,
    required this.url,
    this.successUrl = 'https://smartbear.vn/success',
    this.cancelUrl = 'https://smartbear.vn/cancel',
  });

  @override
  State<PayosWebviewScreen> createState() => _PayosWebviewScreenState();
}

class _PayosWebviewScreenState extends State<PayosWebviewScreen> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => _loading = true),
          onPageFinished: (url) => setState(() => _loading = false),
          onNavigationRequest: (request) {
            if (request.url.startsWith(widget.successUrl)) {
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith(widget.cancelUrl)) {
              Navigator.pop(context, 'cancel');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thanh toán PayOS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
