import 'package:flutter/material.dart';

import '../models/tecnico.dart';
import '../services/api_service.dart';

class TecnicosPage extends StatefulWidget {
  const TecnicosPage({super.key});

  @override
  State<TecnicosPage> createState() => _TecnicosPageState();
}

class _TecnicosPageState extends State<TecnicosPage> {
  final _api = ApiService();
  bool _cargando = true;
  EstadoApi _estado = EstadoApi.ok;
  List<Tecnico> _tecnicos = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final r = await _api.obtenerTecnicos();
    if (!mounted) return;
    setState(() {
      _estado = r.estado;
      _tecnicos = r.tecnicos;
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
        return 'No se pudo cargar la lista.';
      case EstadoApi.ok:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Técnicos'),
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
      itemCount: _tecnicos.length,
      itemBuilder: (context, i) {
        final t = _tecnicos[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(child: Text(t.nombre[0])),
            title: Text(t.nombre),
            subtitle: Text(t.correo),
          ),
        );
      },
    );
  }
}
