import 'package:flutter/material.dart';

class Pedidos extends StatefulWidget{
  const Pedidos({super.key});

  @override
  PedidosState createState() => PedidosState();
}

class PedidosState extends State<Pedidos>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("Pedidos")
    );
  }
}