import 'package:casadosushi/models/produto.dart';
import 'package:casadosushi/repositories/produto_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdicionarProduto extends StatefulWidget{
  const AdicionarProduto({super.key});

  @override
  AdicionarProdutoState createState() => AdicionarProdutoState();


}

class AdicionarProdutoState extends State<AdicionarProduto>{
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  ProdutoRepository produtoRepository = ProdutoRepository();

  @override
  void initState() {
    super.initState();
  }
  

  void saveForm(){
    if(_formKey.currentState!.validate()){
      Produto produto = Produto(
        name: _nameController.text, 
        description: _descriptionController.text, 
        value: !_valueController.text.contains(',') ? double.parse(_valueController.text) : double.parse(_valueController.text.replaceAll(',', '.'))
      );
      produtoRepository.createProduto(produto);
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
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width *.9,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color.fromARGB(255, 204, 96, 82).withAlpha(64)
                      ),
                      child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(  
                          labelText: 'Nome do Produto',
                          border: InputBorder.none
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o nome do produto.';
                        }
                        return null;
                      },
                                        ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *.9,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color.fromARGB(255, 204, 96, 82).withAlpha(64)
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            labelText: 'Descrição do Produto',
                            border: InputBorder.none
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite a descrição do produto.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *.9,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color.fromARGB(255, 204, 96, 82).withAlpha(64)
                      ),
                      child: TextFormField(
                        controller: _valueController,
                        decoration: const InputDecoration(
                            labelText: 'Valor do Produto',
                            border: InputBorder.none
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\,?\d{0,2}')),],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o valor do produto.';
                          }
                          return null;
                        },
                      ),
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