import 'package:flutter/material.dart';
import 'package:tarefas_app/models/tarefa.model.dart';
import 'package:tarefas_app/repositories/tarefa.repository.dart';
import 'package:tarefas_app/views/nova.page.dart';

class ListaPage extends StatefulWidget {
  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  final repository = TarefaRepository();

  List<Tarefa> tarefas;

  @override
  initState() {
    super.initState();
    this.tarefas = repository.read();
  }

  Future adicionarTarefa(BuildContext context) async {
    var result = await Navigator.of(context).pushNamed('/nova');
    if (result == true) {
      setState(() {
        this.tarefas = repository.read();
      });
    }
  }

  Future editaTarefa(BuildContext context, Tarefa tarefa) async {
    {
    var result = await Navigator.of(context).pushNamed('/edita', arguments: tarefa);
    if(result) {
      setState(() => tarefas = repository.read());                     
    }
  }
}

  bool canEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        centerTitle: false,
        actions: [
          IconButton(icon: Icon(Icons.edit),
            onPressed: () => setState(() => canEdit = !canEdit)
           ),
        ],
      ),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (_, indice) {
          var tarefa = tarefas[indice];
          return Dismissible(
            key: Key(tarefa.texto),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (_) {
              repository.delete(tarefa.texto);
              setState(() {
                 this.tarefas.remove(tarefa);
              });
            }, 
            // confirmDismiss: (direction) =>, // TODO
            child: CheckboxListTile(
              title: Row(
                children: [
                  canEdit ? 
                    IconButton(icon: Icon(Icons.edit),
                     onPressed: () => editaTarefa(context, tarefa),
                    ) : Container(),
                  Text(
                    tarefa.texto,
                    style: TextStyle(
                      decoration: tarefa.finalizada
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
              value: tarefa.finalizada,
              onChanged: (value) {
                setState(() => tarefa.finalizada = value);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => adicionarTarefa(context),
      ),
    );
  }
}
 