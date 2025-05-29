import 'package:casadosushi/models/usuario.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditSenha extends StatelessWidget {
  EditSenha({super.key, required this.usuario});

  final Usuario usuario;
  final _formKey = GlobalKey<FormState>();
  final senhaOrigController = TextEditingController();
  final senhaController = TextEditingController();
  final UsuarioRepository usuarioRepository = UsuarioRepository();

  _salvarFormulario(context) async {
    if (_formKey.currentState!.validate()) {
      
      Usuario usuario_copy = Usuario(
        id: usuario.id,
        firebaseUID: usuario.firebaseUID,
        isAdmin: usuario.isAdmin,
        cpf: usuario.cpf,
        nome: usuario.nome,
        telefone: usuario.telefone,
        email: usuario.email,
        senha: senhaController.text,
      );
      await FirebaseAuth.instance.currentUser!.updatePassword(
        senhaController.text,
      );
      await usuarioRepository.updateUser(usuario_copy, usuario.id!);
      Navigator.of(context).pop(usuario);
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alterar Senha"), centerTitle: true),
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
                  controller: senhaOrigController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return "Campo obrigatório.";
                    }
                    if(value != usuario.senha){
                      return "Senha incorreta.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: TextFormField(
                  controller: senhaController,
                  validator: (value) {
                    if (value!.isEmpty || senhaController.text.length < 8) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },

                  decoration: InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
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
                    _salvarFormulario(context);
                    
                    
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
