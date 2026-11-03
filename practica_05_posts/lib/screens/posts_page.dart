import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';
import 'detalle_post_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key, this.cargador});

  /// Permite cambiar de dónde vienen los datos (se usa en las pruebas).
  final Future<List<Post>> Function()? cargador;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Future<List<Post>> futuro;

  @override
  void initState() {
    super.initState();
    futuro = _cargar();
  }

  Future<List<Post>> _cargar() =>
      (widget.cargador ?? PostService().obtenerPosts)();

  Future<void> _recargar() async {
    final nuevo = _cargar();
    setState(() => futuro = nuevo);
    try {
      await nuevo;
    } catch (_) {
      // El error se muestra en pantalla desde el FutureBuilder.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicaciones')),
      body: FutureBuilder<List<Post>>(
        future: futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    const Text('No se pudieron cargar las publicaciones'),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _recargar,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }
          final posts = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: _recargar,
            child: posts.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text('No hay publicaciones para mostrar')),
                    ],
                  )
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, i) {
                      final post = posts[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${post.id}')),
                          title: Text(
                            post.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            post.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetallePostPage(post: post),
                            ),
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
