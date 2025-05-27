import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Endereco extends StatelessWidget{
  final GlobalKey<FormState> formKeyEndereco;
  final TextEditingController cepController;
  final TextEditingController ruaController;
  final TextEditingController bairroController;
  final TextEditingController cidadeController;
  final TextEditingController estadoController;
  final TextEditingController numeroController;
  final TextEditingController complementoController;

  final MaskTextInputFormatter cepFormatter;
  
  final Function prosseguir;
  const Endereco({
    super.key, 
    required this.formKeyEndereco, 
    required this.cepController, 
    required this.ruaController, 
    required this.bairroController, 
    required this.cidadeController, 
    required this.estadoController, 
    required this.numeroController, 
    required this.complementoController, 
    required this.cepFormatter,
    required this.prosseguir
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(12),
      child: Form(
        key: formKeyEndereco,
        child: Column(
          children: [
            TextFormField(
              controller: cepController,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 9) {
                  return "Campo obrigatório";
                }
                return null;
              },
              inputFormatters: [cepFormatter],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: 'CEP',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    children: [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextFormField(
                      controller: ruaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo obrigatório";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: RichText(
                        text: TextSpan(
                          text: 'Rua',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                  width: 100,
                  child: TextFormField(
                    controller: numeroController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(
                          text: 'Número',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: complementoController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Complemento",
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: estadoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo obrigatório";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: RichText(
                          text: TextSpan(
                            text: 'Estado',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: ' *',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: TextFormField(
                      controller: cidadeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo obrigatório";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: RichText(
                          text: TextSpan(
                            text: 'Cidade',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: ' *',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: bairroController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Campo obrigatório";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: 'Bairro',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    children: [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width * .95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 204, 96, 82),
              ),
              child: TextButton(
                onPressed: () {
                  if (formKeyEndereco.currentState!.validate()) {
                    prosseguir();
                  }
                },
                child: Text(
                  "Prosseguir",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}