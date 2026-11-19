import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../models/evidencia.dart';
import '../services/camara_service.dart';
import '../services/sensores_service.dart';
import '../services/evidencia_storage_service.dart';
import '../widgets/evidencia_card.dart';
import '../widgets/sensor_card.dart';

class InspeccionPage extends StatefulWidget {
  const InspeccionPage({super.key});

  @override
  State<InspeccionPage> createState() => _InspeccionPageState();
}

class _InspeccionPageState extends State<InspeccionPage> {
  final CamaraService _camaraService = CamaraService();
  final SensoresService _sensoresService = SensoresService();
  final EvidenciaStorageService _storageService = EvidenciaStorageService();

  StreamSubscription<AccelerometerEvent>? _acelerometroSubscription;
  StreamSubscription<GyroscopeEvent>? _giroscopioSubscription;

  final List<Evidencia> _evidencias = [];

  double _acelerometroX = 0;
  double _acelerometroY = 0;
  double _acelerometroZ = 0;

  double _giroscopioX = 0;
  double _giroscopioY = 0;
  double _giroscopioZ = 0;

  bool _capturando = false;
  bool _cargandoEvidencias = true;
  String? _errorSensores;

  @override
  void initState() {
    super.initState();
    _iniciarSensores();
    _cargarEvidenciasGuardadas();
  }

  Future<void> _cargarEvidenciasGuardadas() async {
    try {
      final evidencias = await _storageService.cargarEvidencias();

      if (!mounted) return;

      setState(() {
        _evidencias
          ..clear()
          ..addAll(evidencias);
        _cargandoEvidencias = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _cargandoEvidencias = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al recuperar evidencias: $error')),
      );
    }
  }

  void _iniciarSensores() {
    _acelerometroSubscription = _sensoresService.obtenerAcelerometro().listen(
      (evento) {
        if (!mounted) return;

        setState(() {
          _acelerometroX = evento.x;
          _acelerometroY = evento.y;
          _acelerometroZ = evento.z;
          _errorSensores = null;
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          _errorSensores = 'No se pudo leer el acelerómetro.';
        });
      },
    );

    _giroscopioSubscription = _sensoresService.obtenerGiroscopio().listen(
      (evento) {
        if (!mounted) return;

        setState(() {
          _giroscopioX = evento.x;
          _giroscopioY = evento.y;
          _giroscopioZ = evento.z;
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          _errorSensores = 'No se pudo leer el giroscopio.';
        });
      },
    );
  }

  Future<void> _tomarFotografia() async {
    await _seleccionarImagen(() => _camaraService.tomarFotografia());
  }

  Future<void> _seleccionarDeGaleria() async {
    await _seleccionarImagen(() => _camaraService.seleccionarGaleria());
  }

  Future<void> _seleccionarImagen(
    Future<XFile?> Function() obtenerImagen,
  ) async {
    if (_capturando) return;

    setState(() {
      _capturando = true;
    });

    try {
      final archivo = await obtenerImagen();

      if (!mounted) return;

      if (archivo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Operación cancelada. No se agregó evidencia.'),
          ),
        );
        return;
      }

      final nuevaEvidencia = Evidencia(
        imagePath: archivo.path,
        fecha: DateTime.now(),
        acelerometroX: _acelerometroX,
        acelerometroY: _acelerometroY,
        acelerometroZ: _acelerometroZ,
        giroscopioX: _giroscopioX,
        giroscopioY: _giroscopioY,
        giroscopioZ: _giroscopioZ,
      );

      final evidenciaGuardada = await _storageService.guardarEvidencia(
        nuevaEvidencia,
      );

      if (!mounted) return;

      setState(() {
        _evidencias.insert(0, evidenciaGuardada);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evidencia guardada correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar la evidencia: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _capturando = false;
        });
      }
    }
  }

  Future<void> _eliminarEvidencia(int index) async {
    final evidencia = _evidencias[index];

    try {
      await _storageService.eliminarEvidencia(evidencia);

      if (!mounted) return;

      setState(() {
        _evidencias.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evidencia eliminada correctamente.')),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo eliminar la evidencia: $error')),
      );
    }
  }

  @override
  void dispose() {
    _acelerometroSubscription?.cancel();
    _giroscopioSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de Inspección'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registro multimedia y sensores',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Captura fotografías y registra los valores '
                    'de movimiento del dispositivo para generar '
                    'evidencias de inspección.',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Captura de imágenes',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: _capturando ? null : _tomarFotografia,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Tomar fotografía'),
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            onPressed: _capturando ? null : _seleccionarDeGaleria,
            icon: const Icon(Icons.photo_library),
            label: const Text('Seleccionar de galería'),
          ),

          if (_capturando) ...[
            const SizedBox(height: 12),
            const Center(child: CircularProgressIndicator()),
          ],

          const SizedBox(height: 24),

          const Text(
            'Sensores del dispositivo',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          if (_errorSensores != null)
            Text(_errorSensores!, style: const TextStyle(color: Colors.red)),

          SensorCard(
            titulo: 'Acelerómetro',
            icono: Icons.speed,
            x: _acelerometroX,
            y: _acelerometroY,
            z: _acelerometroZ,
            unidad: 'm/s²',
          ),

          SensorCard(
            titulo: 'Giroscopio',
            icono: Icons.screen_rotation,
            x: _giroscopioX,
            y: _giroscopioY,
            z: _giroscopioZ,
            unidad: 'rad/s',
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Evidencias registradas',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              Chip(label: Text('${_evidencias.length}')),
            ],
          ),

          const SizedBox(height: 12),

          if (_cargandoEvidencias)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_evidencias.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Todavía no hay evidencias.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Toma una fotografía para comenzar.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._evidencias.asMap().entries.map((entrada) {
              final index = entrada.key;
              final evidencia = entrada.value;

              return EvidenciaCard(
                evidencia: evidencia,
                onEliminar: () => _eliminarEvidencia(index),
              );
            }),
        ],
      ),
    );
  }
}
