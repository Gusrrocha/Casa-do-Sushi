import 'package:casadosushi/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'screens/tabs.dart';
import 'package:flutter/foundation.dart';

void main() {
  if(kIsWeb){
    databaseFactory = databaseFactoryFfiWeb;
  }
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> loginStatus() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Casa do Sushi',
      theme: ThemeData(primarySwatch: Colors.red),
      home: FutureBuilder<bool>(
        future: loginStatus(), 
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const CircularProgressIndicator();
          }

          bool isLoggedIn = snapshot.data!;
          return isLoggedIn ? Tabs() : LoginPage();
        })
    );
  }
}

