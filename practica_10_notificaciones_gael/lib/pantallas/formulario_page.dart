
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../modelos/inspeccion.dart';
import '../notificaciones.dart';
import '../servicios/database_service.dart';
import '../servicios/ubicacion_service.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String _categoria = 'Mantenimiento';
  XFile? _foto;

  double? _latitud;
  double? _longitud;

  double _ax = 0, _ay = 0, _az = 0;
  double _gx = 0, _gy = 0, _gz = 0;

  bool _obteniendoUbicacion = false;
  bool _guardando = false;

  StreamSubscription<AccelerometerEvent>? _acelerometro;
  StreamSubscription<GyroscopeEvent>? _giroscopio;

  @override
  void initState() {
    super.initState();

    _acelerometro = accelerometerEventStream().listen((e) {
      if (mounted) {
        setState(() {
          _ax = e.x;
          _ay = e.y;
          _az = e.z;
        });
      }
    });

    _giroscopio = gyroscopeEventStream().listen((e) {
      if (mounted) {
        setState(() {
          _gx = e.x;
          _gy = e.y;
          _gz = e.z;
        });
      }
    });
  }

  Future<void> _tomarFoto() async {
    try {
      final archivo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );

      if (!mounted || archivo == null) return;

      setState(() {
        _foto = archivo;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al tomar fotografía: $e')),
      );
    }
  }

  Future<void> _obtenerUbicacion() async {
    setState(() {
      _obteniendoUbicacion = true;
    });

    try {
      final posicion =
          await UbicacionService.obtenerPosicionActual();

      if (!mounted) return;

      setState(() {
        _latitud = posicion.latitude;
        _longitud = posicion.longitude;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _obteniendoUbicacion = false;
        });
      }
    }
  }

  Future<String?> _guardarFotoPermanente() async {
    if (_foto == null) return null;

    final directorio = await getApplicationDocumentsDirectory();

    final carpetaFotos = Directory(
      p.join(directorio.path, 'fotografias'),
    );

    if (!await carpetaFotos.exists()) {
      await carpetaFotos.create(recursive: true);
    }

    final nombreArchivo =
        'inspeccion_${DateTime.now().millisecondsSinceEpoch}'
        '${p.extension(_foto!.path)}';

    final destino = p.join(carpetaFotos.path, nombreArchivo);

    final archivoGuardado = await File(_foto!.path).copy(destino);

    return archivoGuardado.path;
  }

  Future<void> _guardarInspeccion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
    });

    try {
      final fotoPath = await _guardarFotoPermanente();

      final inspeccion = Inspeccion(
        titulo: _tituloController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        categoria: _categoria,
        fotoPath: fotoPath,
        latitud: _latitud,
        longitud: _longitud,
        fecha: DateTime.now().toIso8601String(),
        acelerometroX: _ax,
        acelerometroY: _ay,
        acelerometroZ: _az,
        giroscopioX: _gx,
        giroscopioY: _gy,
        giroscopioZ: _gz,
      );

      await DatabaseService.guardarInspeccion(
        inspeccion.toMap(),
      );

      await Notificaciones.mostrar();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inspección guardada correctamente'),
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _acelerometro?.cancel();
    _giroscopio?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva inspección'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título de la inspección',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa un título';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _descripcionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa una descripción';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Mantenimiento',
                  child: Text('Mantenimiento'),
                ),
                DropdownMenuItem(
                  value: 'Infraestructura',
                  child: Text('Infraestructura'),
                ),
                DropdownMenuItem(
                  value: 'Seguridad',
                  child: Text('Seguridad'),
                ),
                DropdownMenuItem(
                  value: 'Otros',
                  child: Text('Otros'),
                ),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  setState(() {
                    _categoria = valor;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: _tomarFoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Tomar fotografía'),
            ),

            if (_foto != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_foto!.path),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],

            const SizedBox(height: 20),

            const Text(
              'Ubicación GPS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: _obteniendoUbicacion
                  ? null
                  : _obtenerUbicacion,
              icon: const Icon(Icons.location_on),
              label: Text(
                _obteniendoUbicacion
                    ? 'Obteniendo ubicación...'
                    : 'Obtener ubicación actual',
              ),
            ),

            if (_latitud != null && _longitud != null) ...[
              Text('Latitud: $_latitud'),
              Text('Longitud: $_longitud'),
            ],

            const SizedBox(height: 20),

            const Text(
              'Sensores del dispositivo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text('Acelerómetro: ${_ax.toStringAsFixed(2)}, '
                '${_ay.toStringAsFixed(2)}, '
                '${_az.toStringAsFixed(2)}'),

            Text('Giroscopio: ${_gx.toStringAsFixed(2)}, '
                '${_gy.toStringAsFixed(2)}, '
                '${_gz.toStringAsFixed(2)}'),

            const SizedBox(height: 25),

            FilledButton.icon(
              onPressed: _guardando
                  ? null
                  : _guardarInspeccion,
              icon: const Icon(Icons.save),
              label: Text(
                _guardando
                    ? 'Guardando...'
                    : 'Guardar inspección',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
