import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sumario extends StatelessWidget {
  final Function(double) prosseguir;
  final List<Item> itens;
  final String paymentMethod;
  final int selectedMonth;
  const Sumario({
    super.key,
    required this.prosseguir,
    required this.itens,
    required this.paymentMethod,
    required this.selectedMonth,
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
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: itens.length,
              itemBuilder:
                  (context, index) => SizedBox(
                    height: 100,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            itens[index].produto!.photo != null
                                ? Image.asset(
                                  itens[index].produto!.photo!,
                                  width: 80,
                                  height: 80,
                                )
                                : Image.asset(
                                  "assets/images/placeholder.jpg",
                                  width: 80,
                                  height: 80,
                                ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itens[index].produto!.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textScaler: TextScaler.linear(1.10),
                                  ),
                                  Text(
                                    "${itens[index].quantidade}x ${itens[index].produto!.value}",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          Container(
            height: 55,
            width: MediaQuery.of(context).size.width * .95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 204, 96, 82),
            ),
            child: TextButton(
              onPressed: () async {
                prosseguir(valorTotal);
              },
              child: Text("Finalizar Compra", style: TextStyle(color: Colors.white),),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
