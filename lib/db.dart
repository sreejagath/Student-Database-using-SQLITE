import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Student {
  static const table = 'students';
  static const col_Id = 'id';
  static const col_name = 'name';
  static const col_place = 'place';
  static const col_email = 'email';

  Student({this.id, this.name, this.place, this.email});

  Student.fromMap(Map<dynamic, dynamic> map) {
    id = map[col_Id];
    name = map[col_name];
    place = map[col_place];
    email = map[col_email];
  }

  int? id;
  String? name;
  String? place;
  String? email;

  Map<String, dynamic> toMap() {
    var map = {
      col_name: name,
      col_place: place,
      col_email: email,
    };
    if (id != null) map[col_Id] = id.toString();
    return map;
  }
}
