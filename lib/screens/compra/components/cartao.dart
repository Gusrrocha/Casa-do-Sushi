import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Cartao extends StatelessWidget {
  final Function prosseguir;
  final GlobalKey<FormState> formKey;
  final TextEditingController cartaoController;
  final TextEditingController nomeController;
  final TextEditingController validadeController;
  final TextEditingController cvvController;
  final TextEditingController cpfController;

  final MaskTextInputFormatter cartaoFormatter;
  final MaskTextInputFormatter validadeFormatter;
  final MaskTextInputFormatter cvvFormatter;
  final MaskTextInputFormatter cpfFormatter;

  const Cartao({
    super.key,
    required this.formKey,
    required this.cartaoController,
    required this.nomeController,
    required this.validadeController,
    required this.cvvController,
    required this.cpfController,
    required this.cartaoFormatter,
    required this.validadeFormatter,
    required this.cvvFormatter,
    required this.cpfFormatter,
    required this.prosseguir,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: EdgeInsets.all(12),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: cartaoController,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 16) {
                  return "Campo obrigatório";
                }
                return null;
              },
              inputFormatters: [cartaoFormatter],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: 'Número do Cartão',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    children: [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: nomeController,
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
                    text: 'Nome no Cartão',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    children: [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  width: 120,
                  child: TextFormField(
                    controller: validadeController,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 5) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                    inputFormatters: [validadeFormatter],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(
                          text: 'Validade',
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
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  width: 100,
                  child: TextFormField(
                    controller: cvvController,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                    inputFormatters: [cvvFormatter],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(
                          text: 'CVV',
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
                SizedBox(height: 20),
                Expanded(
                  child: TextFormField(
                    controller: cpfController,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 14) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                    inputFormatters: [cpfFormatter],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(
                          text: 'CPF',
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
                  if (formKey.currentState!.validate()) {
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
