import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/objeto.dart';
import '../providers/objetos_provider.dart';
import '../services/camara_service.dart';
import '../services/ubicacion_service.dart';

class FormObjetoScreen extends StatefulWidget {
  const FormObjetoScreen({super.key});

  @override
  State<FormObjetoScreen> createState() => _FormObjetoScreenState();
}

class _FormObjetoScreenState extends State<FormObjetoScreen> {
  final _form = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _descripcion = TextEditingController();
  final _lugar = TextEditingController();
  String? _categoria;
  int? _resguardanteId;
  String? _foto;
  double? _lat;
  double? _lng;
  String? _avisoUbicacion;
  bool _ubicando = false;
  bool _guardando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _descripcion.dispose();
    _lugar.dispose();
    super.dispose();
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _tomarFoto() async {
    final r = await context.read<ObjetosProvider>().tomarFoto();
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
    final r = await context.read<ObjetosProvider>().obtenerUbicacion();
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
    final p = context.read<ObjetosProvider>();
    final id = _resguardanteId;
    final resguardante = id == null ? null : p.resguardantePorId(id);
    if (resguardante == null) {
      _avisar('Elige quién resguarda el objeto');
      return;
    }
    setState(() => _guardando = true);
    final mensaje = await p.registrar(
      nombre: _nombre.text,
      descripcion: _descripcion.text,
      categoria: _categoria!,
      lugar: _lugar.text,
      resguardante: resguardante,
      fotoTemporal: _foto,
      latitud: _lat,
      longitud: _lng,
    );
    if (!mounted) return;
    Navigator.pop(context, mensaje);
  }

  Widget _seccionResguardante(ObjetosProvider p) {
    final lista = p.resguardantes;
    if (lista.isEmpty) {
      if (p.estadoResguardantes == EstadoResguardantes.cargando) {
        return const Column(
          children: [
            LinearProgressIndicator(),
            SizedBox(height: 4),
            Text('Cargando personal desde la API...'),
          ],
        );
      }
      return Card(
        child: ListTile(
          leading: const Icon(Icons.wifi_off),
          title: const Text('No hay lista de personal'),
          subtitle: const Text('Conéctate a internet y toca Reintentar.'),
          trailing: TextButton(
            onPressed: p.cargarResguardantes,
            child: const Text('Reintentar'),
          ),
        ),
      );
    }
    final aviso = switch (p.estadoResguardantes) {
      EstadoResguardantes.sinConexion =>
        'Sin conexión: se muestra la última lista guardada.',
      EstadoResguardantes.error => 'No se pudo actualizar la lista.',
      _ => null,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          initialValue: _resguardanteId,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Quién lo resguarda',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final r in lista)
              DropdownMenuItem(value: r.id, child: Text(r.nombre)),
          ],
          onChanged: (id) => setState(() => _resguardanteId = id),
          validator: (id) =>
              id == null ? 'Elige quién resguarda el objeto' : null,
        ),
        if (aviso != null)
          Row(
            children: [
              Expanded(child: Text(aviso)),
              TextButton(
                onPressed: p.cargarResguardantes,
                child: const Text('Reintentar'),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ObjetosProvider>();
    final foto = _foto;
    final lat = _lat;
    final lng = _lng;
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar objeto')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombre,
              maxLength: 40,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Objeto',
                hintText: 'Ej. Cartera negra',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Escribe el nombre del objeto';
                if (t.length < 3) return 'Mínimo 3 caracteres';
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
                hintText: 'Color, marca, qué tiene adentro...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v?.trim().length ?? 0) < 10
                  ? 'Describe el objeto (mínimo 10 caracteres)'
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
            TextFormField(
              controller: _lugar,
              maxLength: 60,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Dónde se encontró',
                hintText: 'Ej. Biblioteca, mesa 3',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v?.trim().isEmpty ?? true)
                  ? 'Escribe dónde se encontró'
                  : null,
            ),
            const SizedBox(height: 8),
            _seccionResguardante(p),
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
                foto == null ? 'Tomar foto del objeto' : 'Tomar otra foto',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _ubicando ? null : _ubicar,
              icon: const Icon(Icons.my_location),
              label: Text(
                _ubicando ? 'Obteniendo ubicación...' : 'Guardar ubicación GPS',
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
              label: Text(_guardando ? 'Guardando...' : 'Guardar objeto'),
            ),
          ],
        ),
      ),
    );
  }
}
