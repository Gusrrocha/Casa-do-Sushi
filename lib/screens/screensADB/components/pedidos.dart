import 'package:casadosushi/models/pedido.dart';
import 'package:casadosushi/models/usuario.dart';
import 'package:casadosushi/repositories/pedido_repository.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:casadosushi/screens/tabs/pedidosPage.dart';
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
        usuarioList = List.filled(
          value.length,
          Usuario(cpf: "1", nome: "1", telefone: "1", email: "1", senha: "1"),
        );
      });
    });
    for (int i = 0; i < pedidoList.length; i++) {
      await usuarioRepository.getUserById(pedidoList[i].idUsuario).then((
        value2,
      ) {
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
      backgroundColor: const Color.fromARGB(255, 255, 193, 193),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 193, 193),
        title: Text("Pedidos"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (usuarioList.isNotEmpty && pedidoList.isNotEmpty)
                ? Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: pedidoList.length,
                      itemBuilder:
                          (context, index) => SizedBox(
                            width: 150,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "#${pedidoList[index].id.toString()}",
                                        ),
                                        Text(usuarioList[index].nome),
                                        Text(
                                          "R\$ ${pedidoList[index].valor!.toStringAsFixed(2).replaceAll('.', ',')}",
                                        ),
                                      ],
                                    ),
                                    Spacer(),
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        StatusChips(
                                          status: pedidoList[index].status!,
                                          width: 100,
                                          height: 25,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed:
                                              (pedidoList[index].status ==
                                                          Status.aCaminho ||
                                                      pedidoList[index]
                                                              .status ==
                                                          Status.entregue ||
                                                      pedidoList[index]
                                                              .status ==
                                                          Status.cancelado)
                                                  ? null
                                                  : () async {
                                                    await pedidoRepository
                                                        .cancelarPedido(
                                                          pedidoList[index].id!,
                                                        );
                                                    refreshTable();
                                                  },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),
                )
                : Column(
                  children: [
                    Icon(Icons.receipt, size: 70),
                    Text(
                      "Sem pedidos no momento",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaler: TextScaler.linear(1.5),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
