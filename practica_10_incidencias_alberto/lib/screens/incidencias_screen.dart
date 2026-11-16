import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/incidencias_provider.dart';
import '../widgets/incidencia_tile.dart';
import 'avisos_screen.dart';
import 'detalle_incidencia_screen.dart';
import 'form_incidencia_screen.dart';

class IncidenciasScreen extends StatelessWidget {
  const IncidenciasScreen({super.key});

  Future<void> _nuevo(BuildContext context) async {
    final mensaje = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const FormIncidenciaScreen()),
    );
    if (mensaje != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<IncidenciasProvider>();
    final lista = p.incidencias;

    Widget cuerpo;
    if (p.cargando) {
      cuerpo = const Center(child: CircularProgressIndicator());
    } else if (lista.isEmpty) {
      cuerpo = const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Aún no hay reportes.\nToca "Nuevo reporte" para crear el primero.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      cuerpo = ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
        itemCount: lista.length,
        itemBuilder: (_, k) => IncidenciaTile(
          incidencia: lista[k],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalleIncidenciaScreen(incidencia: lista[k]),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Incidencias (${lista.length})'),
        actions: [
          IconButton(
            tooltip: 'Avisos',
            icon: const Icon(Icons.campaign),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AvisosScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!p.notificacionesPermitidas)
            const Card(
              margin: EdgeInsets.all(12),
              child: ListTile(
                leading: Icon(Icons.notifications_off),
                title: Text('Notificaciones desactivadas'),
                subtitle: Text(
                  'Los reportes se guardan igual, pero no verás el aviso. '
                  'Actívalas en Ajustes.',
                ),
              ),
            ),
          Expanded(child: cuerpo),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _nuevo(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo reporte'),
      ),
    );
  }
}
