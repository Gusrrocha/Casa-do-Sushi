import 'package:casadosushi/screens/screensADB/relatorios.dart';
import 'package:casadosushi/screens/screensADB/Produtos.dart';
import 'package:casadosushi/screens/screensADB/pedidos.dart';
import 'package:casadosushi/screens/screensADB/usuarioADMPage.dart';
import 'package:flutter/material.dart';

class AdminDashBoard extends StatefulWidget{
  const AdminDashBoard({super.key});

  @override
  AdminDashBoardState createState() => AdminDashBoardState();
}
class AdminDashBoardState extends State<AdminDashBoard>{
  Widget bdy = Relatorios();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 193, 193),
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 255, 182, 182),),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 255, 206, 206),
        child: ListView(
          padding: EdgeInsets.zero,
          children:[
            Container(
              height: 120,          
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 188, 188),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(12))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Menu", textScaler: TextScaler.linear(1.5), style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
              height: 120,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.00, color: Color.fromARGB(32, 0, 0, 0)))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.035),
                    leading: Icon(Icons.analytics_outlined),
                    title: const Text("Relatórios", textScaler: TextScaler.linear(1.5)),
                    onTap: (){
                      setState(() {
                        bdy = Relatorios();
                        Navigator.pop(context);
                      });  
                    }    
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
              height: 120,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.00, color: Color.fromARGB(32, 0, 0, 0)))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.035),
                    leading: Icon(Icons.person),
                    title: const Text("Usuários", textScaler: TextScaler.linear(1.5)),
                    onTap: () {
                      setState(() {
                        bdy = UsuarioADMPage();
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
              height: 120,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.00, color: Color.fromARGB(32, 0, 0, 0)))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.035),
                    leading: Icon(Icons.receipt_long),
                    title: const Text("Pedidos", textScaler: TextScaler.linear(1.5)),
                    onTap: (){
                      setState(() {
                        bdy = Pedidos();
                        Navigator.pop(context);
                      });  
                    }    
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.035),
                    leading: Icon(Icons.sell),
                    title: const Text("Produtos", textScaler: TextScaler.linear(1.5)),
                    onTap: (){
                      setState(() {
                        bdy = Produtos();
                        Navigator.pop(context);
                      });  
                    }    
                  ),
                ],
              ),
            )

          ]
        )     
      ),
      body: bdy
    );
  }


}