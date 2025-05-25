import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/firebase_options.dart';
import 'package:casadosushi/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart';

void main() async {
  if(kIsWeb){
    databaseFactory = databaseFactoryFfiWeb;
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
 
  runApp(
    ChangeNotifierProvider(
      create: (_) => CarrinhoProvider(),
      child: MyApp(),
    ),    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Casa do Sushi',
      theme: ThemeData(primarySwatch: Colors.red),
      home: SplashScreen()
    );
  }
}

