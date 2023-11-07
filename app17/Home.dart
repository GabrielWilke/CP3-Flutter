import 'package:flutter/material.dart';
import 'helper/GroceryHelper.dart';
import 'model/Grocery.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _qtdController = TextEditingController();
  var _db = GroceryHelper();
  List<Grocery> _grocery = List<Grocery>();

  _showAddScreen({Grocery grocery}) {
    String textSaveUpdate = "";
    if (grocery == null) {
      //salvando
      _titleController.text = "";
      _qtdController.text = "";
      textSaveUpdate = "Salvar";
    } else {
      //atualizar
      _titleController.text = grocery.title;
      _qtdController.text = grocery.qtd;
      textSaveUpdate = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("$textSaveUpdate item"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Produto", hintText: "Digite o produto"),
                ),
                TextField(
                  controller: _qtdController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Quantidade", hintText: "Digite a quantidade"),
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
                    _saveUpdateItem(selectedItem: grocery);

                    Navigator.pop(context);
                  },
                  child: Text(textSaveUpdate))
            ],
          );
        });
  }

  _recoverGroceryList() async {
    List recoveredList = await _db.recoverGroceryList();

    List<Grocery> auxList = List<Grocery>();
    for (var item in recoveredList) {
      Grocery grocery = Grocery.fromMap(item);
      auxList.add(grocery);
    }

    setState(() {
      _grocery = auxList;
    });
    auxList = null;

    //print("Lista anotacoes: " + recoveredList.toString() );
  }

  _saveUpdateItem({Grocery selectedItem}) async {
    String title = _titleController.text;
    String qtd = _qtdController.text;

    if (selectedItem == null) {
      //salvar
      Grocery grocery = Grocery(title, qtd, DateTime.now().toString());
      int result = await _db.saveItem(grocery);
    } else {
      //atualizar
      selectedItem.title = title;
      selectedItem.qtd = qtd;
      selectedItem.date = DateTime.now().toString();
      int result = await _db.updateItem(selectedItem);
    }

    _titleController.clear();
    _qtdController.clear();

    _recoverGroceryList();
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

  _removeItem(int id) async {
    await _db.removeItem(id);

    _recoverGroceryList();
  }

  @override
  void initState() {
    super.initState();
    _recoverGroceryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Compras"),
        backgroundColor: Colors.orange[900],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _grocery.length,
                  itemBuilder: (context, index) {
                    final grocery = _grocery[index];

                    return Card(
                      child: ListTile(
                        title: Text(grocery.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _showAddScreen(grocery: grocery);
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
                                _removeItem(grocery.id);
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
          backgroundColor: Colors.orange[900],
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () {
            _showAddScreen();
          }),
    );
  }
}