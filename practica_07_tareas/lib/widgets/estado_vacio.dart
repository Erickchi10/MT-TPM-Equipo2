import 'package:flutter/material.dart';

class EstadoVacio extends StatelessWidget {
  const EstadoVacio({super.key, required this.filtro});

  final String filtro;

  @override
  Widget build(BuildContext context) {
    final mensaje = switch (filtro) {
      'pendientes' => 'No hay tareas pendientes',
      'completadas' => 'No hay tareas completadas',
      _ => 'No hay tareas guardadas',
    };
    return Center(child: Text(mensaje));
  }
}
