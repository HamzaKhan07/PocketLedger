import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class KhataUpdateData {
  int id;
  final String name;
  final int prevMoney;
  final String operation;
  final int addOrSubMoney;
  final int resultMoney;
  final String date;
  Database database;

  KhataUpdateData(
      {this.id,
      this.name,
      this.prevMoney,
      this.operation,
      this.addOrSubMoney,
      this.resultMoney,
      this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'prevMoney': prevMoney,
      'operation': operation,
      'resultMoney': resultMoney,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'khataHistory{id: $id, name: $name, prevMoney: $prevMoney, operation: $operation,addOrSubMoney: $addOrSubMoney, resultMoney: $resultMoney, date: $date}';
  }

  Future<bool> createDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'history_database1'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
            'CREATE TABLE IF NOT EXISTS history1(ID INTEGER PRIMARY KEY NOT NULL, Name TEXT, PrevMoney INT, Operation TEXT,AddOrSubMoney INT, ResultMoney INT, Date TEXT)');
      },
      version: 1,
    );
    return true;
  }

  //insert data
  Future<void> insertData(List data) async {
    final db =
        await openDatabase(join(await getDatabasesPath(), 'history_database1'));

    await db.transaction((txn) async {
      int id2 = await txn.rawInsert(
          'INSERT INTO history1(Name, PrevMoney, Operation, AddOrSubMoney, ResultMoney, Date) VALUES(?, ?, ?, ?, ?, ?)',
          data);
      print('inserted2: $id2');
    });
  }

  //display data
  Future<List<KhataUpdateData>> getData() async {
    // Get a reference to the database.
    final db =
        await openDatabase(join(await getDatabasesPath(), 'history_database1'));

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('history1');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return KhataUpdateData(
          id: maps[i]['ID'],
          name: maps[i]
              ['Name'], //Here the key name must be equal to Column Name
          prevMoney: maps[i]['PrevMoney'],
          operation: maps[i]['Operation'],
          addOrSubMoney: maps[i]['AddOrSubMoney'],
          resultMoney: maps[i]['ResultMoney'],
          date: maps[i]['Date']);
    });
  }

  Future<void> delete(String name) async {
    final db =
        await openDatabase(join(await getDatabasesPath(), 'history_database1'));
    print(db.isOpen);

    //delete
    int count =
        await db.rawDelete('DELETE FROM history1 WHERE Name = ?', [name]);

    print(count);
  }

  Future<int> checkIfNameExists(String name) async {
    List<Map<String, dynamic>> result;
    final db =
        await openDatabase(join(await getDatabasesPath(), 'history_database1'));

    name = name.trim();
    try {
      result =
          await db.rawQuery('Select * from history1 WHERE Name=?', ['$name']);
      if (result.length == 0) {
        result = await db.rawQuery(
            'Select * from history1 WHERE Name=?', ['${name.toLowerCase()}']);
      }
      return result.length;
    } catch (e) {
      print('Exception caught');
      return 0;
    }
  }
}
