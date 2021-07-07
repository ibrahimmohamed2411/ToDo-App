import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

class DBHelper {
  static Future<Database> createDatabase() async {
    return await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)',
        );
        print('table created');
      },
      onOpen: (database) async {
        // var value = await getDataFromDatabase(database);
        // setState(() {
        //   tasks = value;
        //   print(tasks);
        // });
      },
    );
  }

  static Future<int> insertToDatabase(
      String table, Map<String, dynamic> row) async {
    var db = await createDatabase();
    return db.insert(table, row);
  }

  static Future<List<Task>> getDataFromDatabase() async {
    var db = await createDatabase();
    List<Map<String, dynamic>> list = await db.query('tasks');
    return list
        .map<Task>(
          (task) => Task(
            id: task['id'],
            date: task['date'],
            title: task['title'],
            status: task['status'],
            time: task['time'],
          ),
        )
        .toList();
  }

  static Future<int> updateData({String? status, int? id}) async {
    var db = await createDatabase();
    return db.update(
      'tasks',
      {
        'status': status,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteData(int id) async {
    var db = await createDatabase();
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
