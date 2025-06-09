import 'package:casadosushi/database/auth.dart';
import 'package:casadosushi/models/pedido.dart';
import 'package:casadosushi/repositories/pedido_repository.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  PedidosPageState createState() => PedidosPageState();
}

class PedidosPageState extends State<PedidosPage> {
  final PedidoRepository pedidoRepository = PedidoRepository();
  final UsuarioRepository usuarioRepository = UsuarioRepository();
  final Auth auth = Auth();

  List<Pedido> pedidos = [];

  @override
  void initState() {
    super.initState();
    _getPedidos();
  }

  _getPedidos() async {
    String uid = await auth.usuarioAtual();
    int id = await usuarioRepository.getUserIdByUID(uid);
    List<Pedido> pedidosTemp = await pedidoRepository.getAllPedidosByUserId(id);
    setState(() {
      pedidos = pedidosTemp.reversed.toList();
    });
  }

  _cancelarPedido(int id) async {
    await pedidoRepository.cancelarPedido(id);
    _getPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 182, 182),
        title: Center(child: const Text("Pedidos")),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 193, 193),
      body: Center(
        child:
            pedidos.isNotEmpty
                ? ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text("Pedido ${pedidos[index].id}"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 125,
                                      width: 400,
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount:
                                            pedidos[index].listaItens.length,
                                        itemBuilder: (context, indexItem) {
                                          var item =
                                              pedidos[index]
                                                  .listaItens[indexItem];
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(item.produto!.name),
                                              Text(
                                                '${item.quantidade.toString()}x',
                                              ),
                                              Text(
                                                'R\$ ${item.produto!.value.toStringAsFixed(2).replaceAll('.', ',')}',
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Divider(),
                                    SizedBox(height: 10),
                                    Text(
                                      "Local de Entrega",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _infoChip("Rua", pedidos[index].rua),
                                          SizedBox(height: 8),
                                          _infoChip(
                                            "Número",
                                            pedidos[index].numero,
                                          ),
                                          SizedBox(height: 8),
                                          _infoChip(
                                            "Complemento",
                                            pedidos[index].complemento ?? "N/A",
                                          ),
                                          SizedBox(height: 8),
                                          _infoChip("CEP", pedidos[index].cep),
                                          SizedBox(height: 8),
                                          _infoChip(
                                            "Bairro",
                                            pedidos[index].bairro,
                                          ),
                                          SizedBox(height: 8),
                                          _infoChip(
                                            "Cidade",
                                            pedidos[index].cidade,
                                          ),
                                          SizedBox(height: 8),
                                          _infoChip(
                                            "Estado",
                                            pedidos[index].estado,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            "Status: ",
                                            textScaler: TextScaler.linear(1),
                                          ),
                                          StatusChips(
                                            status: pedidos[index].status!,
                                            width: 100,
                                            height: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        (pedidos[index].status ==
                                                    Status.aCaminho ||
                                                pedidos[index].status ==
                                                    Status.entregue ||
                                                pedidos[index].status ==
                                                    Status.cancelado)
                                            ? null
                                            : () {
                                              Navigator.of(context).pop();

                                              _cancelarPedido(
                                                pedidos[index].id!,
                                              );
                                            },
                                    child: Text("Cancelar Pedido"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text("Fechar"),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: SizedBox(
                        height: 150,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${pedidos[index].listaItens.length} itens",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(pedidos[index].data.toString()),
                                      Text(
                                        pedidos[index].parcelas == null
                                            ? "À vista"
                                            : "${pedidos[index].parcelas}x",
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    StatusChips(
                                      status: pedidos[index].status!,
                                      width: 100,
                                      height: 25,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'R\$ ${pedidos[index].valor!.toStringAsFixed(2).replaceAll('.', ',')}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.donut_large, size: 70),
                    ),
                    Text(
                      "Você ainda não realizou nenhum pedido!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaler: TextScaler.linear(1.25),
                    ),
                  ],
                ),
      ),
    );
  }
}

class StatusChips extends StatelessWidget {
  const StatusChips({
    super.key,
    required this.status,
    required this.width,
    required this.height,
  });

  final Status status;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color:
              status == Status.emPreparo
                  ? Colors.amberAccent
                  : status == Status.aCaminho
                  ? Colors.blue
                  : status == Status.entregue
                  ? Colors.green
                  : Colors.red,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            status.label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

Widget _infoChip(String label, String value) {
  return Container(
    width: double.infinity, 
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}
