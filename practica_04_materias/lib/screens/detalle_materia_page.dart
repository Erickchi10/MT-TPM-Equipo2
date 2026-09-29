import 'package:flutter/material.dart';
import '../models/materia.dart';

class DetalleMateriaPage extends StatelessWidget {
  final Materia materia;
  const DetalleMateriaPage({super.key, required this.materia});

  @override
  Widget build(BuildContext context) => Scaffold(
     appBar: AppBar(title: Text(materia.nombre)),
     body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.menu_book, size: 100),
          Text(materia.nombre, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Semestre: ${materia.semestre}'),
          Text('Créditos: ${materia.creditos}'),
          const SizedBox(height: 16),
          Text(materia.descripcion),
        ]),
     ),
  );
}

