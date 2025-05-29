import 'package:casadosushi/database/auth.dart';
import 'package:casadosushi/models/usuario.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditEmail extends StatelessWidget {
  EditEmail({super.key, required this.usuario});

  final Usuario usuario;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final UsuarioRepository usuarioRepository = UsuarioRepository();
  final Auth auth = Auth();


  _salvarFormulario() async{
    if(_formKey.currentState!.validate()){ 
      await usuarioRepository.updateUser(Usuario(
                                          nome: usuario.nome,
                                          email: emailController.text,
                                          telefone: usuario.telefone,
                                          senha: usuario.senha,
                                          cpf: usuario.cpf
                                          ), usuario.id!
                                          );
      await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(emailController.text);
      auth.logout();
    }
  }
  @override
  Widget build(BuildContext context) {
    emailController.text = usuario.email;
    return Scaffold(
      appBar: AppBar(title: Text("Editar E-mail"), centerTitle: true),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Spacer(),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 204, 96, 82),
                ),
                child: TextButton(
                  onPressed: () {
                    _salvarFormulario();
                  },
                  child: Text("Salvar", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
