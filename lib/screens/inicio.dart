import 'package:casadosushi/models/produto.dart';
import 'package:casadosushi/repositories/produto_repository.dart';
import 'package:casadosushi/screens/carrinho.dart';
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
      appBar: AppBar( 
        title: const Text("Início"), 
        centerTitle: true
        ),
      body: Column(
        children: [
          
          SizedBox(height: 20),
          Spacer(),
          Container(
            margin: const EdgeInsets.fromLTRB(4.0, 1.5, 4.0, 10),
            padding: EdgeInsets.all(10),
            height: 500,
            child: GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.00,
              ),
              // This next line does the trick.
              children: <Widget>[
                for (var item in produto)
                  InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ItemPage(produto: item))),
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.fromLTRB(8,0,8,0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          item.photo != null 
                          ?
                          Image.asset(
                            item.photo!,
                            width: 150,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                          :
                          Icon(Icons.set_meal),
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
