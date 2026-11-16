import 'dart:io';

import 'package:flutter/material.dart';

import '../models/objeto.dart';
import '../services/formato.dart';
import 'estado_chip.dart';

IconData iconoCategoria(String categoria) => switch (categoria) {
  'Electrónicos' => Icons.devices,
  'Ropa' => Icons.checkroom,
  'Documentos' => Icons.badge,
  'Llaves' => Icons.key,
  _ => Icons.inventory_2,
};

class ObjetoCard extends StatelessWidget {
  const ObjetoCard({super.key, required this.objeto, required this.onTap});

  final Objeto objeto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final o = objeto;
    final foto = o.fotoRuta;
    final tema = Theme.of(context);
    final icono = Center(child: Icon(iconoCategoria(o.categoria), size: 32));
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: foto == null
                      ? ColoredBox(
                          color: tema.colorScheme.surfaceContainerHighest,
                          child: icono,
                        )
                      : Image.file(
                          File(foto),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => icono,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.nombre,
                      style: tema.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${o.categoria} · ${o.lugar}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${Formato.fecha(o.fecha)} ${Formato.hora(o.fecha)}',
                      style: tema.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    EstadoChip(estado: o.estado),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
