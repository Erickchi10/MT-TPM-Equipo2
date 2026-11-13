import 'package:flutter/material.dart';
import '../models/publicacion.dart';
import '../services/api_publicaciones.dart';
import '../widgets/publicacion_tile.dart';
import 'detalle_publicacion.dart';

class ListaPublicaciones extends StatefulWidget {
  final ApiPublicaciones api;
  const ListaPublicaciones({super.key, required this.api});

  @override
  State<ListaPublicaciones> createState() => _ListaPublicacionesState();
}

class _ListaPublicacionesState extends State<ListaPublicaciones> {
  late Future<List<Publicacion>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = widget.api.obtenerPublicaciones();
  }

  Future<void> _recargar() async {
    final nuevo = widget.api.obtenerPublicaciones();
    setState(() => _futuro = nuevo);
    try {
      await nuevo;
    } catch (_) {
      // El error ya lo muestra el FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicaciones')),
      body: FutureBuilder<List<Publicacion>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 64),
                    const SizedBox(height: 12),
                    Text(
                      'No se pudieron cargar las publicaciones\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _recargar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }
          final publicaciones = snapshot.data ?? [];
          if (publicaciones.isEmpty) {
            return const Center(child: Text('No hay publicaciones'));
          }
          return RefreshIndicator(
            onRefresh: _recargar,
            child: ListView.builder(
              itemCount: publicaciones.length,
              itemBuilder: (context, i) {
                final p = publicaciones[i];
                return PublicacionTile(
                  publicacion: p,
                  alTocar: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetallePublicacion(publicacion: p),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

