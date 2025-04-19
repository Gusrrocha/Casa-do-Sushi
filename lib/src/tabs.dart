import 'package:flutter/material.dart';
import 'package:mobiletet/src/carrinho.dart';
import 'package:mobiletet/src/inicio.dart';
import 'package:mobiletet/src/perfil.dart';
import 'package:mobiletet/src/pesquisa.dart';


class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  TabsState createState() => TabsState();
}

class TabsState extends State <Tabs> {
  late List<Widget> listScreens;

  @override
  void initState() {
    super.initState();
    listScreens = [
      Inicio(),
      Pesquisa(),
      Carrinho(),
      Perfil()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: 4,
        animationDuration: Duration.zero,
        child: Scaffold(
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(), children: listScreens),
          bottomNavigationBar: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            indicatorColor: Colors.tealAccent,
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
              )
            ],
          ),
          backgroundColor: Colors.teal,
        ),
      ),
    );
  }
}