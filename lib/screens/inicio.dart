import 'package:casadosushi/models/produto.dart';
import 'package:casadosushi/repositories/produto_repository.dart';
import 'package:casadosushi/screens/item.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  InicioState createState() => InicioState();
}

class InicioState extends State<Inicio> {
  ProdutoRepository produtoRepository = ProdutoRepository();
  late List<Produto> produto = [];
  


  @override
  void initState() {
    refreshTable();
    super.initState();
  }

  refreshTable() {
    produtoRepository.listProduto().then(
      (value) => {
        setState(() {
          produto = value;
        }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Início"))),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(30),
            ),
            margin: const EdgeInsets.fromLTRB(4.0, 1.5, 4.0, 10),
            padding: EdgeInsets.all(10),
            height: 200,
            child: ListView(
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (var item in produto)
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ItemPage(produto: item))),
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.fromLTRB(8,0,8,0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(100),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(3, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.set_meal, size: 80),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 0, 0), 
                                  child: Align(alignment: Alignment.centerLeft, 
                                               child: Text(item.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textScaler: TextScaler.linear(1.5),))),
                          
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "R\$ ${item.value.toString().contains('.') ? item.value.toString().replaceAll('.', ',') : "${item.value},00"}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                textScaler: TextScaler.linear(1.5),
                              )
                              
                            ),
                          ),
                          ],
                          ),
                        )
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
