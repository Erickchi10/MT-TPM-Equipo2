import 'package:flutter/material.dart';
import '../models/publicacion.dart';

class DetallePublicacion extends StatelessWidget {
  final Publicacion publicacion;
  const DetallePublicacion({super.key, required this.publicacion});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Publicación #${publicacion.id}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              avatar: const Icon(Icons.person, size: 18),
              label: Text('Usuario ${publicacion.usuarioId}'),
            ),
            const SizedBox(height: 16),
            Text(publicacion.titulo, style: tema.headlineSmall),
            const Divider(height: 32),
            Text(publicacion.cuerpo, style: tema.bodyLarge),
          ],
        ),
      ),
    );
  }
}
