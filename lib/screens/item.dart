

import 'package:casadosushi/models/produto.dart';
import 'package:flutter/material.dart';

class ItemPage extends StatefulWidget{
  final Produto produto;
  const ItemPage({super.key, required this.produto});

  @override
  ItemPageState createState() => ItemPageState();
}

class ItemPageState extends State<ItemPage>{

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(""),),
      body: Column(
        children: [
          //Container(
           // child:Image()
          //),
          Text(widget.produto.name),
          Text(widget.produto.value.toString()),
          Text(widget.produto.description ?? "")

        ],
        ),
      
      );
  }
}