import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'posts_page.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: UsuariosPage()),
);

class Usuario {
  final int id;
  final String nombre;
  final String correo;

  Usuario({required this.id, required this.nombre, required this.correo});

  factory Usuario.fromJson(Map<String, dynamic> j) =>
      Usuario(id: j['id'], nombre: j['name'], correo: j['email']);
}

class ApiService {
  static const _url = 'https://jsonplaceholder.typicode.com/users';

  Future<List<Usuario>> getUsuarios() async {
    final resp = await http.get(Uri.parse(_url));

    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((e) => Usuario.fromJson(e)).toList();
    } else {
      throw Exception('Error HTTP: ${resp.statusCode}');
    }
  }
}

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  late Future<List<Usuario>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService().getUsuarios();
  }

  void _recargar() {
    setState(() {
      _future = ApiService().getUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo gris claro
      appBar: AppBar(
        title: const Text(
          'Usuarios REST',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.article_outlined),
            tooltip: 'Ver Publicaciones',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PostsPage()),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _recargar),
        ],
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.indigo),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      color: Colors.redAccent,
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No se pudieron cargar los datos.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _recargar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final usuarios = snapshot.data ?? [];
          if (usuarios.isEmpty) {
            return const Center(child: Text('No hay usuarios.'));
          }

          return RefreshIndicator(
            onRefresh: () async => _recargar(),
            color: Colors.indigo,
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0), // Margen exterior
              itemCount: usuarios.length,
              itemBuilder: (context, i) {
                final u = usuarios[i];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      foregroundColor: Colors.indigo,
                      child: Text(
                        '${u.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      u.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      u.correo,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
