import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite/sqflite.dart';

class BooksPage extends StatelessWidget {

  final List<String> entries = <String>['Book 1', 'Book 2', 'Book 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Container(
              child: Text('Entry ${entries[index]}'),
              height: 50,
              ),
            onTap: () => Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text(entries[index]))),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}