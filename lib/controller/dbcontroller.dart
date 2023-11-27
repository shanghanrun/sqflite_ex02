import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

String tableName = 'memos';
String dbName = 'memos.db';

class DBController {
  var _db; //함수 안에 들어가서 Database타입을 받을 거다.

  Future<Database> get database async {
    //sqfite
    var path = await getDatabasesPath(); //sqlite_api
    path = join(path, dbName); //path 패키지

    if (_db != null) return _db;
    _db = openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
          'create table memos(id integer primary key, title text, text text, createdTime text, editedTime text)');
    });
    return _db;
  }

  Future<void> insertMemo(Memo memo) async {}
}
