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
      padding: EdgeInsets.all(12),
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("${index + 1}x"),
            trailing: Text(
              "R\$ ${(valorTotal / (index + 1)).toStringAsFixed(2).replaceAll('.', ',')}",
            ),
            onTap: () {
              prosseguir(index + 1);
            },
          );
        },
      ),
    );
  }
}