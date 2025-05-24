import 'package:casadosushi/models/pedido.dart';
import 'package:casadosushi/models/produto.dart';
import 'package:casadosushi/repositories/pedido_repository.dart';
import 'package:casadosushi/repositories/produto_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    _getPedidos();
    super.initState();
  }

  _getPedidos() async {
    List<Pedido> pedidosTemp = await pedidoRepository.listPedido();
    Map<int, int> vendasPorProdutoTemp = {};
    for (var pedido in pedidosTemp) {
      datasQuant.update(
        pedido.data, 
        (value) => value + 1, 
        ifAbsent: () => 1);
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
      appBar: AppBar(title: Text("Relatórios")),
      body: Container(
        height: 800,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.fromLTRB(4.0, 1.5, 4.0, 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Spacer(),
            SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  if (totalDataEntries.isNotEmpty)
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: BarChart(
                    BarChartData(
                      maxY: total*1.5,
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: true),
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
                          axisNameWidget: Text("Valor (R\$)"),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: Text("Data"),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index < pedidos.length) {
                                return Text(pedidos[index].data);
                              } else {
                                return const Text("");
                              }
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(
                        totalDataEntries.length,
                        (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: totalDataEntries.isNotEmpty ? double.parse(totalDataEntries[index].value.toStringAsFixed(2)) : 0.0,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              resultado.isEmpty
                  ? Column(children: [
                    SizedBox(height: 200), 
                    Icon(Icons.money_off,size: 70),
                    Text("Nenhum produto vendido")
                  ])
                  : 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Vendas por Produto (%)"),
                  ),
              SizedBox(height: 20),                
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: PieChart(
                    PieChartData(
                      sections:
                          resultado.entries.map((entry) {
                            final porcentagem = (entry.value / safeTotal) * 100;
                            return PieChartSectionData(
                              color:
                                  Colors.primaries[resultado.keys.toList().indexOf(
                                        entry.key,
                                      ) %
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
            )
          ],
        ),
      ),
    );
  }
}
