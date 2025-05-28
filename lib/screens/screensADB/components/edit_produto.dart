import 'package:casadosushi/models/produto.dart';
import 'package:casadosushi/repositories/produto_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProduto extends StatefulWidget {
  final int id;
  final Produto produto;
  const EditProduto({super.key, required this.id, required this.produto});

  @override
  EditProdutoState createState() => EditProdutoState();
}

class EditProdutoState extends State<EditProduto> {
  late Produto produto_copy;
  ProdutoRepository produtoRepository = ProdutoRepository();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void saveForm() {
    if (_formKey.currentState!.validate()) {
      Produto produto = Produto(
        id: produto_copy.id,
        photo: produto_copy.photo,
        name: _nameController.text,
        description: _descriptionController.text,
        value:
            !_valueController.text.contains(',')
                ? double.parse(_valueController.text)
                : double.parse(_valueController.text.replaceAll(',', '.')),
      );
      produtoRepository.updateProduto(produto, widget.id);
      _nameController.clear();
      _descriptionController.clear();
      _valueController.clear();
      setState(() {});
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produto Atualizado com Sucesso!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    produto_copy = widget.produto;
    _nameController.text = produto_copy.name;
    _descriptionController.text = produto_copy.description!;
    _valueController.text = produto_copy.value.toString().replaceAll('.', ',');
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      builder: (context, scrollController) {
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
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.sell),
                              ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * .9,
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: const Color.fromARGB(
                                  255,
                                  204,
                                  96,
                                  82,
                                ).withAlpha(64),
                              ),
                              child: TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nome do Produto',
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, digite o nome do produto.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.description),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * .9,
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: const Color.fromARGB(
                                  255,
                                  204,
                                  96,
                                  82,
                                ).withAlpha(64),
                              ),
                              child: TextFormField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Descrição do Produto',
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, digite a descrição do produto.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.attach_money),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * .9,
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: const Color.fromARGB(
                                  255,
                                  204,
                                  96,
                                  82,
                                ).withAlpha(64),
                              ),
                              child: TextFormField(
                                controller: _valueController,
                                decoration: const InputDecoration(
                                  labelText: 'Valor do Produto',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\,?\d{0,2}'),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, digite o valor do produto.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: saveForm,
                        child: const Text('Salvar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
