import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/incidencia.dart';
import '../providers/incidencias_provider.dart';
import '../services/camara_service.dart';
import '../services/ubicacion_service.dart';

class FormIncidenciaScreen extends StatefulWidget {
  const FormIncidenciaScreen({super.key});

  @override
  State<FormIncidenciaScreen> createState() => _FormIncidenciaScreenState();
}

class _FormIncidenciaScreenState extends State<FormIncidenciaScreen> {
  final _form = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _descripcion = TextEditingController();
  String? _categoria;
  String? _foto;
  double? _lat;
  double? _lng;
  String? _avisoUbicacion;
  bool _ubicando = false;
  bool _guardando = false;

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _tomarFoto() async {
    final r = await context.read<IncidenciasProvider>().tomarFoto();
    if (!mounted) return;
    switch (r.estado) {
      case EstadoFoto.ok:
        setState(() => _foto = r.ruta);
      case EstadoFoto.cancelada:
        _avisar('Captura cancelada');
      case EstadoFoto.sinPermiso:
        _avisar('Permiso de cámara denegado. Actívalo en Ajustes.');
      case EstadoFoto.error:
        _avisar('No se pudo tomar la foto: ${r.detalle}');
    }
  }

  Future<void> _ubicar() async {
    setState(() {
      _ubicando = true;
      _avisoUbicacion = null;
    });
    final r = await context.read<IncidenciasProvider>().obtenerUbicacion();
    if (!mounted) return;
    setState(() {
      _ubicando = false;
      switch (r.estado) {
        case EstadoUbicacion.ok:
          _lat = r.latitud;
          _lng = r.longitud;
        case EstadoUbicacion.servicioApagado:
          _avisoUbicacion = 'Activa el servicio de ubicación';
        case EstadoUbicacion.permisoNegado:
          _avisoUbicacion = 'Permiso de ubicación negado';
        case EstadoUbicacion.error:
          _avisoUbicacion = 'No se pudo obtener la ubicación';
      }
    });
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _guardando = true);
    final mensaje = await context.read<IncidenciasProvider>().guardar(
      titulo: _titulo.text,
      descripcion: _descripcion.text,
      categoria: _categoria!,
      fotoTemporal: _foto,
      latitud: _lat,
      longitud: _lng,
    );
    if (!mounted) return;
    Navigator.pop(context, mensaje);
  }

  @override
  Widget build(BuildContext context) {
    final foto = _foto;
    final lat = _lat;
    final lng = _lng;
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo reporte')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titulo,
              maxLength: 50,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej. Lámpara fundida en el pasillo',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Escribe un título';
                if (t.length < 4) return 'Mínimo 4 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descripcion,
              maxLines: 3,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v?.trim().length ?? 0) < 10
                  ? 'Describe el problema (mínimo 10 caracteres)'
                  : null,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final c in categorias)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (c) => setState(() => _categoria = c),
              validator: (c) => c == null ? 'Elige una categoría' : null,
            ),
            const SizedBox(height: 16),
            if (foto != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(foto), height: 180, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton.icon(
              onPressed: _tomarFoto,
              icon: const Icon(Icons.photo_camera),
              label: Text(
                foto == null ? 'Tomar foto (opcional)' : 'Tomar otra foto',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _ubicando ? null : _ubicar,
              icon: const Icon(Icons.my_location),
              label: Text(
                _ubicando ? 'Obteniendo ubicación...' : 'Obtener ubicación',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                lat != null && lng != null
                    ? 'Ubicación: ${lat.toStringAsFixed(6)}, '
                          '${lng.toStringAsFixed(6)}'
                    : (_avisoUbicacion ?? 'Sin ubicación (opcional)'),
                textAlign: TextAlign.center,
              ),
            ),
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
