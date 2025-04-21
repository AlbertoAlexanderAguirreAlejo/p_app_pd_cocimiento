import 'package:sqflite/sqflite.dart';
import 'package:app_pd_cocimiento/core/database/db_helper.dart';

abstract class BaseRepository<T> {
  final String tableName;
  final T Function(Map<String, dynamic> map) fromMap;
  final Map<String, dynamic> Function(T object) toMap;

  BaseRepository({
    required this.tableName,
    required this.fromMap,
    required this.toMap,
  });

  Future<Database> get _db async => await DBHelper.database;

  // Inserta un registro.
  Future<int> insert(T object) async {
    final db = await _db;
    return await db.insert(
      tableName,
      toMap(object),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Inserta una lista de registros.
  Future<List<int>> insertAll(List<T> objects) async {
    final db = await _db;
    final batch = db.batch();
    for (var object in objects) {
      batch.insert(
        tableName,
        toMap(object),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    final results = await batch.commit();
    return results.cast<int>();
  }

  // Método auxiliar para construir el where clause a partir de un Map.
  Map<String, dynamic> _buildWhereClause(Map<String, dynamic> conditions) {
    final whereClause =
        conditions.entries.map((e) => '${e.key} = ?').join(' AND ');
    final whereArgs = conditions.values.toList();
    return {'where': whereClause, 'whereArgs': whereArgs};
  }

  // Actualiza un registro utilizando un mapa de condiciones.
  Future<int> updateFieldsWithConditions(
    {
    required Map<String, dynamic> fields,
    required Map<String, dynamic> conditions,
    }
  ) async {
    final db = await _db;
    final clause = _buildWhereClause(conditions);
    return await db.update(
      tableName,
      fields,
      where: clause['where'] as String,
      whereArgs: clause['whereArgs'] as List<dynamic>,
    );
  }

  // Actualiza una lista de registros (batch) usando un mapa de condiciones.
  Future<List<int>> updateAllWithConditions(
    {
      required List<T> objects,
      required Map<String, dynamic> conditions
    }
  ) async {
    final db = await _db;
    final batch = db.batch();
    final clause = _buildWhereClause(conditions);
    for (var object in objects) {
      batch.update(
        tableName,
        toMap(object),
        where: clause['where'] as String,
        whereArgs: clause['whereArgs'] as List<dynamic>,
      );
    }
    final results = await batch.commit();
    return results.cast<int>();
  }

  // Elimina registros utilizando un mapa de condiciones.
  Future<int> deleteByConditions({required Map<String, dynamic> conditions}) async {
    final db = await _db;
    final clause = _buildWhereClause(conditions);
    return await db.delete(
      tableName,
      where: clause['where'] as String,
      whereArgs: clause['whereArgs'] as List<dynamic>,
    );
  }

  // Elimina todos los registros de la tabla.
  Future<int> deleteAll() async {
    final db = await _db;
    return await db.delete(tableName);
  }

  // Selecciona registros según un mapa de condiciones, con opción de ordenamiento.
  Future<List<T>> getByConditions({
    required Map<String, dynamic> conditions,
    String? orderBy,
  }) async {
    final db = await _db;
    final clause = _buildWhereClause(conditions);
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: clause['where'] as String,
      whereArgs: clause['whereArgs'] as List<dynamic>,
      orderBy: orderBy,
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  // Selecciona todos los registros, con opción de ordenamiento.
  Future<List<T>> getAll({String? orderBy}) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: orderBy,
    );
    return maps.map((map) => fromMap(map)).toList();
  }


  // Reemplaza todos los registros de la tabla con una lista de objetos.
  Future<void> replaceAll(List<T> objects) async {
    final db = await _db;
    // Se usa una transacción para garantizar integridad y eficiencia.
    await db.transaction((txn) async {
      // Elimina todos los registros de la tabla.
      await txn.delete(tableName);
      // Inserta cada objeto, garantizando que la columna "flag_estado" tenga valor 1.
      for (var object in objects) {
        // Convierte el objeto a Map.
        Map<String, dynamic> map = toMap(object);
        await txn.insert(
          tableName,
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}
