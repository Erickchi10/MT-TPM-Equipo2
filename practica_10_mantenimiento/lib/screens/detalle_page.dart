import 'dart:io';

import 'package:flutter/material.dart';

import '../models/orden.dart';
import '../services/notificacion_service.dart';
import '../services/ordenes_service.dart';

class DetallePage extends StatefulWidget {
  const DetallePage({super.key, required this.orden});

  final Orden orden;

  @override
  State<DetallePage> createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {
  final _almacen = OrdenesService();
  final _notificaciones = NotificacionService();
  late Orden _orden = widget.orden;
  bool _guardando = false;

  Future<void> _cambiarEstado(EstadoOrden nuevo) async {
    setState(() => _guardando = true);
    final actualizada = _orden.copiarCon(estado: nuevo);

    final lista = await _almacen.cargar();
    final i = lista.indexWhere((o) => o.id == actualizada.id);
    if (i >= 0) {
      lista[i] = actualizada;
      await _almacen.guardar(lista);
    }

    if (nuevo == EstadoOrden.terminada) {
      await _notificaciones.mostrar(
        titulo: 'Orden terminada',
        cuerpo: actualizada.equipo,
      );
    }

    if (!mounted) return;
    setState(() {
      _orden = actualizada;
      _guardando = false;
    });
  }

  Future<void> _eliminar() async {
    await _almacen.borrarFoto(_orden.fotoPath);
    final lista = await _almacen.cargar();
    lista.removeWhere((o) => o.id == _orden.id);
    await _almacen.guardar(lista);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final foto = _orden.fotoPath;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la orden'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar',
            onPressed: _eliminar,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (foto != null && File(foto).existsSync())
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(foto), fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          Text(_orden.equipo, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('Prioridad ${_orden.prioridad}')),
              Chip(label: Text(_orden.estado.texto)),
            ],
          ),
          const SizedBox(height: 8),
          Text(_orden.descripcion),
          const Divider(height: 32),
          _Dato(icono: Icons.person, texto: _orden.tecnico),
          _Dato(icono: Icons.calendar_today, texto: _orden.fechaTexto),
          _Dato(icono: Icons.access_time, texto: _orden.horaTexto),
          const SizedBox(height: 16),
          if (_orden.estado == EstadoOrden.pendiente)
            FilledButton.icon(
              onPressed: _guardando
                  ? null
                  : () => _cambiarEstado(EstadoOrden.enProceso),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar trabajo'),
            ),
          if (_orden.estado == EstadoOrden.enProceso)
            FilledButton.icon(
              onPressed: _guardando
                  ? null
                  : () => _cambiarEstado(EstadoOrden.terminada),
              icon: const Icon(Icons.check),
              label: const Text('Marcar como terminada'),
            ),
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icono, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}
