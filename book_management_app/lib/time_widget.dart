import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_picker/flutter_picker.dart';

class TimePage extends StatefulWidget {

  TimePageState createState() => TimePageState();

}

class TimePageState extends State<TimePage> {

  String time = "00:00:00";
  String bookTitle = "Origin Story. A Big History of Everything";
  int bookTotalPages = 322;
  int bookReadPages = 119;

  var swatch = Stopwatch();
  final duration = const Duration(seconds: 1);

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
          });
          print(value.toString());
          print(picker.getSelectedValues());
        }
    ).showDialog(context);
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

            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Center(
                child: Text(
                  time,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50.0,
                  ),
                ),
              ),
            ),

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
            )
            
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