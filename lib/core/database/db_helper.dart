import 'package:app_pd_cocimiento/core/constants/db_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    // await resetDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade, // Para gestionar migraciones.
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Maestros
    await db.execute('''
      CREATE TABLE mantenimiento (
        tabla TEXT PRIMARY KEY,
        titulo TEXT,
        ultima_actualizacion TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE fab_tipo_masa (
        id_fab_tipo_masa INTEGER PRIMARY KEY,
        descripcion TEXT,
        flag_estado INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE fab_actividad (
        id_fab_actividad INTEGER PRIMARY KEY,
        descripcion TEXT,
        flag_destino_actividad INTEGER,
        flag_cristalizador INTEGER,
        flag_req_actividad INTEGER,
        flag_estado INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE fab_recipiente (
        id_fab_recipiente INTEGER PRIMARY KEY,
        descripcion TEXT,
        flag_tipo INTEGER,
        flag_estado INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE fab_masa_act_rec (
        id_fab_masa_act_rec INTEGER PRIMARY KEY,
        id_fab_tipo_masa INTEGER,
        id_fab_actividad INTEGER,
        id_fab_recipiente INTEGER,
        flag_estado INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE fab_material (
        id_fab_material INTEGER PRIMARY KEY,
        descripcion TEXT,
        desc_corta TEXT,
        flag_estado INTEGER
      )
    ''');
    // Registros
    await db.execute('''
      CREATE TABLE fab_con_pd_cab (
        id_fab_con_pd_cab INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha_notificacion TEXT,
        turno INTEGER,
        maestro_azucarero TEXT,
        flag_estado INTEGER,
        usr_creacion TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE fab_con_pd_det (
        id_fab_con_pd_det INTEGER PRIMARY KEY AUTOINCREMENT,
        id_fab_con_pd_cab INTEGER,
        fecha_notificacion TEXT,
        id_fab_tipo_masa INTEGER,
        id_fab_actividad INTENGER,
        id_fab_recipiente INTENGER,
        cristalizador INTEGER,
        templa INTEGER,
        flag_estado INTEGER,
        usr_creacion TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE fab_con_pd_agua (
        id_fab_con_pd_agua INTEGER PRIMARY KEY AUTOINCREMENT,
        id_fab_con_pd_cab INTEGER,
        fecha_notificacion TEXT,
        id_fab_recipiente INTENGER,
        p_sig REAL,
        flag_tipo INTEGER,
        flag_estado INTEGER,
        usr_creacion TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE fab_con_pd_nivel (
        id_fab_con_pd_nivel INTEGER PRIMARY KEY AUTOINCREMENT,
        id_fab_con_pd_cab INTEGER,
        id_fab_recipiente INTENGER,
        id_fab_material INTENGER,
        nivel REAL,
        flag_estado INTEGER,
        usr_creacion TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE fab_con_pd_obs (
        id_fab_con_pd_obs INTEGER PRIMARY KEY AUTOINCREMENT,
        id_fab_con_pd_cab INTEGER,
        descripcion TEXT,
        flag_tipo INTEGER,
        flag_estado INTEGER,
        usr_creacion TEXT
      )
    ''');

    // Inserción de datos predeterminados en la tabla de mantenimiento utilizando las constantes.
    await db.insert('mantenimiento', {
      'tabla': DbConstants.dbNameTipoMasa,
      'titulo': DbConstants.dbTitleTipoMasa,
      'ultima_actualizacion': ''
    });
    await db.insert('mantenimiento', {
      'tabla': DbConstants.dbNameActividad,
      'titulo': DbConstants.dbTitleActividad,
      'ultima_actualizacion': ''
    });
    await db.insert('mantenimiento', {
      'tabla': DbConstants.dbNameRecipiente,
      'titulo': DbConstants.dbTitleRecipiente,
      'ultima_actualizacion': ''
    });
    await db.insert('mantenimiento', {
      'tabla': DbConstants.dbNameMasaActRec,
      'titulo': DbConstants.dbTitleMasaActRec,
      'ultima_actualizacion': ''
    });
    await db.insert('mantenimiento', {
      'tabla': DbConstants.dbNameMaterial,
      'titulo': DbConstants.dbTitleMaterial,
      'ultima_actualizacion': ''
    });
  }

  static Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'db.db');
    await deleteDatabase(path);
  }
}
