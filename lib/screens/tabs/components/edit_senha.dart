import 'package:casadosushi/models/usuario.dart';
import 'package:flutter/material.dart';

class EditSenha extends StatelessWidget{
  EditSenha({super.key, required this.usuario});
  
  final Usuario usuario;
  final _formKey = GlobalKey<FormState>();
  final senhaController = TextEditingController();

  _salvarFormulario(){

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
                  controller: senhaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Senha",
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