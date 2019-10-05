import 'dart:async';

import 'package:book_management_app/sqlite/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'book_item.dart';

class TimePage extends StatefulWidget {

  TimePageState createState() => TimePageState();

}

class TimePageState extends State<TimePage> {

  String time = "00:00:00";
  int bookId = 1;
  String strTimeOverAll = "00:00:00";
  int intTimeOverAll = 0;
  String bookTitle = "Origin Story. A Big History of Everything";
  int bookTotalPages = 322;
  int bookReadPages = 119;

  var swatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  Future<List<BookItem>> books;
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      books = dbHelper.getBooks();
    });
  }

  void startTimer() {
    Timer(duration, keepRunning);
  }

  void keepRunning() {
    if (swatch.isRunning) {
      startTimer();
    }
    setState(() {
      time = swatch.elapsed.inHours.toString().padLeft(2, "0") + ":" 
              + (swatch.elapsed.inMinutes%60).toString().padLeft(2, "0") + ":"
              + (swatch.elapsed.inSeconds%60).toString().padLeft(2, "0");
    });
  }

  void startStopStopWatch() {
    if (swatch.isRunning) {
      swatch.stop();
    } else {
      swatch.start();
      startTimer();
    }
  }

  showPickerNumber(BuildContext context) {
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: bookReadPages, end: bookTotalPages),
        ]),
        delimiter: [
          PickerDelimiter(child: Container(
            alignment: Alignment.center,
          ))
        ],
        hideHeader: true,
        title: new Text("Current book page"),
        onConfirm: (Picker picker, List value) {
          setState(() {
            bookReadPages = int.parse(picker.getSelectedValues()[0].toString());
            dbHelper.update(BookItem(bookId, bookTitle, bookReadPages, bookTotalPages, intTimeOverAll));
          });
          print(value.toString());
          print(picker.getSelectedValues());
        }
    ).showDialog(context);
  }

  SingleChildScrollView dataTable(List<BookItem> bookItems) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text('NAME')),
        ],
        rows: bookItems.map((bookItem) => DataRow(
          cells: [
            DataCell(
              Text(bookItem.title),
              onTap: () {
                setState(() {
                  bookId = bookItem.id;
                  bookReadPages = bookItem.currentPage;
                  bookTotalPages = bookItem.numPages;
                  bookTitle = bookItem.title; 
                  intTimeOverAll = bookItem.timeRead;

                  int seconds = bookItem.timeRead;
                  seconds = seconds % (24 * 3600); 
                  int hourFormat = (seconds / 3600).toInt();

                  seconds %= 3600; 
                  int minutesFormat = (seconds / 60).toInt();

                  seconds %= 60; 
                  int secondsFormat = seconds;

                  strTimeOverAll = hourFormat.toString().padRight(2, "0") + ":"
                                  + minutesFormat.toInt().toString().padLeft(2, "0") + ":"
                                  + secondsFormat.toInt().toString().padLeft(2, "0");
                });
              }
            ),
          ]
        )).toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  timeCard() {
    return Card(
      child: Container(
                padding: EdgeInsets.all(11.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      
                      GestureDetector(
                        onTap: () {showPickerNumber(context);},
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "current time",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Helvetica",
                                ),
                              ),
                            ),

                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                              ),
                            ),
                          ],
                        ),
                      ),

                      VerticalDivider(
                        thickness: 2.0,
                      ),

                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "total time",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Helvetica",
                              ),
                            ),
                          ),
                          Text(
                            strTimeOverAll,
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              )
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[

            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Center(
                child: Text(
                  bookTitle,
                  style: TextStyle(
                    fontSize: 25.0
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            timeCard(),

            Card(
              child: Container(
                padding: EdgeInsets.all(11.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      
                      GestureDetector(
                        onTap: () {showPickerNumber(context);},
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "Read Pages",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Helvetica",
                                ),
                              ),
                            ),

                            Text(
                              bookReadPages.toString(),
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                              ),
                            ),
                          ],
                        ),
                      ),

                      VerticalDivider(
                        thickness: 2.0,
                      ),

                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "Total Pages",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Helvetica",
                              ),
                            ),
                          ),
                          Text(
                            bookTotalPages.toString(),
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              )
            ),

            list(),
            
          ], 
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(swatch.isRunning?Icons.stop:Icons.fiber_manual_record, size: 20),
        label: Text(swatch.isRunning?"Stop":"Record"),
        backgroundColor: Colors.red,
        onPressed: startStopStopWatch,
      ),
    );
  }

}