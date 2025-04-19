import 'package:flutter/material.dart';

class Inicio extends StatelessWidget{
  const Inicio({super.key});

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Início")),),
      body: 
      Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 2, 0, 2),
                child:Text("Promoções...", style: TextStyle(fontWeight: FontWeight.bold)))
            ],
          ),
          Container(
          margin: const EdgeInsets.fromLTRB(0,1.5,0,10),
          padding: EdgeInsets.all(10),
          height: 200,
          child: ListView(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            children: <Widget>[ 
              Container(
                width: 160, 
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.set_meal, size: 80),
                    Text("Sushi mal-passado"),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.all(10),child: Text("R\$")),
                        Spacer(),
                        Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0), child:Align(alignment: Alignment.bottomRight, child:Text("Valor")))
                      ],
                    )
                    
                  ],
                ),
              ),
              Container(width: 160, color: Colors.blue),
              Container(width: 160, color: Colors.green),
              Container(width: 160, color: Colors.yellow),
              Container(width: 160, color: Colors.orange),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 2, 0, 2),
                child:Text("Outra coisa...", style: TextStyle(fontWeight: FontWeight.bold)))
            ],
          ),
          Container(
          margin: const EdgeInsets.fromLTRB(0,1.5,0,10),
          padding: EdgeInsets.all(10),
          height: 200,
          child: ListView(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(width: 160, color: Colors.red),
              Container(width: 160, color: Colors.blue),
              Container(width: 160, color: Colors.green),
              Container(width: 160, color: Colors.yellow),
              Container(width: 160, color: Colors.orange),
              ],
            ),
          ),
          ],
        ),
    );
  }
}