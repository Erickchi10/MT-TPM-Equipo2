import 'package:flutter/material.dart';

import '../models/publicacion.dart';

class PublicacionTile extends StatelessWidget {
  final Publicacion publicacion;
  final bool favorito;
  final VoidCallback alTocar;
  final VoidCallback alMarcarFavorito;

  const PublicacionTile({
    super.key,
    required this.publicacion,
    required this.favorito,
    required this.alTocar,
    required this.alMarcarFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text('${publicacion.id}')),
        title: Text(
          publicacion.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          publicacion.cuerpo,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          tooltip: favorito ? 'Quitar de favoritos' : 'Agregar a favoritos',
          icon: Icon(
            favorito ? Icons.favorite : Icons.favorite_border,
            color: favorito ? Colors.red : null,
          ),
          onPressed: alMarcarFavorito,
        ),
        onTap: alTocar,
      ),
    );
  }
}
