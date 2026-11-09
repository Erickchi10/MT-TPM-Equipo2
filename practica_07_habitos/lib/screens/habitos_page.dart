import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/habitos_provider.dart';
import '../widgets/campo_nuevo_habito.dart';
import '../widgets/encabezado_resumen.dart';
import '../widgets/tarjeta_habito.dart';

class HabitosPage extends StatelessWidget {
  const HabitosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis hábitos')),
      body: Consumer<HabitosProvider>(
        builder: (context, p, _) {
          if (p.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              EncabezadoResumen(completados: p.completados, total: p.total),
              CampoNuevoHabito(onAgregar: p.agregar),
              const SizedBox(height: 8),
              Expanded(
                child: p.habitos.isEmpty
                    ? const Center(child: Text('No hay hábitos'))
                    : ListView.builder(
                        itemCount: p.habitos.length,
                        itemBuilder: (context, i) {
                          final h = p.habitos[i];
                          return TarjetaHabito(
                            habito: h,
                            onCambiar: () => p.alternar(h),
                            onEliminar: () => p.eliminar(h.id),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
