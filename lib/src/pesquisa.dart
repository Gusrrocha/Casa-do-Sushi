import 'package:flutter/material.dart';

class Pesquisa extends StatelessWidget{
  const Pesquisa({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Busca"))),
    );
  }
}