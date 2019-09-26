import 'package:flutter/material.dart';
import 'time_widget.dart';
import 'books_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Time Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Book Time Management'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title, style: TextStyle(color: Colors.blue)),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.timer, color: Colors.blue)),
                Tab(icon: Icon(Icons.book, color: Colors.blue)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              new TimePage(),
              new BooksPage(),
            ],
          ),
        ),
      ),
    );
  }
}
