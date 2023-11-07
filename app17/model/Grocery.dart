import 'helper/GroceryHelper.dart';

class Grocery {
  int id;
  String title;
  String qtd;
  String date;

  Grocery(this.title, this.qtd, this.date);

  Grocery.fromMap(Map map) {
    this.id = map["id"];
    this.title = map["title"];
    this.qtd = map["qtd"];
    this.date = map["date"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "title": this.title,
      "qtd": this.qtd,
      "date": this.date,
    };

    if (this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }
}