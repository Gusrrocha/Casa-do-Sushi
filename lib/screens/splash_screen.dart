import 'package:casadosushi/screens/loginPage.dart';
import 'package:casadosushi/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    proceder();
  }

  Future<bool> loginStatus() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
  
  proceder() async{
    bool isLoggedIn = await loginStatus();
    await Future.delayed(Duration(seconds: 1), () {});
    if (!mounted) return;
    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Tabs()));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(8), child: Text("Casa do Sushi", style: TextStyle(fontWeight: FontWeight.bold), textScaler: TextScaler.linear(2),)),       
            CircularProgressIndicator()
          ],
        )
      )
    );
  }
}