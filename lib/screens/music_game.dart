import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MusicGameScreen extends StatelessWidget {
  const MusicGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
        'https://gavtaka.itch.io/whimsical-music-class',
      ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Whimsical Music Class'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
