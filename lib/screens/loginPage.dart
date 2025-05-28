import 'package:casadosushi/database/auth.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:casadosushi/screens/cadastro.dart';
import 'package:casadosushi/screens/tabs/tabs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Auth auth = Auth();
  bool isLoginFalse = false;
  UsuarioRepository usuarioRepository = UsuarioRepository(); 
  bool isLoading = false;

  @override
  void initState() {
    
    super.initState();
  }

  login() async {
    final email = emailController.text;
    final senha = senhaController.text;
    
    if(_formKey.currentState!.validate()){
        if(await usuarioRepository.authUser(email, senha)){
          try{
            setState(() {
              isLoading = true;
            });
            await auth.login(email,senha);
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            if(!mounted) return;
              
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => Tabs())
            ); 
          }
          catch (e){
            setState(() {
            isLoginFalse = true;
            });
          }   
        }  
        else{
          setState(() {
            isLoginFalse = true;
          });
        }  
      }
      else{
        setState(() {
          isLoginFalse = true;
        });
      }
  }
    
  
  
  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,64),
                  child: Text("Casa do Sushi", textScaler: TextScaler.linear(4.5), style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 60),
                Container(
                  width: MediaQuery.of(context).size.width *.9,
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color.fromARGB(255, 204, 96, 82).withAlpha(127)
                  ),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                    if(value!.isEmpty){
                      return "O e-mail é requerido.";
                    }
                    return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Endereço de e-mail"
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width *.9,
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color.fromARGB(255, 204, 96, 82).withAlpha(127)
                  ),
                  child: TextFormField(
                    controller: senhaController,
                    validator: (value) {
                    if(value!.isEmpty){
                      return "A senha é requerida.";
                    }
                    return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Senha"
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width *.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 204, 96, 82),
                  ),
                  child: TextButton(
                    onPressed: (){login();}, 
                    child: Text("Entrar", style: TextStyle(color: Colors.white),
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Não tem uma conta ainda?"),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) => Cadastro()));
                      },
                      child: Text("Cadastrar-se")
                    )
                ],  
                ),
                isLoginFalse
                      ? Text("E-mail ou senha está incorreto", style: TextStyle(color:Colors.red))
                      : const SizedBox()
              ],
            ),
          ),
        ),
      )
    );
  }
}