import 'dart:io';

import 'package:flutter/material.dart';

import '../models/incidencia.dart';
import '../services/camara_service.dart';
import '../services/incidencias_service.dart';
import '../services/notificacion_service.dart';
import '../services/ubicacion_service.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  static const List<String> _categorias = [
    'Bache',
    'Alumbrado',
    'Basura',
    'Fuga de agua',
    'Otro',
  ];

  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  final _camara = CamaraService();
  final _ubicacion = UbicacionService();
  final _almacen = IncidenciasService();
  final _notificaciones = NotificacionService();

  String? _categoria;
  String? _fotoPath;
  double? _latitud;
  double? _longitud;
  String? _mensaje;
  bool _guardando = false;
  bool _buscandoUbicacion = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto() async {
    final r = await _camara.tomarFoto();
    if (!mounted) return;
    setState(() {
      switch (r.estado) {
        case EstadoCamara.ok:
          _fotoPath = r.imagen!.path;
          _mensaje = null;
        case EstadoCamara.cancelado:
          _mensaje = 'Se canceló la cámara. Puedes guardar sin foto.';
        case EstadoCamara.permisoDenegado:
          _mensaje = 'Permiso de cámara denegado. Puedes guardar sin foto.';
        case EstadoCamara.error:
          _mensaje = 'No se pudo abrir la cámara.';
      }
    });
  }

  Future<void> _obtenerUbicacion() async {
    setState(() => _buscandoUbicacion = true);
    final r = await _ubicacion.obtenerPosicion();
    if (!mounted) return;
    setState(() {
      _buscandoUbicacion = false;
      switch (r.estado) {
        case EstadoUbicacion.ok:
          _latitud = r.posicion!.latitude;
          _longitud = r.posicion!.longitude;
          _mensaje = null;
        case EstadoUbicacion.servicioDesactivado:
          _mensaje =
              'El GPS está desactivado. Actívalo o guarda sin ubicación.';
        case EstadoUbicacion.permisoDenegado:
          _mensaje =
              'Permiso de ubicación denegado. Puedes guardar sin ubicación.';
        case EstadoUbicacion.permisoDenegadoParaSiempre:
          _mensaje = 'Permiso de ubicación bloqueado. Actívalo en los ajustes de la app.';
        case EstadoUbicacion.error:
          _mensaje = 'No se pudo obtener la ubicación.';
      }
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    String? fotoGuardada;
    if (_fotoPath != null) {
      fotoGuardada = await _almacen.copiarFoto(_fotoPath!);
    }

    final nueva = Incidencia(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: _tituloCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim(),
      categoria: _categoria!,
      fecha: DateTime.now(),
      fotoPath: fotoGuardada,
      latitud: _latitud,
      longitud: _longitud,
    );

    final lista = await _almacen.cargar();
    lista.insert(0, nueva);
    await _almacen.guardar(lista);

    await _notificaciones.mostrar(
      titulo: 'Reporte guardado',
      cuerpo: nueva.titulo,
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo reporte')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Escribe un título';
                if (t.length < 3) return 'Mínimo 3 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descripcionCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Escribe una descripción';
                if (t.length < 10) return 'Mínimo 10 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: _categorias
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _categoria = v),
              validator: (v) => v == null ? 'Elige una categoría' : null,
            ),
            const SizedBox(height: 16),
            if (_fotoPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_fotoPath!),
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _tomarFoto,
              icon: const Icon(Icons.camera_alt),
              label: Text(_fotoPath == null ? 'Tomar foto' : 'Cambiar foto'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _buscandoUbicacion ? null : _obtenerUbicacion,
              icon: _buscandoUbicacion
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: Text(
                _latitud == null
                    ? 'Obtener ubicación'
                    : '${_latitud!.toStringAsFixed(6)}, ${_longitud!.toStringAsFixed(6)}',
              ),
            ),
            if (_mensaje != null) ...[
              const SizedBox(height: 12),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_mensaje!),
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: const Icon(Icons.save),
              label: Text(_guardando ? 'Guardando...' : 'Guardar reporte'),
            ),
          ],
        ),
      ),
    );
  }
}
