import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db.dart';

class DatabaseHelper {
  static const _databaseName = 'student.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String databasePath = join(dataDirectory.path, _databaseName);
    return await openDatabase(databasePath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database database, int version) async {
    await database.execute('''
      CREATE TABLE ${Student.table} (
        ${Student.col_Id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Student.col_name} TEXT NOT NULL,
        ${Student.col_place} TEXT NOT NULL,
        ${Student.col_email} TEXT NOT NULL
        )''');
  }

  Future<int> insertStudent(Student student) async {
    Database database = await this.database;
    return await database.insert(Student.table, student.toMap());
  }

  Future<List<Student>> getAllStudents() async {
    Database database = await this.database;
    List<Map> students = await database.query(
      Student.table,
    );
    return students.isEmpty
        ? []
        : students.map((e) => Student.fromMap(e)).toList();
  }

  Future<int> updateStudent(Student student) async {
    Database database = await this.database;
    return await database.update(
      Student.table,
      student.toMap(),
      where: '${Student.col_Id}=?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    Database database = await this.database;
    return await database.delete(
      Student.table,
      where: '${Student.col_Id}=?',
      whereArgs: [id],
    );
  }

  Future<List<Student>> searchStudent(String name) async {
    Database database = await this.database;
    List<Map> students = await database.query(
      Student.table,
      where: '${Student.col_name} LIKE ?',
      whereArgs: ['%' + name + '%'],
    );
    return students.isEmpty
        ? []
        : students.map((e) => Student.fromMap(e)).toList();
  }
}
