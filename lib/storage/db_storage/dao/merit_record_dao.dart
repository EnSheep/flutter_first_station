import 'package:sqflite/sqflite.dart';

class MeritRecordDao {
  final Database database;

  MeritRecordDao(this.database);

  static String tableName = 'merit_record';

  static String tableSql = """
CREATE TABLE $tableName (
id VARCHAR(64) PRIMARY KEY,
value INTEGER, 
image TEXT,
audio TEXT,
timestamp INTEGER
)""";

  static Future<void> createTable(Database db) async{
    return db.execute(tableSql);
  }
}