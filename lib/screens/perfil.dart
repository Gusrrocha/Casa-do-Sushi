import 'package:casadosushi/database/auth.dart';
import 'package:casadosushi/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget{
  const Perfil({super.key});

  @override
  PerfilState createState() => PerfilState();
}
class PerfilState extends State<Perfil>{
  Auth auth = Auth();


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Perfil"))),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final navigator = Navigator.of(context);          
              () async {
                try{
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  auth.logout();
                }
                catch (e){
                  print("Erro ao tentar sair: $e");
                }
                if(!mounted) return;

                navigator.pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
            }();
            }, 
            child: Text("Sair da conta")
          )
      ],)
    );
  }
}