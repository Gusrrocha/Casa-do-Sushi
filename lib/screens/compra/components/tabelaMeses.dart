import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabelaMeses extends StatelessWidget{
  const TabelaMeses({super.key, required this.itens, required this.prosseguir});
  final List<Item> itens;
  final Function(int) prosseguir;

  @override
  Widget build(BuildContext context) {
    double valorTotal = 0.0;
    if (context.read<CarrinhoProvider>().carrinho.isEmpty) {
      for (var item in itens) {
        valorTotal += item.produto!.value * item.quantidade;
      }
    } else {
      valorTotal = context.read<CarrinhoProvider>().total;
    }
    return Container(
      height: 700,
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(64, 0, 0, 0))
            ),
            child: ListTile(
              title: Text("${index + 1}x", textScaler: TextScaler.linear(2),),
              trailing: Text(
                "R\$ ${(valorTotal / (index + 1)).toStringAsFixed(2).replaceAll('.', ',')}", textScaler: TextScaler.linear(2),
              ),
              onTap: () {
                prosseguir(index + 1);
              },
            ),
          );
        },
      ),
    );
  }
}