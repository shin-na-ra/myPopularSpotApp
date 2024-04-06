import 'package:myapp/model/mylist.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHandler {

  Future<Database> initialzeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'myplacelist.db'),
      
      onCreate: (db, version) async {
        await db.execute(
          'create table mylist(id integer primary key autoincrement, sname text, sphone text, image blob, longitude integer, latitude integer, text text)'
        );
      },
      version: 1
    );
  }

  //select
  Future<List<Mylist>> selectList() async {
    final Database db = await initialzeDB();
    final List<Map<String, Object?>> queryResult = 
      await db.rawQuery('select * from mylist');
    return queryResult.map((e) => Mylist.fromMap(e)).toList();
  }
}