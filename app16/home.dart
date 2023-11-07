import 'package:flutter/material.dart';
import 'helper/TasksHelper.dart';
import 'model/Tasks.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _titleController = TextEditingController();
  var _db = TasksHelper();
  List<Tasks> _tasks = List<Tasks>();

  _showAddScreen({Tasks task}) {
    String textSaveUpdate = "";
    if (task == null) {
      //salvando
      _titleController.text = "";
      textSaveUpdate = "Salvar";
    } else {
      //atualizar
      _titleController.text = task.title;
      textSaveUpdate = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("$textSaveUpdate tarefa"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Título", hintText: "Digite título..."),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")),
              FlatButton(
                  onPressed: () {
                    //salvar
                    _saveUpdateTask(selectedTask: task);

                    Navigator.pop(context);
                  },
                  child: Text(textSaveUpdate))
            ],
          );
        });
  }

  _recoverTasks() async {
    List recoveredTasks = await _db.recoverTasks();

    List<Tasks> auxTasks = List<Tasks>();
    for (var item in recoveredTasks) {
      Tasks task = Tasks.fromMap(item);
      auxTasks.add(task);
    }

    setState(() {
      _tasks = auxTasks;
    });
    auxTasks = null;

    //print("Lista anotacoes: " + recoveredTasks.toString() );
  }

  _saveUpdateTask({Tasks selectedTask}) async {
    String title = _titleController.text;

    if (selectedTask == null) {
      //salvar
      Tasks task = Tasks(title, DateTime.now().toString());
      int result = await _db.saveTask(task);
    } else {
      //atualizar
      selectedTask.title = title;
      selectedTask.date = DateTime.now().toString();
      int result = await _db.updateTask(selectedTask);
    }

    _titleController.clear();

    _recoverTasks();
  }

  _formatDate(String date) {
    initializeDateFormatting("pt_BR");

    //Year -> y month-> M Day -> d
    // Hour -> H minute -> m second -> s
    //var formatter = DateFormat("d/MMMM/y H:m:s");
    var formatter = DateFormat.yMd("pt_BR");

    DateTime convertedDate = DateTime.parse(date);
    String formattedDate = formatter.format(convertedDate);

    return formattedDate;
  }

  _deleteTask(int id) async {
    await _db.removeTask(id);

    _recoverTasks();
  }

  @override
  void initState() {
    super.initState();
    _recoverTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];

                    return Card(
                      child: ListTile(
                        title: Text(task.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _showAddScreen(task: task);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _deleteTask(task.id);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () {
            _showAddScreen();
          }),
    );
  }
}