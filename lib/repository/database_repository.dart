import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:task/model/cardModel.dart';
import 'package:task/repository/interface/idatabase.dart';

class DatabaseRepository extends IDatabase {
  String _dataBaseName = "card";
  String tableName = "cardInformation";
  Database database;

  String columnTeknikUzman = "teknikUzman";
  String columnTahminiSure = "tahminiSure";
  String columnGerceklesenSure = "gerceklesenSure";
  String columnIsinAciklamasi = "isinAciklamasi";
  String columnNotlar = "notlar";
  String columnId = "id";

  @override
  Future open() async {
    database = await openDatabase(
      _dataBaseName,
      version: 1,
      onCreate: (db, version) {
        createTable(db);
      },
    );
  }

  void createTable(Database db) {
    db.execute('''CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTeknikUzman TEXT,
            $columnTahminiSure TEXT,
            $columnGerceklesenSure TEXT,
            $columnIsinAciklamasi TEXT,
            $columnNotlar TEXT)''');
  }

  @override
  Future<List<CardModel>> getCardList() async {
    if (database != null) open();
    List<Map> cardMaps = await database.query(tableName);
    return cardMaps.map((e) => CardModel.fromJson(e)).toList();
  }

  @override
  Future<CardModel> getIdCard(int id) async {
    if (database != null) open();
    final cardMaps = await database.query(
      tableName,
      where: '$columnId = ?',
      columns: [columnId],
      whereArgs: [id],
    );
    if (cardMaps.isNotEmpty)
      return CardModel.fromJson(cardMaps.first);
    else
      return null;
  }

  @override
  Future<bool> deleteCard(int id) async {
    if (database != null) open();
    final cardMaps = await database.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return cardMaps != null;
  }

  @override
  Future<bool> addCard(CardModel model) async {
    if (database != null) open();
    final cardMaps = await database.insert(
      tableName,
      model.toJson(),
    );
    return cardMaps != null;
  }

  @override
  Future<bool> updateCard(int id, CardModel model) async {
    if (database != null) open();
    final cardMaps = await database.update(
      tableName,
      model.toJson(),
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return cardMaps != null;
  }

  @override
  Future close() async {
    await database.close();
  }
}
