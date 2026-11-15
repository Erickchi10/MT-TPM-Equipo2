import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';
import '../services/formato_service.dart';

class EncabezadoContador extends StatelessWidget {
  const EncabezadoContador({super.key});

  @override
  Widget build(BuildContext context) {
    final valor = context.select<ContadorProvider, int>((p) => p.valor);
    final tema = Theme.of(context);
    return Card(
      color: tema.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Text('Valor actual', style: tema.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              FormatoService.numero(valor),
              style: tema.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
