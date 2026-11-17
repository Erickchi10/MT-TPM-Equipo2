import 'package:flutter/material.dart';

class BotonAccion extends StatelessWidget {
  const BotonAccion({
    super.key,
    required this.texto,
    required this.icono,
    required this.onPressed,
  });

  final String texto;
  final IconData icono;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icono),
      label: Text(texto),
    );
  }
}
