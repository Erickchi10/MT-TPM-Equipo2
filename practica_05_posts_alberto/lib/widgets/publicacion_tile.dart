import 'package:flutter/material.dart';
import '../models/publicacion.dart';

class PublicacionTile extends StatelessWidget {
  final Publicacion publicacion;
  final VoidCallback alTocar;

  const PublicacionTile({
    super.key,
    required this.publicacion,
    required this.alTocar,
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
        trailing: const Icon(Icons.chevron_right),
        onTap: alTocar,
      ),
    );
  }
}

