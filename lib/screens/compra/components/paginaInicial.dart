import 'package:flutter/material.dart';


class PaginaInicial extends StatelessWidget{
  final Function(String) prosseguir;

  const PaginaInicial({super.key, required this.prosseguir});

  @override
  Widget build(BuildContext context) {
    final List payments = ["Dinheiro", "Cartão de crédito", "Cartão de débito"];
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          for (var payM in payments)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.125,
              width: MediaQuery.of(context).size.width * .95,
              child: Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(64, 0, 0, 0),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () {
                    prosseguir(payM);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      payM == "Dinheiro"
                          ? Icon(Icons.wallet, size: 40)
                          : Icon(Icons.credit_card, size: 40),
                      SizedBox(width: 10),
                      Text(
                        payM,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textScaler: TextScaler.linear(1.25),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}