import 'dart:io';

import 'package:flutter/material.dart';

import '../models/reporte.dart';

class ReporteCard extends StatelessWidget {
  final Reporte reporte;
  final VoidCallback onTap;
  final VoidCallback onEliminar;

  const ReporteCard({
    super.key,
    required this.reporte,
    required this.onTap,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reporte.imagenPath != null &&
                  File(reporte.imagenPath!).existsSync()) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(reporte.imagenPath!),
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      reporte.titulo,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onEliminar,
                    tooltip: 'Eliminar reporte',
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                reporte.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Chip(
                    avatar: const Icon(Icons.category_outlined, size: 17),
                    label: Text(reporte.categoria),
                    visualDensity: VisualDensity.compact,
                  ),
                  Chip(
                    avatar: Icon(
                      reporte.sincronizado
                          ? Icons.cloud_done
                          : Icons.cloud_upload_outlined,
                      size: 17,
                    ),
                    label: Text(
                      reporte.sincronizado ? 'Sincronizado' : 'Pendiente',
                    ),
                    backgroundColor: reporte.sincronizado
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      reporte.fecha.toLocal().toString().split('.').first,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const Text(
                    'Ver detalle',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 13,
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
