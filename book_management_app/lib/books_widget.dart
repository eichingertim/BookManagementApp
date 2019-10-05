import 'package:book_management_app/sqlite/db_helper.dart';
import 'package:flutter/material.dart';
import 'book_item.dart';
import 'dart:async';

class BooksPage extends StatefulWidget {  

  State<StatefulWidget> createState() => _BooksPageState();

}

class _BooksPageState extends State<BooksPage> {

  //DATABASE
  Future<List<BookItem>> books;
  TextEditingController controller = TextEditingController();
  TextEditingController controllerCurPage = TextEditingController();
  TextEditingController controllerNumPage = TextEditingController();
  TextEditingController controllerTimeRead = TextEditingController();

  int curUserId;
  String title;
  int currentPage;
  int numPages;
  int timeRead;

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

  clearTextFields() {
    controller.text = '';
    controllerCurPage.text = '';
    controllerNumPage.text = '';
    controllerTimeRead.text = '';
  }

  validate() {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        BookItem b = BookItem(curUserId, title, currentPage, numPages, timeRead);
        dbHelper.update(b);
        setState(() {
         isUpdating = false; 
        });
      } else {
        BookItem b = BookItem(null, title, currentPage, numPages, timeRead);
        dbHelper.save(b);
      }
      clearTextFields();
      refreshList();
    }
  }

  form() {
    return Form(
      key: formKey,
      child: Padding (
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (val) => val.length == 0 ? 'Enter Title' : null,
              onSaved: (val) => title = val,
            ),

            TextFormField(
              controller: controllerCurPage,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Current Page'),
              validator: (val) => val.length == 0 ? 'Enter Current Page' : null,
              onSaved: (val) => currentPage = int.parse(val),
            ),

            TextFormField(
              controller: controllerNumPage,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Number of Pages'),
              validator: (val) => val.length == 0 ? 'Enter Number of Pages' : null,
              onSaved: (val) => numPages = int.parse(val),
            ),

            TextFormField(
              controller: controllerTimeRead,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(labelText: 'Time Read'),
              validator: (val) => val.length == 0 ? 'Enter Time Read' : null,
              onSaved: (val) => timeRead = int.parse(val),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),

                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                     isUpdating = false; 
                    });
                    clearTextFields();
                  },
                  child: Text('CANCEL'),
                  
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<BookItem> bookItems) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text('NAME')),
          DataColumn(label: Text('EDIT')),
          DataColumn(label: Text('DELETE')),
        ],
        rows: bookItems.map((bookItem) => DataRow(
          cells: [
            DataCell(
              Text(bookItem.title),
            ),
            DataCell(
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    isUpdating = true;
                    curUserId = bookItem.id;
                  });
                  controller.text = bookItem.title;
                  controllerCurPage.text = bookItem.currentPage.toString();
                  controllerNumPage.text = bookItem.numPages.toString();
                  controllerTimeRead.text = bookItem.timeRead.toString();
                },
              ),
            ),
            DataCell(
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  dbHelper.delete(bookItem.id);
                  refreshList();
                },
              ),
            )
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
  
  // ListView dataTable(List<BookItem> bookItems) {
  //   return ListView.builder(
  //     padding: EdgeInsets.all(16),
  //     itemCount: bookItems.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       return Card(
  //         child: ListTile(
  //           leading: Icon(Icons.book, size: 35.0,),
  //           title: Text('${bookItems[index].title}'),
  //           subtitle: Text('${bookItems[index].currentPage} pages read from ${bookItems[index].numPages}'),
  //           trailing: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               GestureDetector(
  //                 child: Icon(Icons.edit),
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => CreateNewBook()),
  //                   );
  //                 },
  //               ),
  //               GestureDetector(
  //                 child: Icon(Icons.clear),
  //                 onTap: () {
  //                   _showDialog(bookItems, index);
  //                 }
  //               ),
  //             ],
  //           )
  //         ),
  //       );
  //     }
  //   );
  // }

}