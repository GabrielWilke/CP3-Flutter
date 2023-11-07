import 'package:app_15_lista_de_tarefas/helper/TasksHelper.dart';

class Tasks {
  int id;
  String title;
  String date;

  Tasks(this.title, this.date);

  Tasks.fromMap(Map map) {
    this.id = map["id"];
    this.title = map["title"];
    this.date = map["date"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "title": this.title,
      "date": this.date,
    };

    if (this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }
}