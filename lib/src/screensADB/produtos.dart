import 'package:CasadoSushi/database/database.dart';
import 'package:CasadoSushi/models/sushi.dart';
import 'package:CasadoSushi/src/screensADB/add_produto.dart';
import 'package:CasadoSushi/src/screensADB/edit_produto.dart';
import 'package:flutter/material.dart';

class Produtos extends StatefulWidget {
  const Produtos({super.key});

  @override
  ProdutosState createState() => ProdutosState();
}

class ProdutosState extends State<Produtos> {
  SushiDatabase sushiDatabase = SushiDatabase.instance;
  late List<Sushi> sushi = [];

  @override
  void initState() {
    refreshTable();
    super.initState();
  }

  @override
  dispose() {
    sushiDatabase.close();
    super.dispose();
  }

  refreshTable() {
    sushiDatabase.listSushi().then(
      (value) => {
        setState(() {
          sushi = value;
        }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("Todos os produtos"),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) => AdicionarProduto(),
              );
            },
            child: const Text("Adicionar"),
          ),
          if (sushi.isNotEmpty)
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: sushi.length,
              itemBuilder:
                  (context, index) => Card(
                    child: ListTile(
                      leading: Text(sushi[index].id.toString()),
                      title: Text(sushi[index].name),
                      subtitle: Text("R\$ ${sushi[index].value.toString().replaceAll('.',',')}"),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //Text(sushi[index].description ?? ""),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (context) => EditProduto(id: sushi[index].id!, sushi: sushi[index]),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  sushiDatabase.deleteSushi(sushi[index].id!);
                                  refreshTable();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
        ],
      ),
    );
  }
}
