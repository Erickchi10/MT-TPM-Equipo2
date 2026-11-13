import 'dart:io';

import 'package:flutter/material.dart';

import '../models/orden.dart';
import '../models/tecnico.dart';
import '../services/api_service.dart';
import '../services/camara_service.dart';
import '../services/notificacion_service.dart';
import '../services/ordenes_service.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  static const List<String> _prioridades = ['Baja', 'Media', 'Alta'];

  final _formKey = GlobalKey<FormState>();
  final _equipoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  final _api = ApiService();
  final _camara = CamaraService();
  final _almacen = OrdenesService();
  final _notificaciones = NotificacionService();

  String? _prioridad;
  Tecnico? _tecnico;
  String? _fotoPath;
  String? _mensaje;
  bool _guardando = false;

  bool _cargandoTecnicos = true;
  EstadoApi _estadoApi = EstadoApi.ok;
  List<Tecnico> _tecnicos = [];

  @override
  void initState() {
    super.initState();
    _cargarTecnicos();
  }

  @override
  void dispose() {
    _equipoCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarTecnicos() async {
    setState(() => _cargandoTecnicos = true);
    final r = await _api.obtenerTecnicos();
    if (!mounted) return;
    setState(() {
      _estadoApi = r.estado;
      _tecnicos = r.tecnicos;
      _cargandoTecnicos = false;
    });
  }

  String get _mensajeApi {
    switch (_estadoApi) {
      case EstadoApi.sinConexion:
        return 'Sin conexión: no se pudo cargar la lista de técnicos.';
      case EstadoApi.errorServidor:
        return 'El servidor respondió con un error.';
      case EstadoApi.error:
        return 'No se pudo cargar la lista de técnicos.';
      case EstadoApi.ok:
        return '';
    }
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

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    String? fotoGuardada;
    if (_fotoPath != null) {
      fotoGuardada = await _almacen.copiarFoto(_fotoPath!);
    }

    final nueva = Orden(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      equipo: _equipoCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim(),
      prioridad: _prioridad!,
      tecnico: _tecnico!.nombre,
      fecha: DateTime.now(),
      fotoPath: fotoGuardada,
    );

    final lista = await _almacen.cargar();
    lista.insert(0, nueva);
    await _almacen.guardar(lista);

    await _notificaciones.mostrar(
      titulo: 'Orden asignada',
      cuerpo: '${nueva.equipo} → ${nueva.tecnico}',
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Widget _selectorTecnico() {
    if (_cargandoTecnicos) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Cargando técnicos...'),
          ],
        ),
      );
    }
    if (_estadoApi != EstadoApi.ok) {
      return Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_mensajeApi),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _cargarTecnicos,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    return DropdownButtonFormField<Tecnico>(
      initialValue: _tecnico,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Técnico asignado',
        border: OutlineInputBorder(),
      ),
      items: _tecnicos
          .map((t) => DropdownMenuItem(value: t, child: Text(t.nombre)))
          .toList(),
      onChanged: (v) => setState(() => _tecnico = v),
      validator: (v) => v == null ? 'Elige un técnico' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva orden')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _equipoCtrl,
              decoration: const InputDecoration(
                labelText: 'Equipo o lugar',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Escribe el equipo o lugar';
                if (t.length < 3) return 'Mínimo 3 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descripcionCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción del problema',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Describe el problema';
                if (t.length < 10) return 'Mínimo 10 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _prioridad,
              decoration: const InputDecoration(
                labelText: 'Prioridad',
                border: OutlineInputBorder(),
              ),
              items: _prioridades
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _prioridad = v),
              validator: (v) => v == null ? 'Elige una prioridad' : null,
            ),
            const SizedBox(height: 12),
            _selectorTecnico(),
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
              label: Text(_guardando ? 'Guardando...' : 'Guardar orden'),
            ),
          ],
        ),
      ),
    );
  }
}
