import 'package:casadosushi/models/produto.dart';
import 'package:casadosushi/repositories/item_repository.dart';
import 'package:casadosushi/repositories/produto_repository.dart';
import 'package:casadosushi/screens/screensADB/components/add_produto.dart';
import 'package:casadosushi/screens/screensADB/components/edit_produto.dart';
import 'package:flutter/material.dart';

class Produtos extends StatefulWidget {
  const Produtos({super.key});

  @override
  ProdutosState createState() => ProdutosState();
}

class ProdutosState extends State<Produtos> {
  ProdutoRepository produtoRepository = ProdutoRepository();
  late List<Produto> produto = [];
  ItemRepository itemRepository = ItemRepository();

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
      backgroundColor: const Color.fromARGB(255, 255, 193, 193),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 193, 193),
        title: Center(child: Text("Produtos")),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8), child: SizedBox(height: 5.0)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => AdicionarProduto(),
                );
                refreshTable();
              },
              child: const Text("Adicionar"),
            ),
          ),
          if (produto.isNotEmpty)
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: produto.length,
                itemBuilder:
                    (context, index) => Card(
                      child: ListTile(
                        leading: Text(produto[index].id.toString()),
                        title: Text(produto[index].name),
                        subtitle: Text(
                          "R\$ ${produto[index].value.toString().replaceAll('.', ',')}",
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //Text(sushi[index].description ?? ""),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    builder:
                                        (context) => EditProduto(
                                          id: produto[index].id!,
                                          produto: produto[index],
                                        ),
                                  );
                                  refreshTable();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: Text('Deletar'),
                                          content: Text(
                                            'Tem certeza que deseja deletar o produto?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    context,
                                                  ).pop(false),
                                              child: Text('Não'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text('Sim'),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (confirm == true && mounted) {
                                    final orders = await itemRepository.getItem(produto[index].id!);
                                    if (orders.isNotEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Este produto está vinculado a pedidos e não pode ser deletado.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      await produtoRepository.deleteProduto(
                                      produto[index].id!,
                                      );
                                      refreshTable();
                                    }
                                    
                                  }
                                },
                              ),
                            ],
                          ),
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
