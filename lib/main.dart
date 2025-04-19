import 'package:flutter/material.dart';
import 'src/carrinho.dart';
import 'src/tabs.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Casa do Sushi',
      theme: ThemeData(primarySwatch: Colors.red),
      home: Tabs()
    );
  }
}

