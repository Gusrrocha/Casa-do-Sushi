import 'package:flutter/material.dart';

class Perfil extends StatelessWidget{
  const Perfil({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Perfil"))),
    );
  }
}