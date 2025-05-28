import 'package:casadosushi/models/pedido.dart';
import 'package:casadosushi/models/produto.dart';
import 'package:casadosushi/repositories/pedido_repository.dart';
import 'package:casadosushi/repositories/produto_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Relatorios extends StatefulWidget {
  const Relatorios({super.key});

  @override
  RelatoriosState createState() => RelatoriosState();
}

class RelatoriosState extends State<Relatorios> {
  final PedidoRepository pedidoRepository = PedidoRepository();
  List<Pedido> pedidos = [];
  final ProdutoRepository produtoRepository = ProdutoRepository();
  Map<int, int> vendasPorProduto = {};
  Map<Produto, int> resultado = {};
  Map<String, int> datasQuant = {};
  Map<String, double> totalData = {};
  List<MapEntry<String, double>> totalDataEntries = [];

  double total = 0.0;
  final int diasAMostrar = 7;
  List<Pedido> ultimosPedidos = [];
  List<MapEntry<String, double>> ultimosDataEntries = [];
  @override
  void initState() {
    _getPedidos();
    super.initState();
  }

  _getPedidos() async {
    List<Pedido> pedidosTemp = await pedidoRepository.listPedido();
    Map<int, int> vendasPorProdutoTemp = {};
    for (var pedido in pedidosTemp) {
      datasQuant.update(pedido.data, (value) => value + 1, ifAbsent: () => 1);
      totalData.update(
        pedido.data,
        (value) => value + (pedido.valor ?? 0.0),
        ifAbsent: () => pedido.valor ?? 0.0,
      );
      total += pedido.valor ?? 0.0;
      for (var item in pedido.listaItens) {
        vendasPorProdutoTemp.update(
          item.idProduto,
          (value) => value + item.quantidade,
          ifAbsent: () => item.quantidade,
        );
      }
    }
    Map<Produto, int> resultadoTemp = {};
    for (var entry in vendasPorProdutoTemp.entries) {
      Produto produto = await produtoRepository.getProdutoById(entry.key);
      resultadoTemp[produto] = entry.value;
    }

    setState(() {
      pedidos = pedidosTemp;
      vendasPorProduto = vendasPorProdutoTemp;
      resultado = resultadoTemp;
      totalDataEntries = totalData.entries.toList();
      ultimosDataEntries =
          totalDataEntries.length > diasAMostrar
              ? totalDataEntries.sublist(totalDataEntries.length - diasAMostrar)
              : totalDataEntries;
      ultimosPedidos =
          pedidos.length > diasAMostrar
              ? pedidos.sublist(pedidos.length - diasAMostrar)
              : pedidos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quantTotal = resultado.entries.fold<int>(
      0,
      (previousValue, element) => previousValue + element.value,
    );
    final safeTotal = total == 0 ? 1 : quantTotal;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 193, 193),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 193, 193),
        title: Text("Relatórios"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.fromLTRB(4.0, 1.5, 4.0, 10),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  if (totalDataEntries.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color.fromARGB(96, 117, 117, 117),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          minY: 0.0,
                          lineTouchData: LineTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              axisNameWidget: Text("Vendas por dia (R\$)"),
                              sideTitles: SideTitles(showTitles: false),
                              axisNameSize: 24,
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 60,
                                getTitlesWidget: (value, meta) {
                                  final currencyFormatter =
                                      NumberFormat.currency(
                                        locale: "pt_BR",
                                        symbol: "R\$",
                                        decimalDigits: 2,
                                      );
                                  return Text(
                                    currencyFormatter.format(value),
                                    style: TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index < ultimosPedidos.length) {
                                    return Transform.rotate(
                                      angle: -0.5,
                                      child: Text(
                                        ultimosPedidos[index].data.substring(
                                          0,
                                          4,
                                        ),
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    );
                                  } else {
                                    return const Text("");
                                  }
                                },
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                ultimosDataEntries.length,
                                (index) => FlSpot(
                                  index.toDouble(),
                                  ultimosDataEntries.isNotEmpty
                                      ? double.parse(
                                        ultimosDataEntries[index].value
                                            .toStringAsFixed(2),
                                      )
                                      : 0.0,
                                ),
                              ),
                              isCurved: true,
                              color: const Color.fromRGBO(33, 150, 243, 1),
                              barWidth: 2,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Color.fromARGB(64, 33, 150, 243),
                              ),
                            ),
                          ],
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  resultado.isEmpty
                      ? Column(
                        children: [
                          SizedBox(height: 100),
                          Icon(Icons.money_off, size: 70),
                          Text("Nenhum produto vendido"),
                        ],
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vendas por Produto (%)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromARGB(96, 117, 117, 117),
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: PieChart(
                              PieChartData(
                                sections:
                                    resultado.entries.map((entry) {
                                      final porcentagem =
                                          (entry.value / safeTotal) * 100;
                                      return PieChartSectionData(
                                        color:
                                            Colors.primaries[resultado.keys
                                                    .toList()
                                                    .indexOf(entry.key) %
                                                Colors.primaries.length],
                                        value: entry.value.toDouble(),
                                        title:
                                            '${entry.key.name}\n${porcentagem.toStringAsFixed(1)}%',
                                        radius: 60,
                                        titleStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
