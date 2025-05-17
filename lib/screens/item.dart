

import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/models/item.dart';
import 'package:casadosushi/models/produto.dart';
import 'package:casadosushi/screens/compra_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemPage extends StatefulWidget{
  final Produto produto;
  const ItemPage({super.key, required this.produto});

  @override
  ItemPageState createState() => ItemPageState();
}

class ItemPageState extends State<ItemPage>{
  final quantidadeController = TextEditingController();

  late Item item;
  CarrinhoProvider carrinhoProvider = CarrinhoProvider();
  void addToCart(Produto produto) {
    if(int.parse(quantidadeController.text) > 1){
      context.read<CarrinhoProvider>().addItem(produto, quantidade: int.parse(quantidadeController.text));
    }
    else{
      context.read<CarrinhoProvider>().addItem(produto);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.name} adicionado ao carrinho!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    item = Item(idProduto: widget.produto.id!, valor: widget.produto.value, produto: widget.produto);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    quantidadeController.text = "1";
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Center(
        child:Container(
          child: Column(
          children: [
            //Container(
             // child:Image()
            //),
            Text(widget.produto.name),        
            Text(widget.produto.value.toString()),
            Text(widget.produto.description ?? ""),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    quantidadeController.text = (int.parse(quantidadeController.text) - 1).toString();
                    if (int.parse(quantidadeController.text) < 1) {
                      quantidadeController.text = "1";
                    }
                  },                       
                ),
                SizedBox(
                  width: 20,
                  child: TextField(
                    controller: quantidadeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                
                IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () {
                    quantidadeController.text = (int.parse(quantidadeController.text) + 1).toString();  

                  },                       
                )
              ],
            ),         
            Row(
              children: [
                IconButton(
                  onPressed: () => addToCart(widget.produto), 
                  icon: Icon(Icons.add_shopping_cart)
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() { 
                      item.quantidade = int.parse(quantidadeController.text);
                      item.valor = widget.produto.value * item.quantidade;
                    });
                    List<Item> itens = [item];
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CompraPage(itens: itens)));    
                  }, 
                  child: Text("Comprar")
                )
              ],
            )
          ],
          ),
        ),
      )
      );
  }
}