import 'package:myapp/model/mylist.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {

  Future<Database> initialzeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'myplacelist.db'),
      
      onCreate: (db, version) async {
        await db.execute(
          'create table mylist(id integer primary key autoincrement, sname text, sphone text, image blob, longitude text, latitude text, text text)'
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

  //insert
  Future<void> insertList(Mylist list) async {
    final Database db = await initialzeDB();
    await db.rawInsert(
      'insert into mylist(sname, sphone, image, longitude, latitude, text) values (?,?,?,?,?,?)',
      [list.sname, list.sphone, list.image, list.longitude, list.latitude, list.text]
    );
  }

  //update
  Future<void> updateList(Mylist list) async {
    final Database db = await initialzeDB();
    await db.rawUpdate(
      'update mylist set sname=?, sphone=?, image=?, longitude=?, latitude=?, text=? where id = ?',
      [list.sname, list.sphone, list.image, list.longitude, list.latitude, list.text, list.id]
    );
  }

  //update
  Future<void> deleteList(int id) async {
    final Database db = await initialzeDB();
    await db.rawDelete(
      'delete from mylist where id = ?',
      [id]
    );
  }
}