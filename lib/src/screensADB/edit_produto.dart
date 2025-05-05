import 'package:CasadoSushi/database/database.dart';
import 'package:CasadoSushi/models/sushi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProduto extends StatefulWidget{
  final int id;
  final Sushi sushi;
  const EditProduto({super.key, required this.id, required this.sushi});

  @override
  EditProdutoState createState() => EditProdutoState();


}

class EditProdutoState extends State<EditProduto>{
  late Sushi sushi_copy;
  SushiDatabase sushiDatabase = SushiDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  
  

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
      Sushi sushi_copy = widget.sushi; 
      Sushi sushi = Sushi(
        id: sushi_copy.id,
        photo: sushi_copy.photo,
        name: _nameController.text, 
        description: _descriptionController.text, 
        value: !_valueController.text.contains(',') ? double.parse(_valueController.text) : double.parse(_valueController.text.replaceAll(',', '.'))
      );
      sushiDatabase.updateSushi(sushi, widget.id);
      _nameController.clear();
      _descriptionController.clear();
      _valueController.clear();
      setState(() {
        
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Produto Atualizado com Sucesso!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    Sushi sushi_copy = widget.sushi; 
    _nameController.text = sushi_copy.name;
    _descriptionController.text = sushi_copy.description!;
    _valueController.text = sushi_copy.value.toString();
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
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\,?\d{0,2}')),],
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