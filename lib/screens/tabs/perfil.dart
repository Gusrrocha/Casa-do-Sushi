import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/database/auth.dart';
import 'package:casadosushi/models/usuario.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:casadosushi/screens/loginPage.dart';
import 'package:casadosushi/screens/tabs/components/edit_email.dart';
import 'package:casadosushi/screens/tabs/components/edit_senha.dart';
import 'package:casadosushi/screens/tabs/components/edit_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  PerfilState createState() => PerfilState();
}

class PerfilState extends State<Perfil> {
  Auth auth = Auth();
  Usuario? usuario;
  UsuarioRepository usuarioRepository = UsuarioRepository();
  @override
  void initState() {
    _getUsuario();
    super.initState();
  }

  _getUsuario() async {
    String uid = await auth.usuarioAtual();
    Usuario usuarioTemp = await usuarioRepository.getUserByUID(uid);
    setState(() {
      usuario = usuarioTemp;
    });
  }

  void _navigateAndRefresh(int index) async {
    dynamic result;
    if(index == 1){
      result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => (EditUsuario(usuario: usuario!)),
        ),
      );
    }
    else if(index == 2){
      result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (EditEmail(usuario: usuario!)),
          ),
        );
    }
    else{
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => (EditSenha(usuario: usuario!))),
      );
    }

    if (result != null) {
      await _getUsuario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 182, 182),
        title: Center(child: const Text("Perfil")),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 193, 193),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: Icon(Icons.person, size: 100),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Nome: ", style: TextStyle(fontSize: 20)),
                    Text(usuario?.nome ?? "", style: TextStyle(fontSize: 20)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Email: ", style: TextStyle(fontSize: 20)),
                    Text(usuario?.email ?? "", style: TextStyle(fontSize: 20)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Telefone: ", style: TextStyle(fontSize: 20)),
                    Text(
                      usuario?.telefone ?? "",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              _navigateAndRefresh(1);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color.fromARGB(64, 0, 0, 0)),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Icon(Icons.edit, size: 40),
                  SizedBox(width: 20),
                  Text(
                    "Editar dados pessoais",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.5),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _navigateAndRefresh(2);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color.fromARGB(64, 0, 0, 0)),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Icon(Icons.email, size: 40),
                  SizedBox(width: 20),
                  Text(
                    "Editar e-mail",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.5),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _navigateAndRefresh(3);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color.fromARGB(64, 0, 0, 0)),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Icon(Icons.password, size: 40),
                  SizedBox(width: 20),
                  Text(
                    "Alterar senha",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.5),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final navigator = Navigator.of(context);

                final carrinhoprovider = Provider.of<CarrinhoProvider>(
                  context,
                  listen: false,
                );

                carrinhoprovider.clearCarrinho();

                () async {
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    auth.logout();

                    if (!mounted) return;

                    navigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  } catch (e) {
                    print("Erro ao sair: $e");
                  }
                }();
              },
              child: Text("Sair da conta"),
            ),
          ),
        ],
      ),
    );
  }
}
