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
  @override
  void initState() {
    _getPedidos();
    super.initState();
  }

  _getPedidos() async {
    List<Pedido> pedidosTemp = await pedidoRepository.listPedido();
    Map<int, int> vendasPorProdutoTemp = {};
    for (var pedido in pedidosTemp) {
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
    });

  }

  @override
  Widget build(BuildContext context) {
    final total = resultado.entries.fold<int>(0, (previousValue, element) => previousValue + element.value);
    final safeTotal = total == 0 ? 1 : total;
    return Scaffold(
      body: Container(
        height: 600,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.fromLTRB(4.0, 1.5, 4.0, 10),
        padding: const EdgeInsets.all(10),
        child: Column(
            children: [
              Container(
                height: 200,
                width: 300,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
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
                      pedidos.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: pedidos[index].valor!.toDouble(),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              resultado.isEmpty
              ? const Text("Nenhum produto vendido")
              :
              Container(
                height: 250,
                width: 250,
                child: PieChart(
                  PieChartData(
                    sections: resultado.entries.map((entry){
                      final porcentagem = (entry.value / safeTotal) * 100;
                        return PieChartSectionData(
                          color: Colors.primaries[resultado.keys.toList().indexOf(entry.key) % Colors.primaries.length],
                          value: entry.value.toDouble(),
                          title: '${entry.key.name}\n${porcentagem.toStringAsFixed(1)}%',
                          radius: 60,
                          titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                        );
                      }
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
