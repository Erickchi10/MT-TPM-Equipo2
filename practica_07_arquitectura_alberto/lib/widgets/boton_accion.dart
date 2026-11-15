import 'package:flutter/material.dart';

class BotonAccion extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback alPresionar;

  const BotonAccion({
    super.key,
    required this.icono,
    required this.texto,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilledButton.tonalIcon(
        onPressed: alPresionar,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        icon: Icon(icono, size: 18),
        // Si no cabe, el texto se reduce en lugar de partirse en dos líneas.
        label: FittedBox(fit: BoxFit.scaleDown, child: Text(texto)),
      ),
    );
  }
}

