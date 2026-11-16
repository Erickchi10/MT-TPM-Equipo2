import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../services/camara_service.dart';
import '../services/sensores_service.dart';

class SensoresScreen extends StatefulWidget {
  const SensoresScreen({
    super.key,
    required this.camara,
    required this.sensores,
  });

  final CamaraService camara;
  final SensoresService sensores;

  @override
  State<SensoresScreen> createState() => _SensoresScreenState();
}

class _SensoresScreenState extends State<SensoresScreen> {
  String? _rutaFoto;
  String? _mensaje;
  bool _tomando = false;

  Lectura? _acel;
  Lectura? _giro;
  bool _acelDisponible = true;
  bool _giroDisponible = true;

  StreamSubscription<Lectura>? _subAcel;
  StreamSubscription<Lectura>? _subGiro;

  @override
  void initState() {
    super.initState();
    _subAcel = widget.sensores.acelerometro().listen(
      (l) => setState(() => _acel = l),
      onError: (_) => setState(() => _acelDisponible = false),
      cancelOnError: true,
    );
    _subGiro = widget.sensores.giroscopio().listen(
      (l) => setState(() => _giro = l),
      onError: (_) => setState(() => _giroDisponible = false),
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    // Se cancelan las suscripciones para no seguir leyendo los sensores.
    _subAcel?.cancel();
    _subGiro?.cancel();
    super.dispose();
  }

  Future<void> _tomarFoto() async {
    setState(() {
      _tomando = true;
      _mensaje = null;
    });
    final r = await widget.camara.tomarFoto();
    if (!mounted) return;
    setState(() {
      _tomando = false;
      switch (r.estado) {
        case EstadoFoto.ok:
          _rutaFoto = r.ruta;
          _mensaje = 'Foto tomada';
        case EstadoFoto.cancelada:
          _mensaje = 'Captura cancelada';
        case EstadoFoto.sinPermiso:
          _mensaje = 'Permiso de cámara denegado. Actívalo en Ajustes.';
        case EstadoFoto.error:
          _mensaje = 'No se pudo tomar la foto: ${r.detalle}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Cámara y sensores')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 220,
                color: esquema.surfaceContainerHighest,
                child: _rutaFoto == null
                    ? const Center(
                        child: Icon(Icons.photo_camera_outlined, size: 64),
                      )
                    : Image.file(File(_rutaFoto!), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _tomando ? null : _tomarFoto,
              icon: const Icon(Icons.camera_alt),
              label: Text(_tomando ? 'Abriendo cámara...' : 'Tomar foto'),
            ),
            if (_mensaje != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_mensaje!, textAlign: TextAlign.center),
              ),
            const SizedBox(height: 16),
            _TarjetaSensor(
              titulo: 'Acelerómetro',
              unidad: 'm/s²',
              icono: Icons.speed,
              lectura: _acel,
              disponible: _acelDisponible,
            ),
            _TarjetaSensor(
              titulo: 'Giroscopio',
              unidad: 'rad/s',
              icono: Icons.threesixty,
              lectura: _giro,
              disponible: _giroDisponible,
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaSensor extends StatelessWidget {
  const _TarjetaSensor({
    required this.titulo,
    required this.unidad,
    required this.icono,
    required this.lectura,
    required this.disponible,
  });

  final String titulo;
  final String unidad;
  final IconData icono;
  final Lectura? lectura;
  final bool disponible;

  @override
  Widget build(BuildContext context) {
    final l = lectura;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono),
                const SizedBox(width: 8),
                Text(titulo, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(unidad),
              ],
            ),
            const SizedBox(height: 12),
            if (!disponible)
              const Text('No disponible en este dispositivo')
            else if (l == null)
              const Text('Esperando lecturas...')
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Eje(eje: 'X', valor: l.x),
                  _Eje(eje: 'Y', valor: l.y),
                  _Eje(eje: 'Z', valor: l.z),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Eje extends StatelessWidget {
  const _Eje({required this.eje, required this.valor});

  final String eje;
  final double valor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(eje, style: Theme.of(context).textTheme.labelLarge),
        Text(
          valor.toStringAsFixed(2),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
