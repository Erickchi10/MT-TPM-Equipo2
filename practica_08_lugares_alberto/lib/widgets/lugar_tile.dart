import 'package:flutter/material.dart';

import '../models/lugar.dart';
import '../services/coordenadas.dart';

class LugarTile extends StatelessWidget {
  final Lugar lugar;
  final double? distancia;
  final VoidCallback alAbrirMapa;
  final VoidCallback alEliminar;

  const LugarTile({
    super.key,
    required this.lugar,
    required this.distancia,
    required this.alAbrirMapa,
    required this.alEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final textoDistancia = distancia == null
        ? 'Distancia: obtén tu ubicación'
        : 'A ${Coordenadas.distancia(distancia!)} de ti';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.place)),
        title: Text(
          lugar.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${lugar.coordenadas}\n$textoDistancia'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Ver en mapa',
              icon: const Icon(Icons.map_outlined),
              onPressed: alAbrirMapa,
            ),
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline),
              onPressed: alEliminar,
            ),
          ],
        ),
      ),
    );
  }
}
