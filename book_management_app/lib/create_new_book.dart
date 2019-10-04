import 'package:book_management_app/book_item.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:sqflite/sql.dart';

class CreateNewBook extends StatelessWidget {

  void main() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'books_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE books(id INTEGER PRIMARY KEY, title TEXT, currentPage INTEGER, numPages INTEGER, timeRead INTEGER)",
        );
      },
      version: 1,
    );

    Future<void> insertDog(BookItem bookItem) async {
      final Database db = await database;
      await db.insert(
        'books',
        bookItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create new book", style: TextStyle(color: Colors.blue)),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {Navigator.pop(context);},
        )
      ),
    );
  }

}