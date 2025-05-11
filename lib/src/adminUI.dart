import 'package:casadosushi/src/relatorios.dart';
import 'package:casadosushi/src/screensADB/Produtos.dart';
import 'package:casadosushi/src/screensADB/pedidos.dart';
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
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:[
            ListTile(
              title: const Text("Relatórios"),
              onTap: (){
                setState(() {
                  bdy = Relatorios();
                  Navigator.pop(context);
                });  
              }    
            ),
            ListTile(
              title: const Text("Pedidos"),
              onTap: (){
                setState(() {
                  bdy = Pedidos();
                  Navigator.pop(context);
                });  
              }    
            ),
             ListTile(
              title: const Text("Produtos"),
              onTap: (){
                setState(() {
                  bdy = Produtos();
                  Navigator.pop(context);
                });  
              }    
            )
          ]
        )     
      ),
      body: bdy
    );
  }


}