import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/models/item.dart';
import 'package:casadosushi/models/produto.dart';
import 'package:casadosushi/screens/compra/compra_page.dart';
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
    Navigator.of(context).pop();
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(""), backgroundColor: Color.fromARGB(255, 255, 182, 182), elevation: 0,),
      body: 
        Container(
          child: Column(
            children: [
              //Container(
              // child:Image()
              //),
              Container(
                color: Colors.white,
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  item.produto?.photo ?? "assets/images/placeholder.jpg",
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16,24,8,8),
                      child: Align(
                          alignment: Alignment.centerLeft, 
                          child: Text(widget.produto.name, 
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
                    ),              
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16,24,8,8),
                      child: Align(
                          alignment: Alignment.centerLeft, 
                          child: Text("R\$ ${widget.produto.value.toString().replaceAll('.', ',')}", 
                          style: TextStyle(fontSize: 24), textScaler: TextScaler.linear(1.5))),
                          
                    ),
                    
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16,24,8,8),
                child: Align(
                    alignment: Alignment.centerLeft, 
                    child: Text("Descrição", 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16,24,8,8),
                child: Align(
                    alignment: Alignment.centerLeft, 
                    child: Text(widget.produto.description ?? "",
                    style: TextStyle(fontSize: 20))),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  
                  width: 200,
                  height: 50,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: IconButton(
                            icon: Icon(Icons.remove_circle),
                            onPressed: () {
                              quantidadeController.text = (int.parse(quantidadeController.text) - 1).toString();
                              if (int.parse(quantidadeController.text) < 1) {
                                quantidadeController.text = "1";
                              }
                            },                       
                          ),
                      ),
                      Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            controller: quantidadeController,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                      ),
                      
                      Expanded(
                          child: IconButton(
                            icon: Icon(Icons.add_circle),
                            onPressed: () {
                              quantidadeController.text = (int.parse(quantidadeController.text) + 1).toString();               
                            },                       
                          ),
                      )
                    ],
                  ),
                ),
              ),      
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [            
                    Expanded(
                      child: SizedBox.expand(
                        child: IconButton(
                          onPressed: () => addToCart(widget.produto), 
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.add_shopping_cart),
                          color: Colors.green,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(Colors.green.withAlpha(64)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox.expand(
                        child: ElevatedButton( 
                          onPressed: () {
                            setState(() { 
                              item.quantidade = int.parse(quantidadeController.text);
                              item.valor = widget.produto.value * item.quantidade;
                            });
                            List<Item> itens = [item];
                            
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CompraPage(itens: itens)));    
                          }, 
                          child: Text("Comprar")
                          
                        ),
                      ),
                    )
                  ],
                ),
              )
          ],
          ),
        ),
      );
  }
}