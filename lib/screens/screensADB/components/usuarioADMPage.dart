import 'package:casadosushi/models/usuario.dart';
import 'package:casadosushi/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';

class UsuarioADMPage extends StatefulWidget {
  const UsuarioADMPage({super.key});

  @override
  UsuarioADMPageState createState() => UsuarioADMPageState();
}

class UsuarioADMPageState extends State<UsuarioADMPage> {
  UsuarioRepository usuarioRepository = UsuarioRepository();
  late List<Usuario> usuarioList = [];

  @override
  void initState() {
    refreshTable();
    super.initState();
  }

  refreshTable() {
    usuarioRepository.listUser().then((value) {
      setState(() {
        usuarioList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 193, 193),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 193, 193),
        title: Text("Usuários"),
      ),
      body: Column(
        children: [
          if (usuarioList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: usuarioList.length,
                itemBuilder:
                    (context, index) => Card(
                      child: ListTile(
                        leading: Text(usuarioList[index].id.toString()),
                        title: Text(usuarioList[index].nome),
                        subtitle: Text(usuarioList[index].email),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (usuarioList[index].isAdmin != 1)
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text('Deletar'),
                                            content: Text(
                                              'Tem certeza que quer deletar o usuário?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.of(
                                                      context,
                                                    ).pop(false), 
                                                child: Text('Não'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                  ).pop(true); 
                                                },
                                                child: Text('Sim'),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (confirm == true && mounted) {
                                      await usuarioRepository.deleteUser(usuarioList[index].id!);
                                      refreshTable();
                                    }                                  
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
