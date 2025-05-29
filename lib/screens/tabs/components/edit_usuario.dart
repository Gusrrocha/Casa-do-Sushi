import 'package:casadosushi/models/usuario.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditUsuario extends StatefulWidget {
  const EditUsuario({super.key, required this.usuario});

  final Usuario usuario;

  @override
  EditUsuarioState createState() => EditUsuarioState();
}

class EditUsuarioState extends State<EditUsuario> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final sobrenomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final senha = TextEditingController;
  final telefoneFormatter = MaskTextInputFormatter(
    mask: "(##) #####-####",
    filter: {"#": RegExp(r'[0-9]')},
  );

  final UsuarioRepository usuarioRepository = UsuarioRepository();

  @override
  void initState() {
    super.initState();
  }

  _salvarFormulario() async{
    final nome = "${nomeController.text} ${sobrenomeController.text}";
    final telefone = telefoneController.text;
    final email = emailController.text;

    if(_formKey.currentState!.validate()){
      Usuario usuarioNew = widget.usuario.copyWith(
        id: widget.usuario.id,
        nome: nome,
        firebaseUID: widget.usuario.firebaseUID,
        telefone: telefone,
        email: email,
        senha: widget.usuario.senha,
        cpf: widget.usuario.cpf,
        isAdmin: widget.usuario.isAdmin
      );
      await usuarioRepository.updateUser(usuarioNew, widget.usuario.id!);
      
      setState(() {});
      if(!mounted) return;
      Navigator.of(context).pop(usuarioNew);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dados Atualizados com Sucesso!")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    Usuario usuarioCopy = widget.usuario;
    List<String> nomeCompleto = usuarioCopy.nome.split(' ');
    nomeController.text = nomeCompleto.first;
    for (int i = 1; i < nomeCompleto.length; i++) {
      if (i == 1) {
        sobrenomeController.text += nomeCompleto[i];
      } else {
        sobrenomeController.text += " ${nomeCompleto[i]}";
      }
    }
    telefoneController.text = usuarioCopy.telefone;
    emailController.text = usuarioCopy.email;

    return Scaffold(
      appBar: AppBar(title: Text("Editar Dados Pessoais"), centerTitle: true),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                      child: TextFormField(
                        controller: nomeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Campo obrigatório";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Nome",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: TextFormField(
                        controller: sobrenomeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Campo obrigatório";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Sobrenome",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: TextFormField(
                  controller: telefoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório";
                    }
                    return null;
                  },
                  inputFormatters: [telefoneFormatter],
                  decoration: InputDecoration(
                    labelText: "Telefone",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                  child: Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
