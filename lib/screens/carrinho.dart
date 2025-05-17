import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/screens/compra_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  CarrinhoPageState createState() => CarrinhoPageState();
}
  
class CarrinhoPageState extends State<CarrinhoPage> with AutomaticKeepAliveClientMixin<CarrinhoPage>{ 
  @override
  void initState() {
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Carrinho"), centerTitle: true,),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<CarrinhoProvider>(
              builder: (context, carrinhoProvider, child) =>
                Column(
                  children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: carrinhoProvider.carrinho.length,
                        itemBuilder: (context, index) {
                          final item = carrinhoProvider.carrinho[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.fastfood, size: 50),
                              title: Text(item.produto?.name ?? "Produto Desconhecido"),
                              subtitle: Text("R\$ ${(item.produto?.value ?? 0).toStringAsFixed(2)}"),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      onPressed: () {
                                        carrinhoProvider.removeItem(item.produto!);
                                      },                       
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: TextField(
                                        controller: TextEditingController(text: item.quantidade.toString()),
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        ),
                      SizedBox(height: 20),
                      Text("Total: R\$ ${carrinhoProvider.total.toStringAsFixed(2)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Carrinho limpo com sucesso!")));
                              },
                              child: Text("Limpar Carrinho"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CompraPage(itens: carrinhoProvider.carrinho)));
                              },
                              child: Text("Prosseguir à Compra"),
                            ),
                          )
                        ],
                      ),
                ],
                ) 
                  )
              ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
