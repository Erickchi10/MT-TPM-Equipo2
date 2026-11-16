import 'dart:io';

import 'package:flutter/material.dart';

import '../models/incidencia.dart';
import '../services/formato.dart';

IconData iconoCategoria(String categoria) => switch (categoria) {
  'Infraestructura' => Icons.construction,
  'Limpieza' => Icons.cleaning_services,
  'Seguridad' => Icons.shield,
  'Mobiliario' => Icons.chair,
  _ => Icons.report,
};

class IncidenciaTile extends StatelessWidget {
  const IncidenciaTile({
    super.key,
    required this.incidencia,
    required this.onTap,
  });

  final Incidencia incidencia;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final i = incidencia;
    final foto = i.fotoRuta;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage: foto == null ? null : FileImage(File(foto)),
          child: foto == null ? Icon(iconoCategoria(i.categoria)) : null,
        ),
        title: Text(i.titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${i.categoria} · ${Formato.fecha(i.fecha)} ${Formato.hora(i.fecha)}',
        ),
        trailing: Icon(
          i.tieneUbicacion ? Icons.location_on : Icons.location_off,
        ),
      ),
    );
  }
}
