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
    int id = await usuarioRepository.getUserIdByUID(uid);
    List<Pedido> pedidosTemp = await pedidoRepository.getAllPedidosByUserId(id);
    setState((){
      pedidos = pedidosTemp;
    });
  }

  _removePedido(int id) async{
    await pedidoRepository.deletePedido(id);
    _getPedidos();
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
                          Container(
                             // fixed height so you can control cutoff
                            height: 125,
                            width: 400,
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: pedidos[index].listaItens.length,
                              itemBuilder: (context, indexItem) {
                                var item = pedidos[index].listaItens[indexItem];
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.produto!.name),
                                    Text('${item.quantidade.toString()}x'),
                                    Text('R\$ ${item.produto!.value.toStringAsFixed(2).replaceAll('.', ',')}'),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          Text("Local de Entrega", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Container(
                            height: 400,
                            width: 400,
                            padding: const EdgeInsets.all(8.0),
                            child: GridView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Rua"),
                                      Spacer(),
                                      Text(pedidos[index].rua),
                                  ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Número"),
                                      Spacer(),
                                      Text(pedidos[index].numero),
                                  ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Complemento"),
                                      Spacer(),
                                      Text(pedidos[index].complemento ?? "N/A"),
                                  ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("CEP"),
                                      Spacer(),
                                      Text(pedidos[index].cep),
                                  ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Bairro"),
                                      Spacer(),
                                      Text(pedidos[index].bairro),
                                  ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Cidade"),
                                      Spacer(),
                                      Text(pedidos[index].cidade),
                                  ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Estado"),
                                      Spacer(),
                                      Text(pedidos[index].estado),
                                  ],
                                  ),
                                ),
                              ]
                            ),
                          )
                        ],
                      ),
                      actions: [           
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();

                            _removePedido(pedidos[index].id!);
                          },
                          child: const Text("Remover Pedido"),
                        ),
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(pedidos[index].data.toString()),
                      Text(pedidos[index].parcelas == null ? "À vista" : "${pedidos[index].parcelas}x")
                    ],
                  ),
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