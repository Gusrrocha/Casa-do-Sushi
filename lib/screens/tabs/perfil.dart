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
    if (index == 1) {
      result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => (EditUsuario(usuario: usuario!)),
        ),
      );
    } else if (index == 2) {
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => (EditEmail(usuario: usuario!))),
      );
    } else {
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => (EditSenha(usuario: usuario!))),
      );
    }

    if (result != null) {
      await _getUsuario();
    }
  }

  void _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      auth.logout();

      if (!mounted) return;
      Provider.of<CarrinhoProvider>(context, listen: false).clearCarrinho();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      print("Erro ao sair: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 182, 182),
        title: Center(child: const Text("Perfil")),
        elevation: 2,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 193, 193),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 255, 182, 182), Colors.pink.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[400],
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(usuario?.nome ?? "", style: TextStyle(fontSize: 18)),
              subtitle: Text("Nome"),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(usuario?.email ?? "", style: TextStyle(fontSize: 18)),
              subtitle: Text("Email"),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(
                usuario?.telefone ?? "",
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text("Telefone"),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildActionCard(
                    "Editar dados pessoais",
                    Icons.edit,
                    () => _navigateAndRefresh(1),
                  ),
                  _buildActionCard(
                    "Editar e-mail",
                    Icons.email_outlined,
                    () => _navigateAndRefresh(2),
                  ),
                  _buildActionCard(
                    "Alterar senha",
                    Icons.lock_outline,
                    () => _navigateAndRefresh(3),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout),
                label: Text("Sair da conta"),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String text, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
