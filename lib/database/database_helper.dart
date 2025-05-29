import 'package:casadosushi/models/item.dart';
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
      paymentMethod $textType,
      parcelas INTEGER,
      status TEXT NOT NULL,
      cep $textType,
      rua $textType,
      numero $textType,
      complemento $textTypeNullable,
      bairro $textType,
      cidade $textType,
      estado $textType,
      FOREIGN KEY(idUsuario) REFERENCES Usuario(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Item (
      id $idType,
      idPedido INTEGER NOT NULL,
      idProduto INTEGER NOT NULL,
      quantidade INTEGER NOT NULL,
      FOREIGN KEY(idPedido) REFERENCES Pedido(id) ON DELETE CASCADE,
      FOREIGN KEY(idProduto) REFERENCES Produto(_id)
      )
    ''');
    
    await db.execute('''INSERT INTO Usuario (firebaseUID, nome, telefone, email, senha, cpf, isAdmin) 
                        VALUES ('10y6NFSpbBVwwnHWH1n0aiGrHQ32', 'admin', 'admin', 'admin@gmail.com', 'admin123', 'admin', 1)''');
    await db.execute('''INSERT INTO Usuario (firebaseUID, nome, telefone, email, senha, cpf, isAdmin) 
                        VALUES ('5OZIFLQplgOlBSMm8bCJjxmldFy2', 'teste', '(71) 91234-5678', 'teste@gmail.com', 'teste123', '123.456.789-01', 0)''');
    
    
    
    await insertDummyData(db);
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

  Future<void> insertDummyData(db) async {
    List<Produto> dummyProdutos = [
      Produto(
        name: "Hot Roll",
        description: "Enrolado empanado e frito recheado com salmão e cream cheese.",
        value: 35.99,
        photo: "assets/images/hotrolls.jpg",
      ),
      Produto(
        name: "Sushi",
        description: "Sushi tradicional com peixe cru e arroz temperado.",
        value: 30.99,
        photo: 'assets/images/sushi-with-salmon.jpg',
      ),
      Produto(
        name: "Temaki",
        description: "Enrolado de alga arroz, salmão e cebolinha.",
        value: 27.99,
        photo: 'assets/images/temaki_salmao.png',
      ),
      Produto(
        name: "Sashimi",
        description: "Fatias finas de salmão.",
        value: 36.99,
        photo: 'assets/images/sashimi.jpg',
      ),
      Produto(
        name: "Uramaki",
        description: "Enrolado de arroz com peixe e cream cheese.",
        value: 41.99,
        photo: 'assets/images/uramaki.jpeg',
      ),
      Produto(
        name: "Yakisoba",
        description: "Macarrão frito com legumes e carne.",
        value: 25.99,
        photo: 'assets/images/yakisoba.jpg',
      )
    ];
    for(var produto in dummyProdutos) {
      await db.insert(
        'Produto',
        produto.toJson(),
      );
    }
    
    await db.execute('''INSERT INTO Pedido (idUsuario, data, valor, paymentMethod, parcelas, status, cep, rua, numero, complemento, bairro, cidade, estado)
                        VALUES (2, '28/5/2025 12:25', 36.99,'Dinheiro', null, 'Entregue', '12345-678', 'Rua dos Rubis', '21', '', 'Rocha Miranda', 'Rio de Janeiro', 'Rio de Janeiro')''');
    await db.execute('''INSERT INTO Pedido (idUsuario, data, valor, paymentMethod, parcelas, status, cep, rua, numero, complemento, bairro, cidade, estado)
                        VALUES (2, '29/5/2025 13:56', 83.98,'Cartão de crédito', 4, 'Entregue', '12345-678', 'Rua dos Rubis', '21', '', 'Rocha Miranda', 'Rio de Janeiro', 'Rio de Janeiro')''');
    await db.execute('''INSERT INTO Pedido (idUsuario, data, valor, paymentMethod, parcelas, status, cep, rua, numero, complemento, bairro, cidade, estado)
                        VALUES (2, '30/5/2025 11:20', 53.98,'Dinheiro', null, 'Entregue', '12345-678', 'Rua dos Rubis', '21', '', 'Rocha Miranda', 'Rio de Janeiro', 'Rio de Janeiro')''');
    await db.execute('''INSERT INTO Pedido (idUsuario, data, valor, paymentMethod, parcelas, status, cep, rua, numero, complemento, bairro, cidade, estado)
                        VALUES (2, '31/5/2025 12:10', 179.95,'Dinheiro', null, 'Entregue', '12345-678', 'Rua dos Rubis', '21', '', 'Rocha Miranda', 'Rio de Janeiro', 'Rio de Janeiro')''');
    await db.execute('''INSERT INTO Pedido (idUsuario, data, valor, paymentMethod, parcelas, status, cep, rua, numero, complemento, bairro, cidade, estado)
                        VALUES (2, '01/6/2025 14:20', 94.97,'Cartão de débito', null, 'Cancelado', '12345-678', 'Rua dos Rubis', '21', '', 'Rocha Miranda', 'Rio de Janeiro', 'Rio de Janeiro')''');
    await db.execute('''INSERT INTO Pedido (idUsuario, data, valor, paymentMethod, parcelas, status, cep, rua, numero, complemento, bairro, cidade, estado)
                        VALUES (2, '02/6/2025 17:39', 41.99,'Dinheiro', null, 'Entregue', '12345-678', 'Rua dos Rubis', '21', '', 'Rocha Miranda', 'Rio de Janeiro', 'Rio de Janeiro')''');
    await db.execute('''INSERT INTO Pedido (idUsuario, data, valor, paymentMethod, parcelas, status, cep, rua, numero, complemento, bairro, cidade, estado)
                        VALUES (2, '03/6/2025 13:35', 25.99,'Cartão de crédito', 2, 'A caminho', '12345-678', 'Rua dos Rubis', '21', '', 'Rocha Miranda', 'Rio de Janeiro', 'Rio de Janeiro')''');
    await db.execute('''INSERT INTO Pedido (idUsuario, data, valor, paymentMethod, parcelas, status, cep, rua, numero, complemento, bairro, cidade, estado)
                        VALUES (2, '03/6/2025 18:23', 35.99,'Dinheiro', null, 'Em Preparo', '12345-678', 'Rua dos Rubis', '21', '', 'Rocha Miranda', 'Rio de Janeiro', 'Rio de Janeiro')''');
    
    List<Item> dummyItems = [
      Item(
        idPedido: 1,
        idProduto: 4,
        quantidade: 1,
        valor: 36.99
      ),
      Item(
        idPedido: 2,
        idProduto: 5,
        quantidade: 2,
        valor: 41.99
      ),
      Item(
        idPedido: 3,
        idProduto: 6,
        quantidade: 1,
        valor: 25.99
      ),
      Item(
        idPedido: 3,
        idProduto: 3,
        quantidade: 1,
        valor: 27.99 
      ),
      Item(
        idPedido: 4,
        idProduto: 1,
        quantidade: 5,
        valor: 35.99
      ),
      Item(
        idPedido: 5,
        idProduto: 1,
        quantidade: 1,
        valor: 35.99
      ),
      Item(
        idPedido: 5,
        idProduto: 2,
        quantidade: 1,
        valor: 30.99
      ),
      Item(
        idPedido: 5,
        idProduto: 3,
        quantidade: 1,
        valor: 27.99
      ),
      Item(
        idPedido: 6,
        idProduto: 5,
        quantidade: 1,
        valor: 41.99
      ),
      Item(
        idPedido: 7,
        idProduto: 6,
        quantidade: 1,
        valor: 25.99
      ),
      Item(
        idPedido: 8,
        idProduto: 1,
        quantidade: 1,
        valor: 35.99
      ),
    ];
    for(var item in dummyItems) {
      await db.insert(
        'Item',
        item.toJson(),
      );
    }
    
  }
}