import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'khata_history_data.dart';
import 'package:intl/intl.dart';

class KhataData {
  int id;
  String name;
  String description;
  int money;
  String date;
  Database database;

  KhataData({this.id, this.name, this.description, this.money, this.date});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'money': money,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'khata{id: $id, name: $name, description: $description, money: $money, date: $date}';
  }

  Future<bool> createDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'khata_database'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          'CREATE TABLE IF NOT EXISTS khata(ID INTEGER PRIMARY KEY NOT NULL, Name TEXT, Description TEXT, Money INT, Date TEXT)',
        );
      },
      version: 1,
    );
    return true;
  }

  Future<void> insertData(List data) async {
    final db =
        await openDatabase(join(await getDatabasesPath(), 'khata_database'));

    await db.transaction((txn) async {
      int id2 = await txn.rawInsert(
          'INSERT INTO khata(Name, Description, Money, Date) VALUES(?, ?, ?, ?)',
          data);
      print('inserted2: $id2');
    });
  }

  Future<void> update(String name, String mode, String moneyToUpdate,
      String description) async {
    int resultMoney;
    final db =
        await openDatabase(join(await getDatabasesPath(), 'khata_database'));

    //Get Money from Name
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT Money FROM khata WHERE Name=?', ['${name.toString().trim()}']);

    if (isNumeric(moneyToUpdate.trim())) {
      //Get Previous money
      int money = result[0]['Money'];

      if (mode.trim() == 'cashIn') {
        resultMoney = money + int.parse(moneyToUpdate.trim());

        //Make entry in History Tab for add operation
        List data = [name, money, '+', moneyToUpdate, resultMoney, getDate()];
        await KhataUpdateData().insertData(data);
      } else {
        resultMoney = money - int.parse(moneyToUpdate.trim());

        //Make entry in History Tab for minus operation
        List data = [name, money, '-', moneyToUpdate, resultMoney, getDate()];
        await KhataUpdateData().insertData(data);
      }

      //Update
      int count = await db.rawUpdate(
          'UPDATE khata SET Money = ?, Description = ? WHERE Name = ?',
          [resultMoney, description, name]);

      print(count);
    } else {
      print('moneyToUpdate is not Numeric');
      return;
    }
  }

  Future<List<KhataData>> getData() async {
    // Get a reference to the database.
    final db =
        await openDatabase(join(await getDatabasesPath(), 'khata_database'));

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('khata');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return KhataData(
          id: maps[i]['ID'],
          name: maps[i]
              ['Name'], //Here the key name must be equal to Column Name
          description: maps[i]['Description'],
          money: maps[i]['Money'],
          date: maps[i]['Date']);
    });
  }

  Future<int> checkIfNameExists(String name) async {
    List<Map<String, dynamic>> result;
    final db =
        await openDatabase(join(await getDatabasesPath(), 'khata_database'));

    name = name.trim();
    try {
      result = await db.rawQuery('Select * from khata WHERE Name=?', ['$name']);

      if (result.length == 0) {
        result =
            await db.rawQuery('Select * from khata WHERE Name=?', ['$name']);
      }
      return result.length;
    } catch (e) {
      print('Exception caught');
      return 0;
    }
  }

  Future<void> delete(String name) async {
    final db =
        await openDatabase(join(await getDatabasesPath(), 'khata_database'));
    print(db.isOpen);

    //delete
    int count = await db.rawDelete('DELETE FROM khata WHERE Name = ?', [name]);

    print(count);
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('d MMM');
    final String formatted = formatter.format(now);
    return formatted;
  }

  Future<List<int>> getTotals() async {
    int totalOut = 0;
    int totalIn = 0;
    List<int> data = [];

    final db =
        await openDatabase(join(await getDatabasesPath(), 'khata_database'));

    try {
      List<Map<String, dynamic>> result =
          await db.rawQuery('Select Money from khata');

      for (int i = 0; i < result.length; i++) {
        int money = (result[i]['Money']);
        if (money < 0) {
          money = money * -1;
          totalOut = totalOut + money;
        } else {
          totalIn = totalIn + money;
        }
      }

      data.add(totalOut);
      data.add(totalIn);

      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
