import 'package:flutter/material.dart';

class CreateNewBook extends StatelessWidget {
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