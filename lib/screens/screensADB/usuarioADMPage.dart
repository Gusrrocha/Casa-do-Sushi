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
      appBar: AppBar(title: Text("Usuários"),),
      body: Column(
        children: [
          if (usuarioList.isNotEmpty)
            ListView.builder(
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
                            /*IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        builder: (context) => EditUsuario(id: usuarioList[index].id!, usuarioList: usuarioList[index]),
                                      );
                                      refreshTable();
                                    },
                                  ),*/
                            if(usuarioList[index].isAdmin != 1)
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await usuarioRepository.deleteUser(
                                    usuarioList[index].id!,
                                  );
                                  refreshTable();
                                },
                              ),
                          ],
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
