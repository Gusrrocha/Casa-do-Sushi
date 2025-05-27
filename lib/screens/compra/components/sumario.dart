import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sumario extends StatelessWidget{
  final Function(double) prosseguir;
  final List<Item> itens;
  final String paymentMethod;
  final int selectedMonth;
  const Sumario({
    super.key, 
    required this.prosseguir, 
    required this.itens,
    required this.paymentMethod,
    required this.selectedMonth
  });

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
      child: Column(
        children: [
          Text("Resumo da Compra"),
          SizedBox(height: 20),
          for (var item in itens)
            Text(
              "${item.produto?.name} - R\$ ${item.produto?.value} x ${item.quantidade}",
            ),
          if (paymentMethod == "Cartão de crédito")
            Text(
              "Parcelas: $selectedMonth x R\$ ${(valorTotal / selectedMonth).toStringAsFixed(2).replaceAll('.', ',')}",
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              prosseguir(valorTotal);
              
            },
            child: Text("Finalizar Compra"),
          ),
        ],
      ),
    );
  }


}