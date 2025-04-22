import 'package:sqflite/sqflite.dart';
import 'package:mobiletet/models/sushi.dart';
import 'package:path/path.dart';
const String filename = "sushi_db.db";

class SushiDatabase{
  SushiDatabase._init();

  static final SushiDatabase instance = SushiDatabase._init();

  static Database? _database;

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initializeDB(filename);
    return _database!;
  }

  Future _createDB(Database db, int version) async{
    await db.execute('''
      CREATE TABLE Sushi (
      $idField $idType,
      $nameField $textType,
      $descriptionField $textType,
      $valueField $doubleType,
      )
    ''');
  }

  Future<Database> _initializeDB(String filename) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filename);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Sushi> createSushi(Sushi sushi) async{
    final db = await instance.database;
    final id = await db.insert("Sushi", sushi.toJson());
    return sushi.copyWith(id: id);
  }

  Future<List<Sushi?>> listSushi() async {
    final db = await instance.database;
    final list = await db.query('Sushi');
    return list.map((json) => Sushi.fromJson(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    return db.close();
  }
}