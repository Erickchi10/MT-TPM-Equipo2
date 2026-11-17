import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';
import '../widgets/boton_accion.dart';
import '../widgets/encabezado_seccion.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador con Provider')),
      body: Column(
        children: [
          const EncabezadoSeccion(
            titulo: 'Práctica guiada',
            subtitulo: 'Solo el texto del contador se reconstruye.',
          ),
          const Spacer(),
          Consumer<ContadorProvider>(
            builder: (context, contador, _) => Text(
              '${contador.valor}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const SizedBox(height: 16),
          BotonAccion(
            texto: 'Incrementar',
            icono: Icons.add,
            onPressed: () => context.read<ContadorProvider>().incrementar(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
