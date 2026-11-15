import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/publicacion.dart';
import '../providers/publicaciones_provider.dart';
import '../services/compartir_service.dart';

class DetallePublicacion extends StatelessWidget {
  final Publicacion publicacion;

  const DetallePublicacion({super.key, required this.publicacion});

  @override
  Widget build(BuildContext context) {
    final favorito = context.select<PublicacionesProvider, bool>(
      (p) => p.esFavorito(publicacion.id),
    );
    final tema = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicación #${publicacion.id}'),
        actions: [
          IconButton(
            tooltip: favorito ? 'Quitar de favoritos' : 'Agregar a favoritos',
            icon: Icon(favorito ? Icons.favorite : Icons.favorite_border),
            color: favorito ? Colors.red : null,
            onPressed: () => context
                .read<PublicacionesProvider>()
                .alternarFavorito(publicacion.id),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: const Icon(Icons.person, size: 18),
              label: Text('Usuario ${publicacion.usuarioId}'),
            ),
          ),
          const SizedBox(height: 16),
          Text(publicacion.titulo, style: tema.headlineSmall),
          const Divider(height: 32),
          Text(publicacion.cuerpo, style: tema.bodyLarge),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => CompartirService.compartir(publicacion),
            icon: const Icon(Icons.share),
            label: const Text('Compartir'),
          ),
        ],
      ),
    );
  }
}
