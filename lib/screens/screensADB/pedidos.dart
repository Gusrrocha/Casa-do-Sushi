import 'package:casadosushi/models/pedido.dart';
import 'package:casadosushi/models/usuario.dart';
import 'package:casadosushi/repositories/pedido_repository.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({super.key});

  @override
  PedidosState createState() => PedidosState();
}

class PedidosState extends State<Pedidos> {
  PedidoRepository pedidoRepository = PedidoRepository();
  UsuarioRepository usuarioRepository = UsuarioRepository();
  late List<Pedido> pedidoList = [];
  late List<Usuario> usuarioList = [];
  bool isLoading = true;
  @override
  void initState() {
    refreshTable();
    super.initState();
  }

  refreshTable() async {
    setState(() {
      isLoading = true;
      pedidoList = [];
      usuarioList = [];
    });


    await pedidoRepository.listPedido().then((value) {
      setState(() {
        pedidoList = value;
        usuarioList = List.filled(value.length, Usuario(cpf: "1", nome: "1", telefone: "1", email: "1", senha: "1"));
      });       
    });
    for (int i = 0; i < pedidoList.length; i++) {
        usuarioRepository.getUserById(pedidoList[i].idUsuario).then((value2) {
          setState(() {
            usuarioList[i] = value2;
          });
        });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const CircularProgressIndicator();
    return Scaffold(
      appBar: AppBar(title: Text("Pedidos"),),
      body: Column(
        children: [
          if (usuarioList.isNotEmpty && pedidoList.isNotEmpty)
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: pedidoList.length,
              itemBuilder:
                  (context, index) => Card(
                    child: ListTile(
                      leading: Text("#${pedidoList[index].id.toString()}"),
                      title: Text(usuarioList[index].nome),
                      subtitle: Text(
                        "R\$ ${pedidoList[index].valor.toString().replaceAll('.', ',')}"
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /*IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        builder: (context) => EditPedido(id: pedidoList[index].id!, pedidoList: pedidoList[index]),
                                      );
                                      refreshTable();
                                    },
                                  ),*/
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await pedidoRepository.deletePedido(
                                  pedidoList[index].id!,
                                );
                                refreshTable();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
        ],
      ),
    );
  }
}
