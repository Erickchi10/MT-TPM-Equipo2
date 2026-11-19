import 'package:flutter/material.dart';

import '../models/reporte.dart';
import '../services/api_service.dart';
import '../services/reporte_storage_service.dart';

class ServiciosPage extends StatefulWidget {
  const ServiciosPage({super.key});

  @override
  State<ServiciosPage> createState() => _ServiciosPageState();
}

class _ServiciosPageState extends State<ServiciosPage> {
  final ReporteStorageService _storageService = ReporteStorageService();

  late Future<List<ServicioPost>> _futurePosts;
  late Future<List<Reporte>> _futureReportes;

  final Set<int> _sincronizandoIds = {};

  @override
  void initState() {
    super.initState();
    _cargarInformacion();
  }

  void _cargarInformacion() {
    _futurePosts = ApiService.obtenerPosts();
    _futureReportes = _storageService.obtenerReportes();
  }

  Future<void> _actualizarTodo() async {
    setState(() {
      _cargarInformacion();
    });

    try {
      await Future.wait([_futurePosts, _futureReportes]);
    } catch (_) {
      // Los errores se muestran en los FutureBuilder.
    }
  }

  Future<void> _sincronizarReporte(Reporte reporte) async {
    if (reporte.id == null) return;

    if (reporte.sincronizado || _sincronizandoIds.contains(reporte.id)) {
      return;
    }

    setState(() {
      _sincronizandoIds.add(reporte.id!);
    });

    try {
      // Enviar los datos del reporte mediante HTTP POST.
      final idServidor = await ApiService.sincronizarReporte(reporte);

      // Actualizar el estado del reporte en el teléfono.
      await _storageService.marcarComoSincronizado(reporte.id!);

      if (!mounted) return;

      setState(() {
        _futureReportes = _storageService.obtenerReportes();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reporte enviado correctamente. ID de respuesta: $idServidor',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo sincronizar el reporte: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sincronizandoIds.remove(reporte.id);
        });
      }
    }
  }

  Widget _construirSeccionReportes() {
    return FutureBuilder<List<Reporte>>(
      future: _futureReportes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return _mensajeError(
            'No se pudieron cargar los reportes locales.',
            () {
              setState(() {
                _futureReportes = _storageService.obtenerReportes();
              });
            },
          );
        }

        final reportes = snapshot.data ?? [];

        final pendientes = reportes
            .where((reporte) => !reporte.sincronizado)
            .length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Reportes locales',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _futureReportes = _storageService.obtenerReportes();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Actualizar reportes',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total de reportes: ${reportes.length}'),
                  const SizedBox(height: 5),
                  Text('Pendientes: $pendientes'),
                  const SizedBox(height: 5),
                  Text('Enviados: ${reportes.length - pendientes}'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (reportes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 45,
                      color: Colors.blueGrey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Todavía no tienes reportes guardados.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...reportes.map(_construirTarjetaReporte),
          ],
        );
      },
    );
  }

  Widget _construirTarjetaReporte(Reporte reporte) {
    final estaSincronizando =
        reporte.id != null && _sincronizandoIds.contains(reporte.id);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reporte.titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            Text('Categoría: ${reporte.categoria}'),
            const SizedBox(height: 5),
            Text(
              'Fecha: ${reporte.fecha.toLocal().toString().split('.').first}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  reporte.sincronizado
                      ? Icons.cloud_done
                      : Icons.cloud_upload_outlined,
                  color: reporte.sincronizado ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    reporte.sincronizado
                        ? 'Enviado (simulación)'
                        : 'Pendiente de envío',
                    style: TextStyle(
                      color: reporte.sincronizado
                          ? Colors.green.shade700
                          : Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (!reporte.sincronizado) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: estaSincronizando
                      ? null
                      : () => _sincronizarReporte(reporte),
                  icon: estaSincronizando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.cloud_upload_outlined),
                  label: Text(
                    estaSincronizando
                        ? 'Enviando reporte...'
                        : 'Sincronizar reporte',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _construirSeccionApi() {
    return FutureBuilder<List<ServicioPost>>(
      future: _futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Consultando API REST...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return _mensajeError(
            'No se pudo obtener la información de la API.',
            () {
              setState(() {
                _futurePosts = ApiService.obtenerPosts();
              });
            },
          );
        }

        final publicaciones = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Conexión exitosa. '
                      '${publicaciones.length} publicaciones recibidas.',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Publicaciones del servicio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...publicaciones.map((publicacion) {
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: Text(
                              '${publicacion.id}',
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              publicacion.titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        publicacion.contenido,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Usuario: ${publicacion.userId}',
                          style: TextStyle(
                            color: Colors.blueGrey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _mensajeError(String mensaje, VoidCallback reintentar) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_outlined, size: 42, color: Colors.red),
          const SizedBox(height: 10),
          Text(mensaje, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: reintentar,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Servicios y API',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _actualizarTodo,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar información',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _actualizarTodo,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Integración de servicios',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Consulta información externa y sincroniza '
              'tus reportes guardados.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sincronización de incidencias',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _construirSeccionReportes(),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Consulta de API REST (GET)',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _construirSeccionApi(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'La sincronización utiliza JSONPlaceholder '
                      'como servidor de prueba. La respuesta POST '
                      'es simulada y no representa un almacenamiento '
                      'permanente en un servidor real.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
