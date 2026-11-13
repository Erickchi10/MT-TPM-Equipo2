import 'package:flutter/material.dart';

import '../models/aviso.dart';
import '../services/api_service.dart';

class AvisosPage extends StatefulWidget {
  const AvisosPage({super.key});

  @override
  State<AvisosPage> createState() => _AvisosPageState();
}

class _AvisosPageState extends State<AvisosPage> {
  final _api = ApiService();
  bool _cargando = true;
  EstadoApi _estado = EstadoApi.ok;
  List<Aviso> _avisos = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final r = await _api.obtenerAvisos();
    if (!mounted) return;
    setState(() {
      _estado = r.estado;
      _avisos = r.avisos;
      _cargando = false;
    });
  }

  String get _mensajeError {
    switch (_estado) {
      case EstadoApi.sinConexion:
        return 'Sin conexión a internet.';
      case EstadoApi.errorServidor:
        return 'El servidor respondió con un error.';
      case EstadoApi.error:
        return 'No se pudieron cargar los avisos.';
      case EstadoApi.ok:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos de la comunidad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _cargando ? null : _cargar,
          ),
        ],
      ),
      body: _cuerpo(),
    );
  }

  Widget _cuerpo() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_estado != EstadoApi.ok) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 48),
              const SizedBox(height: 12),
              Text(_mensajeError, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _cargar, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: _avisos.length,
      itemBuilder: (context, i) {
        final a = _avisos[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(child: Text('${a.id}')),
            title: Text(a.titulo, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              a.texto,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
