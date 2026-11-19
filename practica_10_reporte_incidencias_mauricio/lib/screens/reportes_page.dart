import 'package:flutter/material.dart';

import '../models/reporte.dart';
import '../services/reporte_storage_service.dart';
import '../widgets/reporte_card.dart';
import '../widgets/estado_carga.dart';
import 'detalle_reporte_page.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  final ReporteStorageService _storageService = ReporteStorageService();

  late Future<List<Reporte>> _futuroReportes;

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  void _cargarReportes() {
    _futuroReportes = _storageService.obtenerReportes();
  }

  Future<void> _actualizarReportes() async {
    setState(() {
      _cargarReportes();
    });

    try {
      await _futuroReportes;
    } catch (_) {
      // El error se representa mediante EstadoCarga.
    }
  }

  Future<void> _eliminarReporte(Reporte reporte) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar reporte'),
        content: Text('¿Deseas eliminar "${reporte.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true || reporte.id == null) return;

    try {
      await _storageService.eliminarReporte(reporte.id!);

      if (!mounted) return;

      setState(_cargarReportes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reporte eliminado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo eliminar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _abrirDetalle(Reporte reporte) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleReportePage(reporte: reporte),
      ),
    );

    if (!mounted) return;

    setState(_cargarReportes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis reportes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _actualizarReportes,
            tooltip: 'Actualizar reportes',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Reporte>>(
        future: _futuroReportes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const EstadoCarga(
              tipo: TipoEstado.cargando,
              mensaje: 'Cargando tus reportes...',
            );
          }

          if (snapshot.hasError) {
            return EstadoCarga(
              tipo: TipoEstado.error,
              mensaje: 'No se pudieron cargar los reportes.',
              onReintentar: _actualizarReportes,
            );
          }

          final reportes = snapshot.data ?? [];

          if (reportes.isEmpty) {
            return const EstadoCarga(
              tipo: TipoEstado.vacio,
              mensaje:
                  'No hay reportes registrados. '
                  'Tus incidencias aparecerán aquí cuando registres '
                  'un nuevo reporte.',
            );
          }

          return RefreshIndicator(
            onRefresh: _actualizarReportes,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reportes.length,
              itemBuilder: (context, index) {
                final reporte = reportes[index];

                return ReporteCard(
                  reporte: reporte,
                  onTap: () => _abrirDetalle(reporte),
                  onEliminar: () => _eliminarReporte(reporte),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
