import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/registro_inspeccion.dart';
import '../services/bitacora_service.dart';
import '../services/camara_service.dart';
import '../services/sensores_service.dart';

class BitacoraPage extends StatefulWidget {
  const BitacoraPage({super.key});

  @override
  State<BitacoraPage> createState() => _BitacoraPageState();
}

class _BitacoraPageState extends State<BitacoraPage> {
  final CamaraService _camara = CamaraService();
  final SensoresService _sensores = SensoresService();
  final BitacoraService _bitacora = BitacoraService();

  StreamSubscription<LecturaSensor>? _subAcel;
  StreamSubscription<LecturaSensor>? _subGiro;

  LecturaSensor? _acel;
  LecturaSensor? _giro;

  final List<RegistroInspeccion> _registros = [];
  String? _mensaje;
  bool _tomando = false;

  @override
  void initState() {
    super.initState();
    _cargarRegistros();
    _subAcel = _sensores.acelerometro().listen(
      (lectura) => setState(() => _acel = lectura),
      onError: (_) {},
    );
    _subGiro = _sensores.giroscopio().listen(
      (lectura) => setState(() => _giro = lectura),
      onError: (_) {},
    );
  }

  @override
  void dispose() {
    _subAcel?.cancel();
    _subGiro?.cancel();
    super.dispose();
  }

  Future<void> _cargarRegistros() async {
    final guardados = await _bitacora.cargar();
    if (!mounted) return;
    setState(() => _registros.addAll(guardados));
  }

  Future<void> _registrar() async {
    setState(() {
      _tomando = true;
      _mensaje = null;
    });
    final respuesta = await _camara.tomarFoto();
    if (!mounted) return;

    if (respuesta.estado == EstadoCamara.ok) {
      final ahora = DateTime.now();
      final acel = _acel;
      final giro = _giro;
      final ruta = await _bitacora.copiarFoto(respuesta.imagen!.path);
      if (!mounted) return;
      final registro = RegistroInspeccion(
        rutaFoto: ruta,
        fecha: ahora,
        acelerometro: acel,
        giroscopio: giro,
      );
      setState(() {
        _registros.insert(0, registro);
        _tomando = false;
      });
      await _bitacora.guardar(_registros);
      return;
    }

    setState(() {
      _tomando = false;
      _mensaje = switch (respuesta.estado) {
        EstadoCamara.cancelado =>
          'Captura cancelada. No se registró ninguna inspección.',
        EstadoCamara.permisoDenegado =>
          'Permiso de cámara denegado. Actívalo en los ajustes de la app.',
        _ => 'No se pudo abrir la cámara. Intenta de nuevo.',
      };
    });
  }

  Future<void> _eliminar(RegistroInspeccion registro) async {
    setState(() => _registros.remove(registro));
    await _bitacora.borrarFoto(registro.rutaFoto);
    await _bitacora.guardar(_registros);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bitácora de inspección')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sensores en vivo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Acelerómetro (m/s²)\n'
                    '${RegistroInspeccion.textoLectura(_acel)}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Giroscopio (rad/s)\n'
                    '${RegistroInspeccion.textoLectura(_giro)}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _tomando ? null : _registrar,
            icon: const Icon(Icons.camera_alt),
            label: Text(
              _tomando ? 'Abriendo cámara...' : 'Registrar inspección',
            ),
          ),
          if (_mensaje != null) ...[
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_mensaje!),
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (_registros.isEmpty)
            const Center(child: Text('Aún no hay inspecciones registradas.')),
          for (var i = 0; i < _registros.length; i++)
            _TarjetaEvidencia(
              registro: _registros[i],
              numero: _registros.length - i,
              onEliminar: () => _eliminar(_registros[i]),
            ),
        ],
      ),
    );
  }
}

class _TarjetaEvidencia extends StatelessWidget {
  const _TarjetaEvidencia({
    required this.registro,
    required this.numero,
    required this.onEliminar,
  });

  final RegistroInspeccion registro;
  final int numero;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(
            File(registro.rutaFoto),
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox(
              height: 220,
              child: Center(child: Text('No se pudo mostrar la foto')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Inspección #$numero',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: onEliminar,
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Eliminar inspección',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Fecha: ${registro.fechaTexto}'),
                Text('Hora: ${registro.horaTexto}'),
                const SizedBox(height: 8),
                Text('Acelerómetro (m/s²)\n${registro.acelerometroTexto}'),
                const SizedBox(height: 8),
                Text('Giroscopio (rad/s)\n${registro.giroscopioTexto}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
