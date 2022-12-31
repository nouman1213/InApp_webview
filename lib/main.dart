import 'package:flutter/material.dart';
import 'package:web_view_app/webview_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WebView',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const WebviewScreen(),
    );
  }
}
