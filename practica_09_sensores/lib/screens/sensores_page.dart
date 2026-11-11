import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../services/camara_service.dart';
import '../services/sensores_service.dart';

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  final CamaraService _camara = CamaraService();
  final SensoresService _sensores = SensoresService();

  StreamSubscription<LecturaSensor>? _subAcel;
  StreamSubscription<LecturaSensor>? _subGiro;

  LecturaSensor? _acel;
  LecturaSensor? _giro;
  String? _errorAcel;
  String? _errorGiro;

  String? _rutaFoto;
  String? _mensajeCamara;
  bool _tomando = false;

  @override
  void initState() {
    super.initState();
    _subAcel = _sensores.acelerometro().listen(
      (lectura) => setState(() => _acel = lectura),
      onError: (_) => setState(() => _errorAcel = 'Acelerómetro no disponible'),
    );
    _subGiro = _sensores.giroscopio().listen(
      (lectura) => setState(() => _giro = lectura),
      onError: (_) => setState(() => _errorGiro = 'Giroscopio no disponible'),
    );
  }

  @override
  void dispose() {
    _subAcel?.cancel();
    _subGiro?.cancel();
    super.dispose();
  }

  Future<void> _tomarFoto() async {
    setState(() => _tomando = true);
    final respuesta = await _camara.tomarFoto();
    if (!mounted) return;
    setState(() {
      _tomando = false;
      switch (respuesta.estado) {
        case EstadoCamara.ok:
          _rutaFoto = respuesta.imagen!.path;
          _mensajeCamara = null;
        case EstadoCamara.cancelado:
          _mensajeCamara = 'Captura cancelada. No se tomó ninguna foto.';
        case EstadoCamara.permisoDenegado:
          _mensajeCamara =
              'Permiso de cámara denegado. Actívalo en los ajustes de la app.';
        case EstadoCamara.error:
          _mensajeCamara = 'No se pudo abrir la cámara. Intenta de nuevo.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cámara y sensores')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: _tomando ? null : _tomarFoto,
            icon: const Icon(Icons.camera_alt),
            label: Text(_tomando ? 'Abriendo cámara...' : 'Tomar foto'),
          ),
          if (_mensajeCamara != null) ...[
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_mensajeCamara!),
              ),
            ),
          ],
          if (_rutaFoto != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_rutaFoto!),
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 16),
          _TarjetaSensor(
            titulo: 'Acelerómetro (m/s²)',
            lectura: _acel,
            error: _errorAcel,
          ),
          const SizedBox(height: 12),
          _TarjetaSensor(
            titulo: 'Giroscopio (rad/s)',
            lectura: _giro,
            error: _errorGiro,
          ),
        ],
      ),
    );
  }
}

class _TarjetaSensor extends StatelessWidget {
  const _TarjetaSensor({
    required this.titulo,
    required this.lectura,
    required this.error,
  });

  final String titulo;
  final LecturaSensor? lectura;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final String contenido;
    if (error != null) {
      contenido = error!;
    } else if (lectura == null) {
      contenido = 'Esperando datos...';
    } else {
      contenido =
          'X: ${lectura!.x.toStringAsFixed(2)}\n'
          'Y: ${lectura!.y.toStringAsFixed(2)}\n'
          'Z: ${lectura!.z.toStringAsFixed(2)}';
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(contenido),
          ],
        ),
      ),
    );
  }
}
