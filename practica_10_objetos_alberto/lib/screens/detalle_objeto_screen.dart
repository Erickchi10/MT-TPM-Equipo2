import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/objeto.dart';
import '../providers/objetos_provider.dart';
import '../services/formato.dart';
import '../widgets/dialogo_entrega.dart';
import '../widgets/estado_chip.dart';
import '../widgets/objeto_card.dart';

class DetalleObjetoScreen extends StatelessWidget {
  const DetalleObjetoScreen({super.key, required this.id});

  final String id;

  Future<void> _cambiar(
    BuildContext context,
    Objeto o,
    EstadoObjeto nuevo,
  ) async {
    String? entregadoA;
    if (nuevo == EstadoObjeto.entregado) {
      entregadoA = await showDialog<String>(
        context: context,
        builder: (_) => const DialogoEntrega(),
      );
      if (entregadoA == null) return;
    }
    if (!context.mounted) return;
    final mensaje = await context.read<ObjetosProvider>().cambiarEstado(
      o.id,
      nuevo,
      entregadoA: entregadoA,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _eliminar(BuildContext context, Objeto o) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar objeto'),
        content: Text('¿Eliminar "${o.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true || !context.mounted) return;
    final p = context.read<ObjetosProvider>();
    Navigator.pop(context);
    await p.eliminar(o.id);
  }

  @override
  Widget build(BuildContext context) {
    final o = context.watch<ObjetosProvider>().buscar(id);
    if (o == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('El objeto ya no existe')),
      );
    }
    final tema = Theme.of(context);
    final foto = o.fotoRuta;
    final entrega = o.fechaEntrega;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del objeto'),
        actions: [
          IconButton(
            tooltip: 'Eliminar',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _eliminar(context, o),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (foto != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.file(
                  File(foto),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Text('Foto no disponible')),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(o.nombre, style: tema.textTheme.headlineSmall),
              ),
              EstadoChip(estado: o.estado),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              Chip(
                avatar: Icon(iconoCategoria(o.categoria), size: 18),
                label: Text(o.categoria),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(o.descripcion, style: tema.textTheme.bodyLarge),
          const Divider(height: 32),
          _Dato(
            icono: Icons.place,
            titulo: 'Dónde se encontró',
            valor: o.lugar,
          ),
          _Dato(
            icono: Icons.my_location,
            titulo: 'Coordenadas',
            valor: o.tieneUbicacion
                ? '${o.latitud!.toStringAsFixed(6)}, '
                      '${o.longitud!.toStringAsFixed(6)}'
                : 'Sin ubicación',
          ),
          _Dato(
            icono: Icons.event,
            titulo: 'Fecha de registro',
            valor: '${Formato.fecha(o.fecha)} ${Formato.hora(o.fecha)}',
          ),
          _Dato(
            icono: Icons.person,
            titulo: 'Lo resguarda',
            valor: o.resguardante,
          ),
          if (o.estado == EstadoObjeto.entregado)
            _Dato(
              icono: Icons.handshake,
              titulo: 'Entregado a',
              valor:
                  '${o.entregadoA ?? '-'}'
                  '${entrega == null ? '' : ' · ${Formato.fecha(entrega)} ${Formato.hora(entrega)}'}',
            ),
          const SizedBox(height: 16),
          if (o.estado.siguiente case final siguiente?)
            FilledButton.icon(
              onPressed: () => _cambiar(context, o, siguiente),
              icon: Icon(iconoEstado(siguiente)),
              label: Text(
                siguiente == EstadoObjeto.reclamado
                    ? 'Marcar como reclamado'
                    : 'Entregar al dueño',
              ),
            ),
          if (o.estado == EstadoObjeto.encontrado) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _cambiar(context, o, EstadoObjeto.entregado),
              icon: const Icon(Icons.check_circle),
              label: const Text('Entregar directamente'),
            ),
          ],
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.icono, required this.titulo, required this.valor});

  final IconData icono;
  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icono),
      title: Text(titulo),
      subtitle: Text(valor),
    );
  }
}
