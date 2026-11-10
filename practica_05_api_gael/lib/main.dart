import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// ==========================================
// 1. APLICACION PRINCIPAL
// ==========================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Practica 05 API REST',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UsuariosPage(),
    );
  }
}

// ==========================================
// 2. MODELO USUARIO
// ==========================================

class Usuario {
  final int id;
  final String nombre;
  final String correo;

  Usuario({required this.id, required this.nombre, required this.correo});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(id: json['id'], nombre: json['name'], correo: json['email']);
  }
}

// ==========================================
// 3. PANTALLA DE USUARIOS
// ==========================================

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  late Future<List<Usuario>> futuro;

  @override
  void initState() {
    super.initState();
    futuro = cargar();
  }

  Future<List<Usuario>> cargar() async {
    final respuesta = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (respuesta.statusCode != 200) {
      throw Exception('Error HTTP: ${respuesta.statusCode}');
    }

    final List<dynamic> datos = jsonDecode(respuesta.body);

    return datos.map((elemento) => Usuario.fromJson(elemento)).toList();
  }

  Future<void> actualizar() async {
    final nuevaCarga = cargar();

    setState(() {
      futuro = nuevaCarga;
    });

    try {
      await nuevaCarga;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios REST'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Ver publicaciones',
            icon: const Icon(Icons.article),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostsPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Usuario>>(
        future: futuro,
        builder: (context, estado) {
          if (estado.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (estado.hasError) {
            return Center(child: Text('Error: ${estado.error}'));
          }

          final usuarios = estado.data ?? [];

          if (usuarios.isEmpty) {
            return const Center(child: Text('No hay usuarios disponibles'));
          }

          return RefreshIndicator(
            onRefresh: actualizar,
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: CircleAvatar(child: Text('${usuarios[i].id}')),
                  title: Text(usuarios[i].nombre),
                  subtitle: Text(usuarios[i].correo),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 4. MODELO PUBLICACION
// ==========================================

class Post {
  final int id;
  final String titulo;
  final String cuerpo;

  Post({required this.id, required this.titulo, required this.cuerpo});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json['id'], titulo: json['title'], cuerpo: json['body']);
  }
}

// ==========================================
// 5. PANTALLA DE PUBLICACIONES
// ==========================================

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Future<List<Post>> futuro;

  @override
  void initState() {
    super.initState();
    futuro = cargarPosts();
  }

  Future<List<Post>> cargarPosts() async {
    final respuesta = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (respuesta.statusCode != 200) {
      throw Exception('Error HTTP: ${respuesta.statusCode}');
    }

    final List<dynamic> datos = jsonDecode(respuesta.body);

    return datos.map((elemento) => Post.fromJson(elemento)).take(20).toList();
  }

  Future<void> actualizarPosts() async {
    final nuevaCarga = cargarPosts();

    setState(() {
      futuro = nuevaCarga;
    });

    try {
      await nuevaCarga;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones REST'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Post>>(
        future: futuro,
        builder: (context, estado) {
          if (estado.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (estado.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text('Error: ${estado.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: actualizarPosts,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final posts = estado.data ?? [];

          if (posts.isEmpty) {
            return const Center(
              child: Text('No hay publicaciones disponibles'),
            );
          }

          return RefreshIndicator(
            onRefresh: actualizarPosts,
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, i) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${posts[i].id}')),
                    title: Text(posts[i].titulo),
                    subtitle: Text(
                      posts[i].cuerpo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PostDetailPage(post: posts[i]);
                          },
                        ),
                      );
                    },
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

// ==========================================
// 6. PANTALLA DE DETALLE
// ==========================================

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de publicación'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Publicación #${post.id}',
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),

            const SizedBox(height: 20),

            Text(
              post.titulo,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 10),

            const Text(
              'Contenido:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              post.cuerpo,
              style: const TextStyle(fontSize: 17, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
