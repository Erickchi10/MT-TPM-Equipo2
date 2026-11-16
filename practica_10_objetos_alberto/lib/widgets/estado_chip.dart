import 'package:flutter/material.dart';

import '../models/objeto.dart';

Color colorEstado(EstadoObjeto e) => switch (e) {
  EstadoObjeto.encontrado => Colors.orange,
  EstadoObjeto.reclamado => Colors.blue,
  EstadoObjeto.entregado => Colors.green,
};

IconData iconoEstado(EstadoObjeto e) => switch (e) {
  EstadoObjeto.encontrado => Icons.search,
  EstadoObjeto.reclamado => Icons.front_hand,
  EstadoObjeto.entregado => Icons.check_circle,
};

class EstadoChip extends StatelessWidget {
  const EstadoChip({super.key, required this.estado});

  final EstadoObjeto estado;

  @override
  Widget build(BuildContext context) {
    final color = colorEstado(estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconoEstado(estado), size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            estado.etiqueta,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
