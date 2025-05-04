import 'package:CasadoSushi/database/database.dart';
import 'package:CasadoSushi/models/sushi.dart';
import 'package:flutter/material.dart';

class Produtos extends StatefulWidget{
  const Produtos({super.key});

  @override
  ProdutosState createState() => ProdutosState();
}

class ProdutosState extends State<Produtos>{

  SushiDatabase sushiDatabase = SushiDatabase.instance;
  late List<Sushi> sushi = [];

  @override
  void initState(){
    refreshTable();
    super.initState();
  }

  @override
  dispose(){
    sushiDatabase.close();
    super.dispose();
  }
  refreshTable(){
    sushiDatabase.listSushi().then((value) => {
      setState(() {
        sushi = value;
      })
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Todos os produtos"),
          ElevatedButton(
            onPressed: () {

            }, 
            child: const Text("Adicionar")
          ),
          Table(
            border: TableBorder.all(color: Colors.black),
            columnWidths: {
              0: FixedColumnWidth(100.0),
              1: FixedColumnWidth(100.0)
            },
            children: [
              for(var item in sushi)
                TableRow(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(item.id as String)
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(item.name)
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(item.description as String)
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(item.value as String)
                    )
              ])
            ],
          )
        ]
      )
    );
  }
}