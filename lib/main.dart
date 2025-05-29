import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/firebase_options.dart';
import 'package:casadosushi/screens/loginPage.dart';
import 'package:casadosushi/screens/tabs/tabs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart';

void main() async {
  if(kIsWeb){
    databaseFactory = databaseFactoryFfiWeb;
  }

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}
class MyAppState extends State<MyApp> {
  bool firstBoot = true;


  @override
  void initState() {
    super.initState();
    inicializar();
  }

  void inicializar() async{
    if(firstBoot){
      await Future.delayed(const Duration(seconds: 3));
      FlutterNativeSplash.remove();
    }
  }

  Future<bool> loginStatus() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
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

