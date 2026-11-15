import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/publicaciones_provider.dart';

class BarraBusqueda extends StatelessWidget {
  const BarraBusqueda({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Buscar por título o contenido',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (texto) =>
            context.read<PublicacionesProvider>().buscar(texto),
      ),
    );
  }
}
