import 'package:casadosushi/screens/adminUI.dart';
import 'package:flutter/material.dart';
import 'package:casadosushi/screens/carrinho.dart';
import 'package:casadosushi/screens/inicio.dart';
import 'package:casadosushi/screens/perfil.dart';
import 'package:casadosushi/screens/pesquisa.dart';


class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  TabsState createState() => TabsState();
}

class TabsState extends State <Tabs> {
  late List<Widget> listScreens;
  bool isAdmin = true;
  @override
  void initState() {
    super.initState();
    listScreens = [
      Inicio(),
      Pesquisa(),
      Carrinho(),
      Perfil(),
      if(isAdmin)
        AdminDashBoard()
      
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: isAdmin ? 5 : 4,
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
            indicatorColor: Colors.pinkAccent,
            tabs: [
              Tab(
                text: 'Início',
                icon: Icon(Icons.home),
              ),
              Tab(
                text: 'Pesquisar',
                icon: Icon(Icons.search),
              ),
              Tab(
                text: 'Carrinho',
                icon: Icon(Icons.shopping_cart),
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