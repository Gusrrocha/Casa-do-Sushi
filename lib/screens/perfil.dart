import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/database/auth.dart';
import 'package:casadosushi/models/usuario.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:casadosushi/screens/loginPage.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Perfil"))),
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
          Expanded(
            child: Container(
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
                      Text(
                        usuario?.email ?? "",
                        style: TextStyle(fontSize: 20),
                      ),
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
          ),
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
                    print("Erro ao tentar sair: $e");
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
