import 'package:casadosushi/carrinho_provider.dart';
import 'package:casadosushi/database/auth.dart';
import 'package:casadosushi/models/item.dart';
import 'package:casadosushi/models/pedido.dart';
import 'package:casadosushi/repositories/item_repository.dart';
import 'package:casadosushi/repositories/pedido_repository.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CompraPage extends StatefulWidget{
  const CompraPage({super.key, required this.itens});

  final List<Item> itens;

  @override
  CompraPageState createState() => CompraPageState();
}

class CompraPageState extends State<CompraPage>{
  int _passo = 0;
  final TextEditingController cartaoController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final UsuarioRepository usuarioRepository = UsuarioRepository();
  final Auth auth = Auth();
  final List payments = [
    "Dinheiro",
    "Cartão de crédito",
    "Cartão de débito"
  ];
  final PedidoRepository pedidoRepository = PedidoRepository();
  final ItemRepository itemRepository = ItemRepository();
  
  String paymentMethod = "";
  int selectedMonth = 0;
  void goToStep(int passo){
    setState((){
      _passo = passo;
    });
  }  

  final _formKey = GlobalKey<FormState>();  

  _finalizarCompra(double valorTotal) async{

    DateTime data = DateTime.now();
    String formattedDate = "${data.day}/${data.month}/${data.year}";
    Pedido pedido = Pedido(listaItens: widget.itens, idUsuario: await usuarioRepository.getUserByUID(await auth.usuarioAtual()), data: formattedDate, valor: valorTotal);

    final pedidoNew = await pedidoRepository.createPedido(pedido);
    for(var item in widget.itens){
      item.idPedido = pedidoNew.id;
      await itemRepository.createItem(item);
    }
    
  }

  Widget _buildStep(){
    switch(_passo){
      case 0:
        return paginaInicial();
      case 1:
        return cartaoModal();
      case 2:
        return tabelaMeses();
      case 3:
        return sumario();
      case 4:
        return telaFinal();
      default:
        return const Text("Nenhum passo encontrado");
    }
  }

  Widget paginaInicial(){
    
    return Container(
          child: Column(
          children: [
            for (var payM in payments)
              Container(
                width: 400, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(payM),
                    Spacer(),
                    Radio(
                      value: payM,
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),   
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if(paymentMethod == ""){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Selecione um método de pagamento!"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  if(paymentMethod == "Dinheiro"){
                    goToStep(3);
                  }
                  else{
                    goToStep(1);
                  }
                }, 
                child: Text("Finalizar Compra")
              )
            ],
          ),
        );
  }

  Widget cartaoModal(){
    return Container(
      height: 300,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextField(
              controller: cartaoController,
              
              decoration: InputDecoration(
                labelText: "Número do Cartão",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: validadeController,
              decoration: InputDecoration(
                labelText: "Validade (MM/AA)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: cvvController,
              decoration: InputDecoration(
                labelText: "CVV",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: "Nome no Cartão",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: cpfController,
              decoration: InputDecoration(
                labelText: "CPF",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  if(paymentMethod == "Cartão de crédito"){
                    goToStep(2);
                  }
                  else{
                    goToStep(3);
                  }
                }
              }, 
              child: Text("Continuar")
            )
          ],
        ),
      ),
    );
  }

  Widget tabelaMeses(){
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("${index + 1}"),
            onTap: () {
              setState(() {
                selectedMonth = index + 1;
              });
              goToStep(3);
            },
          );
        },
      ),
    );
  }

  Widget sumario(){
    double valorTotal = 0.0;
    if(context.read<CarrinhoProvider>().carrinho.isEmpty){
      for(var item in widget.itens){
        valorTotal += item.produto!.value * item.quantidade;
      }
    }
    else{
      valorTotal = context.read<CarrinhoProvider>().total;
    }
    return Container(
      child: Column(
        children: [
          Text("Resumo da Compra"),
          SizedBox(height: 20),
          for (var item in widget.itens)
            Text("${item.produto?.name} - R\$ ${item.produto?.value} x ${item.quantidade}"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await _finalizarCompra(valorTotal);
              if(!mounted) return;
              final carrinhoprovider = Provider.of<CarrinhoProvider>(context, listen: false);

              carrinhoprovider.clearCarrinho();
              goToStep(4);
            },
            child: Text("Finalizar Compra"),
          ),
        ],
      ),
    );
  }

  Widget telaFinal(){
    return Container(
      child: Column(
        children: [
          Text("Compra finalizada com sucesso!"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async{           
              Navigator.of(context).pop();
            },
            child: Text("Voltar para o início"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selecionar Método de Pagamento"), 
                    centerTitle: true,
                    leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      if (_passo == 0 || _passo == 4) {
                        Navigator.pop(context); // leave screen
                      } else {
                        setState(() {
                          _passo -= 1; // go back one step
                        });
                      }
                    },
                  ),
                ),
      body: Center(
        child: _buildStep()
      )
      );
  }
}
