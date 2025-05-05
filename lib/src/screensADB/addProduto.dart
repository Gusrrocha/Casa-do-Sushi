import 'package:CasadoSushi/database/database.dart';
import 'package:CasadoSushi/models/sushi.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AdicionarProduto extends StatefulWidget{
  const AdicionarProduto({super.key});

  @override
  AdicionarProdutoState createState() => AdicionarProdutoState();


}

class AdicionarProdutoState extends State<AdicionarProduto>{
  
  SushiDatabase sushiDatabase = SushiDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();

  final _valueFormatter = MaskTextInputFormatter(mask: '####.##', filter: {"#": RegExp(r'[0-9]+')});

  @override
  void initState() {
    super.initState();
  }
  
  @override
  dispose(){
    sushiDatabase.close();
    super.dispose();
  }

  void saveForm(){
    if(_formKey.currentState!.validate()){
      Sushi sushi = Sushi(name: _nameController.text, description: _descriptionController.text, value: double.parse(_valueController.text));
      sushiDatabase.createSushi(sushi);
      _nameController.clear();
      _descriptionController.clear();
      _valueController.clear();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Produto Adicionado com Sucesso!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      builder:(context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Form(
            key: _formKey,
            child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: 30.0,
                height: 3.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(24.0)
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Nome do Produto',
                        border: OutlineInputBorder()
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite o nome do produto.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Descrição do Produto',
                        border: OutlineInputBorder()
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite a descrição do produto.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _valueController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Valor do Produto',
                        border: OutlineInputBorder()
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [_valueFormatter],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite o valor do produto.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: saveForm,
                    child: const Text('Salvar'),
                  )
                  ],
                ),
              )
           ]
          )
          )
        );
      },   
      );
  }
}