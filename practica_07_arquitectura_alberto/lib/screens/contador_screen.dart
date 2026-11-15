import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';
import '../widgets/boton_accion.dart';
import '../widgets/encabezado_contador.dart';
import '../widgets/lista_historial.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador con Provider')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const EncabezadoContador(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: BotonAccion(
                    icono: Icons.remove,
                    texto: 'Restar',
                    alPresionar: () =>
                        context.read<ContadorProvider>().decrementar(),
                  ),
                ),
                Expanded(
                  child: BotonAccion(
                    icono: Icons.restart_alt,
                    texto: 'Reiniciar',
                    alPresionar: () =>
                        context.read<ContadorProvider>().reiniciar(),
                  ),
                ),
                Expanded(
                  child: BotonAccion(
                    icono: Icons.add,
                    texto: 'Sumar',
                    alPresionar: () =>
                        context.read<ContadorProvider>().incrementar(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Historial', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Expanded(child: ListaHistorial()),
          ],
        ),
      ),
    );
  }
}
