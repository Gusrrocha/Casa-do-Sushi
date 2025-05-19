import 'package:sqflite/sqflite.dart';
import 'package:casadosushi/models/produto.dart';
import 'package:path/path.dart';

const String boolType = "BOOLEAN NOT NULL";
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textTypeNullable = "TEXT";
const String textType = "TEXT NOT NULL";
const String doubleType = "REAL NOT NULL";

const String filename = "CasadoSushi_db.db";

class DatabaseHelper {
  
  DatabaseHelper._init();

  static final DatabaseHelper instance = DatabaseHelper._init();

  factory DatabaseHelper() => instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB(filename);
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Produto (
      $idField $idType,
      $photoField $textTypeNullable,
      $nameField $textType,
      $descriptionField $textTypeNullable,
      $valueField $doubleType
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Usuario(
      id $idType,
      firebaseUID TEXT NOT NULL UNIQUE,
      nome $textType,
      telefone $textType UNIQUE,
      email $textType UNIQUE,
      senha $textType,
      cpf $textType UNIQUE,
      isAdmin INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Pedido(
      id $idType,
      idUsuario INTEGER NOT NULL,
      data TEXT NOT NULL,
      valor $doubleType,
      FOREIGN KEY(idUsuario) REFERENCES Usuario(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Item (
      id $idType,
      idPedido INTEGER NOT NULL,
      idProduto INTEGER NOT NULL,
      quantidade INTEGER NOT NULL,
      FOREIGN KEY(idPedido) REFERENCES Pedido(id),
      FOREIGN KEY(idProduto) REFERENCES Produto(_id)
      )
    ''');
    
    await db.execute('''INSERT INTO Usuario (firebaseUID, nome, telefone, email, senha, cpf, isAdmin) 
                        VALUES ('10y6NFSpbBVwwnHWH1n0aiGrHQ32', 'admin', 'admin', 'admin@gmail.com', 'admin123', 'admin', 1)''');

  }

  Future<Database> _initializeDB(String filename) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filename);
    return await openDatabase(path, 
                              version: 1, 
                              onCreate: _createDB,
                              onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON')
                              );
  }

  Future<void> close() async {
    final db = await instance.database;
    _database = null;
    return db.close();
  }
}