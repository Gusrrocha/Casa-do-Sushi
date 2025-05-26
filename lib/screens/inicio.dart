import 'package:casadosushi/models/produto.dart';
import 'package:casadosushi/repositories/produto_repository.dart';
import 'package:casadosushi/screens/itemPage.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  InicioState createState() => InicioState();
}

class InicioState extends State<Inicio> {
  ProdutoRepository produtoRepository = ProdutoRepository();
  late List<Produto> produto = [];
  late List<Produto> produtoList2 = [];

  final searchField = TextEditingController();

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
          produtoList2 = value;
        }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 193, 193),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 182, 182),
        title: const Text("Casa do Sushi"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            margin: const EdgeInsets.fromLTRB(4.0, 1.5, 4.0, 10),
            padding: const EdgeInsets.all(6),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: searchField,
              onChanged: (value) {
                setState(() {
                  produtoList2 =
                      produto
                          .where(
                            (element) => element.name.toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                          )
                          .toList();
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Pesquisar",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchField.clear();
                    refreshTable();
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          Container(
            margin: const EdgeInsets.fromLTRB(4.0, 1.5, 4.0, 10),
            padding: EdgeInsets.all(10),
            height: 500,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 182, 182),
              borderRadius: BorderRadius.circular(12)
            ),
            child: GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.00,
              ),
              // This next line does the trick.
              children: <Widget>[
                for (var item in produtoList2)
                  InkWell(
                    hoverColor: Colors.transparent,
                    onTap:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (BuildContext context) =>
                                    ItemPage(produto: item),
                          ),
                        ),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shadowColor: const Color.fromARGB(255, 161, 161, 161),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          item.photo != null
                              ? Image.asset(
                                item.photo!,
                                width: 150,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                              : Icon(Icons.set_meal),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textScaler: TextScaler.linear(1.5),
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "R\$ ${item.value.toString().contains('.') ? item.value.toString().replaceAll('.', ',') : "${item.value},00"}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(
                                    255,
                                    202,
                                    146,
                                    146,
                                  ),
                                ),
                                textScaler: TextScaler.linear(1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
