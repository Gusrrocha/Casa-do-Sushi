import 'package:casadosushi/database/auth.dart';
import 'package:casadosushi/models/pedido.dart';
import 'package:casadosushi/repositories/pedido_repository.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';

class Pedidos extends StatefulWidget{
  const Pedidos({super.key});

  @override
  PedidosState createState() => PedidosState();
}

class PedidosState extends State<Pedidos>{
  final PedidoRepository pedidoRepository = PedidoRepository();
  final UsuarioRepository usuarioRepository = UsuarioRepository();
  final Auth auth = Auth();
  
  List<Pedido> pedidos = [];
  
  @override
  void initState() {
    super.initState();
    _getPedidos();
  }

  _getPedidos() async{
    String uid = await auth.usuarioAtual();
    int id = await usuarioRepository.getUserByUID(uid);
    List<Pedido> pedidosTemp = await pedidoRepository.getAllPedidosByUserId(id);
    setState((){
      pedidos = pedidosTemp;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Pedidos"))),
      body: Center(
        child: ListView.builder(
          itemCount: pedidos.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                showDialog(
                  context: context,
                  builder: 
                    (context) => AlertDialog(
                      title: Text("Pedido ${pedidos[index].id}"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for(var item in pedidos[index].listaItens)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.produto!.name),
                                Text('${item.quantidade.toString()}x'),
                                Text('R\$ ${item.produto!.value.toStringAsFixed(2).replaceAll('.', ',')}'),
                              ],
                            ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Fechar"),
                        )
                      ],
                    )
                );
              },
              child: Card(
                child: ListTile(
                  title: Text("${pedidos[index].listaItens.length.toString()} itens"),
                  subtitle: Text(pedidos[index].data.toString()),
                  trailing: Text('R\$ ${pedidos[index].valor!.toStringAsFixed(2).replaceAll('.', ',')}'),
                ),
              ),
            );
          },
      ),
      )
    );
  }
}