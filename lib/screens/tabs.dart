import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:casadosushi/screens/adminUI.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:casadosushi/screens/carrinho.dart';
import 'package:casadosushi/screens/inicio.dart';
import 'package:casadosushi/screens/perfil.dart';
import 'package:casadosushi/screens/pedidos.dart';


class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  TabsState createState() => TabsState();
}

class TabsState extends State <Tabs> {
  late List<Widget> listScreens;
  User? user = FirebaseAuth.instance.currentUser;
  UsuarioRepository usuarioRepository = UsuarioRepository();
  bool isAdmin = false;
  @override
  void initState() {
    if(user != null){
      checkAdmin();
    }
    super.initState();
    
  }

  checkAdmin() async{
    if(user == null){
      return;
    }
    bool temp = await usuarioRepository.checkIfAdmin(user!.uid);
    setState((){
      isAdmin = temp;
    }); 
  }
  @override
  Widget build(BuildContext context) {
    final listScreens = [
      Inicio(),
      CarrinhoPage(),
      Pedidos(),
      Perfil(),
      if(isAdmin)
        AdminDashBoard()
          
    ];
    return MaterialApp(
      home: DefaultTabController(
        length: listScreens.length,
        animationDuration: Duration.zero,
        child: Scaffold(
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(), children: listScreens),
          bottomNavigationBar: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Colors.black,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(
                text: 'Início',
                icon: Icon(Icons.home),
              ),
              Tab(
                text: 'Carrinho',
                icon: Icon(Icons.shopping_cart),
              ),
              Tab(
                text: 'Pedidos',
                icon: Icon(Icons.receipt_long),
              ),
              Tab(
                text: 'Perfil',
                icon: Icon(Icons.person)
              ),
              if(isAdmin == true)
                Tab(
                  text: 'Admin Dashboard',
                  icon: Icon(Icons.admin_panel_settings)
              )
            ],
          ),
          backgroundColor: Color(0xFFd97c7c),
        ),
      ),
    );
  }
}