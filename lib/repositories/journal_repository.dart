import 'package:crud_apps/models/journals.dart';
import 'package:sqflite/sqflite.dart';

class JournalRepository {
  static Future<Database> _getDatabase() async {
    final database = await openDatabase(
      'journal_manager.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE journals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            created_at TEXT,
            updated_at TEXT
          )
          ''',
        );
        final now = DateTime.now().toIso8601String();
        await db.insert('journals', {
          'title': 'Hari pertama belajar Flutter',
          'description': 'Hari ini mencoba membuat aplikasi sederhana.',
          'created_at': now,
          'updated_at': now,
        });
        await db.insert('journals', {
          'title': 'Hari kedua belajar Flutter',
          'description': 'Hari ini mencoba membuat aplikasi crud coy.',
          'created_at': now,
          'updated_at': now,
        });
      },
    );

    return database;
  }

  static Future<List<Journals>> getListJournals() async{
    final db = await _getDatabase();
    final result = await db.query('journals');
    return result
        .map((json) => Journals.fromMap(json))
        .toList();
  }

  static Future<int> addJournals(Journals journals) async{
    final db = await _getDatabase();
    return await db.insert('journals', journals.toMap());
  }

  static Future<int> updateJournals(Journals journals) async{
    final db = await _getDatabase();
    return await db.update(
        'journals',
        journals.toMap(),
        where: 'id = ?',
        whereArgs: [journals.id]
    );
  }

  static Future<int> deleteJournals(int id) async{
    final db = await _getDatabase();
    return await db.delete(
        'journals',
        where: 'id = ?',
        whereArgs: [id]
    );
  }
}
