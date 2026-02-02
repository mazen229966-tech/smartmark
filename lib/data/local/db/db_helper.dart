import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/marketing_plan.dart';
import 'db_schema.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DbSchema.dbName);

    return openDatabase(
      path,
      version: DbSchema.dbVersion,
      onCreate: (db, version) async {
        await db.execute(DbSchema.createPlansTable);
      },
    );
  }

  Future<int> insertPlan(MarketingPlan plan) async {
    final db = await database;
    return db.insert(
      DbSchema.tablePlans,
      plan.toMap()..remove(DbSchema.colId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MarketingPlan>> getAllPlans() async {
    final db = await database;
    final rows = await db.query(
      DbSchema.tablePlans,
      orderBy: '${DbSchema.colCreatedAt} DESC',
    );
    return rows.map(MarketingPlan.fromMap).toList();
  }

  Future<MarketingPlan?> getPlanById(int id) async {
    final db = await database;
    final rows = await db.query(
      DbSchema.tablePlans,
      where: '${DbSchema.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return MarketingPlan.fromMap(rows.first);
  }

  Future<int> deletePlan(int id) async {
    final db = await database;
    return db.delete(
      DbSchema.tablePlans,
      where: '${DbSchema.colId} = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearPlans() async {
    final db = await database;
    return db.delete(DbSchema.tablePlans);
  }
}
