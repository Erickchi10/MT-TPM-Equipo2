import 'package:flutter/material.dart';

import '../models/registro.dart';
import '../services/formato_service.dart';

class TarjetaRegistro extends StatelessWidget {
  final Registro registro;

  const TarjetaRegistro({super.key, required this.registro});

  IconData get _icono => switch (registro.tipo) {
    TipoAccion.incremento => Icons.add_circle_outline,
    TipoAccion.decremento => Icons.remove_circle_outline,
    TipoAccion.reinicio => Icons.restart_alt,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(_icono),
        title: Text(registro.descripcion),
        subtitle: Text(FormatoService.fechaHora(registro.fecha)),
        trailing: Text(
          '= ${registro.valorResultante}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
