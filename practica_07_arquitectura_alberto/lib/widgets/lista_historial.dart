import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';
import 'tarjeta_registro.dart';

class ListaHistorial extends StatelessWidget {
  const ListaHistorial({super.key});

  @override
  Widget build(BuildContext context) {
    final historial = context.watch<ContadorProvider>().historial;
    if (historial.isEmpty) {
      return const Center(child: Text('Aún no hay movimientos'));
    }
    return ListView.builder(
      itemCount: historial.length,
      itemBuilder: (context, i) => TarjetaRegistro(registro: historial[i]),
    );
  }
}
