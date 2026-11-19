import 'package:flutter/material.dart';

class CampoFormulario extends StatelessWidget {
  final String etiqueta;
  final String textoAyuda;
  final TextEditingController controller;
  final IconData icono;
  final int maxLineas;
  final int? longitudMaxima;
  final String? Function(String?)? validador;
  final TextInputType tipoTeclado;
  final TextCapitalization capitalizacion;

  const CampoFormulario({
    super.key,
    required this.etiqueta,
    required this.textoAyuda,
    required this.controller,
    required this.icono,
    this.maxLineas = 1,
    this.longitudMaxima,
    this.validador,
    this.tipoTeclado = TextInputType.text,
    this.capitalizacion = TextCapitalization.sentences,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLineas,
          maxLength: longitudMaxima,
          keyboardType: tipoTeclado,
          textCapitalization: capitalizacion,
          validator: validador,
          decoration: InputDecoration(
            hintText: textoAyuda,
            alignLabelWithHint: maxLineas > 1,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: maxLineas > 1 ? 85 : 0),
              child: Icon(icono),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
