import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de tareas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  List<Map<String, dynamic>> tareas = [];
  String nombreUsuario = 'Usuario';

  Future<void> guardarNombreUsuario(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombreUsuario', nombre);

    setState(() {
      nombreUsuario = nombre;
    });
  }

  Future<void> cargarNombreUsuario() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nombreUsuario = prefs.getString('nombreUsuario') ?? 'Usuario';
    });
  }

  Future<void> cargarTareas() async {
    final datos = await DatabaseHelper.instance.obtenerTareas();

    setState(() {
      tareas = datos;
    });
  }

  Future<void> cambiarEstadoTarea(Map<String, dynamic> tarea) async {
    final nuevoEstado = tarea['completada'] == 1 ? 0 : 1;

    await DatabaseHelper.instance.actualizarTarea(tarea['id'], {
      'titulo': tarea['titulo'],
      'descripcion': tarea['descripcion'],
      'completada': nuevoEstado,
    });

    await cargarTareas();
  }

  Future<void> guardarTarea() async {
    if (tituloController.text.isEmpty) return;

    await DatabaseHelper.instance.insertarTarea({
      'titulo': tituloController.text,
      'descripcion': descripcionController.text,
      'completada': 0,
    });

    tituloController.clear();
    descripcionController.clear();

    await cargarTareas();
  }

  Future<void> editarTarea(
    BuildContext context,
    Map<String, dynamic> tarea,
  ) async {
    final tituloEdicion = TextEditingController(
      text: tarea['titulo']?.toString() ?? '',
    );

    final descripcionEdicion = TextEditingController(
      text: tarea['descripcion']?.toString() ?? '',
    );

    final guardar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloEdicion,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descripcionEdicion,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (guardar == true && tituloEdicion.text.trim().isNotEmpty) {
      await DatabaseHelper.instance.actualizarTarea(tarea['id'], {
        'titulo': tituloEdicion.text,
        'descripcion': descripcionEdicion.text,
        'completada': tarea['completada'],
      });

      await cargarTareas();
    }

    tituloEdicion.dispose();
    descripcionEdicion.dispose();
  }

  @override
  void initState() {
    super.initState();
    cargarTareas();
    cargarNombreUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de tareas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Bienvenido, $nombreUsuario',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Escribe tu nombre',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: guardarNombreUsuario,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título de la tarea',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.task),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descripcionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción de la tarea',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: guardarTarea,
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar tarea'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: tareas.isEmpty
                ? const Center(child: Text('No hay tareas registradas'))
                : ListView.builder(
                    itemCount: tareas.length,
                    itemBuilder: (context, index) {
                      final tarea = tareas[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          onTap: () => editarTarea(context, tarea),
                          title: Text(tarea['titulo']),
                          subtitle: Text(tarea['descripcion'] ?? ''),
                          leading: IconButton(
                            icon: Icon(
                              tarea['completada'] == 1
                                  ? Icons.check_circle
                                  : Icons.pending_actions,
                              color: tarea['completada'] == 1
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            onPressed: () => cambiarEstadoTarea(tarea),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await DatabaseHelper.instance.eliminarTarea(
                                tarea['id'],
                              );
                              await cargarTareas();
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tareas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE tareas ADD COLUMN pendiente_sincronizar INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tareas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        completada INTEGER NOT NULL DEFAULT 0;
        pendiente_sincronizar INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> insertarTarea(Map<String, dynamic> tarea) async {
    final db = await database;
    return await db.insert('tareas', tarea);
  }

  Future<List<Map<String, dynamic>>> obtenerTareas() async {
    final db = await database;
    return await db.query('tareas', orderBy: 'id DESC');
  }

  Future<int> actualizarTarea(int id, Map<String, dynamic> tarea) async {
    final db = await database;
    return await db.update('tareas', tarea, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> eliminarTarea(int id) async {
    final db = await database;
    return await db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }
}
