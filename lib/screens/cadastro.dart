import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../models/usuario.dart';

class Cadastro extends StatefulWidget{
  const Cadastro({super.key});

  @override
  CadastroState createState() => CadastroState();
}

class CadastroState extends State<Cadastro>{
  final nomeController = TextEditingController();
  final sobrenomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confController = TextEditingController();
  final telefoneController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneFormatter = MaskTextInputFormatter(mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')});
  final _cpfFormatter = MaskTextInputFormatter(mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  String isUser = "";
  UsuarioRepository usuarioRepository = UsuarioRepository();
  final _formKey = GlobalKey<FormState>();
  bool isUserCorrect = true;

  @override
  void initState() {
    
    super.initState();
  }
  
  cadastrar() async {
    final nome = "${nomeController.text} ${sobrenomeController.text}";
    final email = emailController.text;
    final senha = senhaController.text;
    final telefone = telefoneFormatter.getMaskedText();
    final cpf = _cpfFormatter.getMaskedText();
    if(_formKey.currentState!.validate()){
      
      isUser = await usuarioRepository.checkUser(email, telefone, cpf);
      if(isUser.isEmpty){
        isUserCorrect = true;
        try{
          final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: senha);
          Usuario usuario = Usuario(firebaseUID: cred.user!.uid, nome: nome, email: email, telefone: telefone, cpf: cpf, senha: senha, isAdmin: 0);
          await usuarioRepository.insertUser(usuario);  
          if(!mounted) return;      
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cadastro realizado com sucesso!")));
        }
        catch (e){
          print("Erro ao cadastrar: $e");
        }
      }
      else{
        setState(() {
          isUserCorrect = false;
        }); 
      }
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("")),
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
                  child: Text("Cadastro", textScaler: TextScaler.linear(2.0), style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width *.4325,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color.fromARGB(255, 204, 96, 82).withAlpha(127)
                      ),
                      child: TextFormField(
                        controller: nomeController,
                        validator: (value) {
                        if(value!.isEmpty){
                          return "O nome é requerido.";
                        }
                        return null;
                        },
                        
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Nome"
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *.4325,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color.fromARGB(255, 204, 96, 82).withAlpha(127)
                      ),
                      child: TextFormField(
                        controller: sobrenomeController,
                        validator: (value) {
                        if(value!.isEmpty){
                          return "O sobrenome é requerido.";
                        }
                        return null;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Sobrenome"
                        ),
                      ),
                    ),
                  ],
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
                    controller: telefoneController,
                    validator: (value) {
                    if(value!.isEmpty || telefoneFormatter.getUnmaskedText().length < 10){
                      return "O número de telefone é requerido.";
                    }
                    return null;
                    },
                    inputFormatters: [telefoneFormatter],
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Telefone",
                      counterText: ''    
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
                    controller: cpfController,
                    validator: (value) {
                    if(value!.isEmpty || _cpfFormatter.getUnmaskedText().length < 11){
                      return "O CPF é requerido.";
                    }
                    return null;
                    },
                    inputFormatters: [_cpfFormatter],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "CPF"
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
                    if(value!.isEmpty || senhaController.text.length < 8){
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
                Container(
                  width: MediaQuery.of(context).size.width *.9,
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color.fromARGB(255, 204, 96, 82).withAlpha(127)
                  ),
                  child: TextFormField(
                    controller: confController,
                    validator: (value) {
                    if(value!.isEmpty){
                      return "A senha é requerida.";
                    }
                    if(value != senhaController.text.trim()){
                      return "As senhas não coincidem.";
                    }
                    return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Confirmar Senha"
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
                    onPressed: (){cadastrar();}, 
                    child: Text("Cadastrar", style: TextStyle(color: Colors.white),
                    )
                  ),
                ),
                SizedBox(height: 20),
                isUserCorrect
                      ? const SizedBox()
                      : Text(isUser, style: TextStyle(color:Colors.red))
              ],
            ),
          ),
        ),
      )
    );
  }
}