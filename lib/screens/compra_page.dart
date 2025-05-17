import 'package:casadosushi/models/item.dart';
import 'package:flutter/material.dart';

class CompraPage extends StatefulWidget{
  const CompraPage({super.key, required this.itens});

  final List<Item> itens;

  @override
  CompraPageState createState() => CompraPageState();
}

class CompraPageState extends State<CompraPage>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(""),),
      body: Center(
        child:Container(
          child: Column(
          children: [
            
          ],
          ),
        ),
      )
      );
  }
}