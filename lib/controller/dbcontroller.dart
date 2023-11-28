import 'package:path/path.dart'; // join함수
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart'; // Database 클래스
// import 'package:sqflite/sqlite_api.dart'; // getDatabasePath()메소드
import 'package:sqflite_ex02/model/memo.dart';

String tableName = 'memos';
String dbName = 'memos.db';

class DBController {
  var _db; //함수 안에 들어가서 Database타입을 받을 거다.

  Future<Database> get database async {
    //! getter함수   _db를 database를 호출해서 얻는다.
    //! 이 클래스 안에서는 database를 호출해서 _db를 얻고, 밖에서는 DBController의 인스턴스.database

    // var path = await getDatabasesPath(); //sqlite_api
    var dir = await getApplicationDocumentsDirectory(); //path_provider
    var path = dir.path;
    path = join(path, dbName); //path 패키지

    if (_db != null) return _db;
    _db = openDatabase(path, version: 1, onCreate: (db, version) {
      //!최초 데이터베이스 생성하기  initialize
      return db.execute(
          'create table memos(id integer primary key, title text, text text, createdTime text, editedTime text)');
    });
    return _db;
  }

  Future<void> insertMemo(Memo memo) async {
    final db = await database; //!이미 생성된 데이터베이스를 불러오는 getter 함수명령. 비동기함수
    await db.insert(
      tableName,
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Memo>> memos() async {
    final db = await database;

    final List<Map<String, dynamic>> memoMapList = await db.query('memos');

    return List.generate(memoMapList.length, (i) {
      return Memo(
        id: memoMapList[i]['id'],
        title: memoMapList[i]['title'],
        text: memoMapList[i]['text'],
        createdTime: memoMapList[i]['createdTime'],
        editedTime: memoMapList[i]['editedTime'],
      );
    });
  }

  Future<void> updateMeom(Memo memo) async {
    final db = await database;

    await db.update(
      tableName,
      memo.toMap(),
      where: 'id = ?',
      whereArgs: [memo.id],
    );
  }

  Future<void> deleteMemo(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
