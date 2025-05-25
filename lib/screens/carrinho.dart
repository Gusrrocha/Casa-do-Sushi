import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/screens/compra_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  CarrinhoPageState createState() => CarrinhoPageState();
}

class CarrinhoPageState extends State<CarrinhoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 182, 182),
        title: Text("Carrinho"), 
        centerTitle: true
      ),
      backgroundColor: const Color.fromARGB(255, 255, 193, 193),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<CarrinhoProvider>(
          builder:
              (context, carrinhoProvider, child) => Column(
                children: [
                  carrinhoProvider.carrinho.isNotEmpty ?
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: carrinhoProvider.carrinho.length,
                    itemBuilder: (context, index) {
                      final item = carrinhoProvider.carrinho[index];
                      return Center(
                        child: Container(
                          height: 150,
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              leading:
                                  item.produto?.photo != null
                                      ? Image.asset(
                                        item.produto!.photo!,
                                        width: 90,
                                        height: 120,
                                      )
                                      : Image.asset(
                                        "assets/images/placeholder.jpg",
                                        width: 50,
                                        height: 50,
                                      ),
                              title: Text(
                                item.produto?.name ?? "Produto Desconhecido",
                              ),
                              subtitle: Text(
                                "R\$ ${(item.produto?.value ?? 0).toStringAsFixed(2).replaceAll('.', ',')}",
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      onPressed: () {
                                        carrinhoProvider.removeItem(
                                          item.produto!,
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: TextField(
                                        controller: TextEditingController(
                                          text: item.quantidade.toString(),
                                        ),
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),

                                    IconButton(
                                      icon: Icon(Icons.add_circle),
                                      onPressed: () {
                                        carrinhoProvider.addItem(item.produto!);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                  :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.260,),
                      Icon(Icons.remove_shopping_cart_outlined, size: 50),
                      SizedBox(height: 20),
                      Text("O carrinho está vazio")
                  ],
                  ),
                  Spacer(),
                  SizedBox(height: 20),
                  Text(
                    "Total: R\$ ${carrinhoProvider.total.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            carrinhoProvider.clearCarrinho();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Carrinho limpo com sucesso!"),
                              ),
                            );
                          },
                          child: Text("Limpar Carrinho"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (carrinhoProvider.carrinho.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Carrinho vazio!")),
                              );
                              return;
                            }

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (BuildContext context) => CompraPage(
                                      itens: carrinhoProvider.carrinho,
                                    ),
                              ),
                            );
                          },
                          child: Text("Prosseguir à Compra"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ),
      ),
    );
  }

}
