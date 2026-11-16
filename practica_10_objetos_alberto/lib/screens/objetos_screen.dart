import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/objeto.dart';
import '../providers/objetos_provider.dart';
import '../widgets/objeto_card.dart';
import 'detalle_objeto_screen.dart';
import 'form_objeto_screen.dart';

class ObjetosScreen extends StatelessWidget {
  const ObjetosScreen({super.key});

  Future<void> _registrar(BuildContext context) async {
    final mensaje = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const FormObjetoScreen()),
    );
    if (mensaje != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ObjetosProvider>();
    final lista = p.objetos;

    Widget cuerpo;
    if (p.cargando) {
      cuerpo = const Center(child: CircularProgressIndicator());
    } else if (lista.isEmpty) {
      cuerpo = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            p.total == 0
                ? 'Aún no hay objetos registrados.\n'
                      'Toca "Registrar objeto" para agregar el primero.'
                : 'No hay objetos con el estado '
                      '"${p.filtro?.etiqueta ?? ''}".',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      cuerpo = ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 88),
        itemCount: lista.length,
        itemBuilder: (_, k) => ObjetoCard(
          objeto: lista[k],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalleObjetoScreen(id: lista[k].id),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Objetos perdidos (${p.total})')),
      body: Column(
        children: [
          if (!p.notificacionesPermitidas)
            const Card(
              margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: ListTile(
                leading: Icon(Icons.notifications_off),
                title: Text('Notificaciones desactivadas'),
                subtitle: Text(
                  'Los objetos se guardan igual, pero no verás los avisos.',
                ),
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                _Filtro(
                  texto: 'Todos (${p.total})',
                  activo: p.filtro == null,
                  onTap: () => p.filtrar(null),
                ),
                for (final e in EstadoObjeto.values)
                  _Filtro(
                    texto: '${e.etiqueta} (${p.contar(e)})',
                    activo: p.filtro == e,
                    onTap: () => p.filtrar(e),
                  ),
              ],
            ),
          ),
          Expanded(child: cuerpo),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _registrar(context),
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Registrar objeto'),
      ),
    );
  }
}

class _Filtro extends StatelessWidget {
  const _Filtro({
    required this.texto,
    required this.activo,
    required this.onTap,
  });

  final String texto;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(texto),
        selected: activo,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
