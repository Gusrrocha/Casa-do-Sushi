import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/database/auth.dart';
import 'package:casadosushi/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              
              final carrinhoprovider = Provider.of<CarrinhoProvider>(context, listen: false);

              carrinhoprovider.clearCarrinho();
               
              () async {
                try{
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  auth.logout();
                  
                  if(!mounted) return;
                  
                  navigator.pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
                catch (e){
                  print("Erro ao tentar sair: $e");
                }
                
            }();
            }, 
            child: Text("Sair da conta")
          )
      ],)
    );
  }
}