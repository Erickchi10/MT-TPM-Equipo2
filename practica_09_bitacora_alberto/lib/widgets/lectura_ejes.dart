import 'package:flutter/material.dart';

import '../services/formato.dart';
import '../services/sensores_service.dart';

class LecturaEjes extends StatelessWidget {
  const LecturaEjes({super.key, required this.titulo, required this.lectura});

  final String titulo;
  final Lectura? lectura;

  @override
  Widget build(BuildContext context) {
    final l = lectura;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        if (l == null)
          const Text('No disponible')
        else
          Row(children: [_eje('X', l.x), _eje('Y', l.y), _eje('Z', l.z)]),
      ],
    );
  }

  Widget _eje(String eje, double valor) =>
      Expanded(child: Text('$eje: ${Formato.valor(valor)}'));
}
