import 'package:flutter/material.dart';

class Carrinho extends StatefulWidget {
  @override
  CarrinhoState createState() => CarrinhoState();
}
  
class CarrinhoState extends State<Carrinho> with AutomaticKeepAliveClientMixin<Carrinho>{ 
  @override
  void initState() {
    super.initState();
    print("InitState Carrinho");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  Center(
                    child: Text(
                      "Casa do Sushi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textScaler: TextScaler.linear(3.0),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: Text(
                      "Carrinho",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textScaler: TextScaler.linear(2.0),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      width: double.infinity,
                      color: Colors.grey,
                      child: Text(
                        "Produto(s) comprado(s)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textScaler: TextScaler.linear(1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      width: double.infinity,
                      color: Colors.grey,
                      child: Text(
                        "Valor",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textScaler: TextScaler.linear(1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      width: double.infinity,
                      color: Colors.grey,
                      child: Text(
                        "Endereço",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textScaler: TextScaler.linear(1.5),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(padding:EdgeInsets.all(8.0), 
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
