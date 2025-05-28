import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/database/auth.dart';
import 'package:casadosushi/models/item.dart';
import 'package:casadosushi/models/pedido.dart';
import 'package:casadosushi/repositories/item_repository.dart';
import 'package:casadosushi/repositories/pedido_repository.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:casadosushi/screens/compra/components/cartao.dart';
import 'package:casadosushi/screens/compra/components/endereco.dart';
import 'package:casadosushi/screens/compra/components/paginaInicial.dart';
import 'package:casadosushi/screens/compra/components/sumario.dart';
import 'package:casadosushi/screens/compra/components/tabelaMeses.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CompraPage extends StatefulWidget {
  const CompraPage({super.key, required this.itens});

  final List<Item> itens;

  @override
  CompraPageState createState() => CompraPageState();
}

class CompraPageState extends State<CompraPage> {
  int _passo = 0;
  final TextEditingController cartaoController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();

  final UsuarioRepository usuarioRepository = UsuarioRepository();
  final Auth auth = Auth();
  final List payments = ["Dinheiro", "Cartão de crédito", "Cartão de débito"];
  final PedidoRepository pedidoRepository = PedidoRepository();
  final ItemRepository itemRepository = ItemRepository();

  final _cartaoFormatter = MaskTextInputFormatter(
    mask: "#### #### #### ####",
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _validadeFormatter = MaskTextInputFormatter(
    mask: "##/##",
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cvvFormatter = MaskTextInputFormatter(
    mask: "###",
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cpfFormatter = MaskTextInputFormatter(
    mask: "###.###.###-##",
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cepFormatter = MaskTextInputFormatter(
    mask: "#####-###",
    filter: {"#": RegExp(r'[0-9]')},
  );

  String paymentMethod = "";
  int selectedMonth = 0;
  void goToStep(int passo) {
    setState(() {
      _passo = passo;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _formKeyEndereco = GlobalKey<FormState>();

  _finalizarCompra(double valorTotal) async {
    DateTime data = DateTime.now();
    String formattedDate =
        "${data.day}/${data.month}/${data.year} ${data.hour}:${data.minute}";
    Pedido pedido = Pedido(
      listaItens: widget.itens,
      idUsuario: await usuarioRepository.getUserIdByUID(
        await auth.usuarioAtual(),
      ),
      data: formattedDate,
      valor: valorTotal,
      paymentMethod: paymentMethod,
      parcelas: paymentMethod == "Cartão de crédito" ? selectedMonth : null,
      status: Status.emPreparo,
      cep: cepController.text,
      rua: ruaController.text,
      numero: numeroController.text,
      complemento: complementoController.text,
      bairro: bairroController.text,
      cidade: cidadeController.text,
      estado: estadoController.text,
    );

    final pedidoNew = await pedidoRepository.createPedido(pedido);
    for (var item in widget.itens) {
      item.idPedido = pedidoNew.id;
      await itemRepository.createItem(item);
    }
  }

  Widget _buildStep() {
    switch (_passo) {
      case 0:
        return PaginaInicial(
          prosseguir: (String metodo) {
            setState(() {
              paymentMethod = metodo;
            });
            if (paymentMethod == "Cartão de crédito" ||
                paymentMethod == "Cartão de débito") {
              goToStep(1);
            } else {
              goToStep(3);
            }
          },
        );
      case 1:
        return Cartao(
          formKey: _formKey,
          cartaoController: cartaoController,
          nomeController: nomeController,
          validadeController: validadeController,
          cvvController: cvvController,
          cpfController: cpfController,
          cartaoFormatter: _cartaoFormatter,
          validadeFormatter: _validadeFormatter,
          cvvFormatter: _cvvFormatter,
          cpfFormatter: _cpfFormatter,
          prosseguir: () {
            if (paymentMethod == "Cartão de crédito") {
              goToStep(2);
            } else {
              goToStep(3);
            }
          },
        );
      case 2:
        return TabelaMeses(
          itens: widget.itens,
          prosseguir: (index) {
            setState(() {
              selectedMonth = index;
            });
            goToStep(3);
          },
        );
      case 3:
        return Endereco(
          formKeyEndereco: _formKeyEndereco,
          cepController: cepController,
          cepFormatter: _cepFormatter,
          estadoController: estadoController,
          complementoController: complementoController,
          cidadeController: cidadeController,
          bairroController: bairroController,
          ruaController: ruaController,
          numeroController: numeroController,
          prosseguir: () => goToStep(4),
        );
      case 4:
        return Sumario(
          itens: widget.itens,
          paymentMethod: paymentMethod,
          selectedMonth: selectedMonth,
          prosseguir: (valorTotal) async {
            await _finalizarCompra(valorTotal);
            if (!mounted) return;
            final carrinhoprovider = Provider.of<CarrinhoProvider>(
              context,
              listen: false,
            );

            carrinhoprovider.clearCarrinho();
            goToStep(5);
          },
        );
      case 5:
        return telaFinal();
      default:
        return const Text("Nenhum passo encontrado");
    }
  }

  Widget telaFinal() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 120),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Compra finalizada com sucesso!"),
            ),
            SizedBox(height: 20),
            Container(
              height: 55,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 204, 96, 82),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Voltar para o início",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _passo == 0
                ? Text(
                  "Selecionar Método de Pagamento",
                  style: TextStyle(color: Colors.white),
                )
                : _passo == 1
                ? Text(
                  "Inserir Dados do Cartão",
                  style: TextStyle(color: Colors.white),
                )
                : _passo == 2
                ? Text(
                  "Selecionar parcelas",
                  style: TextStyle(color: Colors.white),
                )
                : _passo == 3
                ? Text("Endereço", style: TextStyle(color: Colors.white))
                : _passo == 4
                ? Text("Sumário", style: TextStyle(color: Colors.white))
                : Text(''),
        elevation: _passo == 5 ? 0 : 1,
        backgroundColor:
            _passo == 5 ? Colors.lightGreen : Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _passo != 5 ? Colors.white : Colors.black,
          ),
          onPressed: () {
            if (_passo == 0 || _passo == 5) {
              Navigator.pop(context); // leave screen
            } else {
              if (_passo == 3) {
                if (paymentMethod == "Dinheiro") {
                  setState(() {
                    _passo -= 3;
                  });
                }
                if (paymentMethod == "Cartão de débito") {
                  setState(() {
                    _passo -= 2;
                  });
                }
                if (paymentMethod == "Cartão de crédito") {
                  setState(() {
                    _passo -= 1;
                  });
                }
                cepController.clear();
                numeroController.clear();
                complementoController.clear();
                bairroController.clear();
                cidadeController.clear();
                estadoController.clear();
              } else {
                if ((paymentMethod == "Cartão de crédito" ||
                        paymentMethod == "Cartão de débito") &&
                    _passo == 1) {
                  cartaoController.clear();
                  validadeController.clear();
                  cvvController.clear();
                  nomeController.clear();
                  cpfController.clear();
                }
                setState(() {
                  _passo -= 1; // go back one step
                });
              }
            }
          },
        ),
      ),
      backgroundColor:
          _passo == 5
              ? Colors.lightGreen.shade100
              : const Color.fromARGB(255, 250, 250, 250),
      body: _buildStep(),
    );
  }
}
