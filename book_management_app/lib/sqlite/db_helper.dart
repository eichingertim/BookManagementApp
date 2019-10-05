import 'dart:async';
import 'dart:io' as io;
import 'package:book_management_app/book_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;

  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String CURRENT_PAGE = 'currentPage';
  static const String NUM_PAGES = 'numPages';
  static const String TIME_READ = 'timeRead';

  static const String TABLE = 'Books';
  static const String DB_NAME = 'books.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  
  initDb() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $TITLE TEXT, $CURRENT_PAGE INTEGER, $NUM_PAGES INTEGER, $TIME_READ INTEGER)");
  }

  Future<BookItem> save (BookItem bookItem) async {
    var dbClient = await db;
    bookItem.id = await dbClient.insert(TABLE, bookItem.toMap());
    return bookItem;
  }

  Future<List<BookItem>> getBooks() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, TITLE, CURRENT_PAGE, NUM_PAGES, TIME_READ]);
    List<BookItem> bookItems = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        bookItems.add(BookItem.fromMap(maps[i]));
      }
    }
    return bookItems;
  }

  Future<int> delete (int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update (BookItem bookItem) async{
    var dbClient = await db;
    return await dbClient.update(TABLE, bookItem.toMap(), where: '$ID = ?', whereArgs: [bookItem.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}
