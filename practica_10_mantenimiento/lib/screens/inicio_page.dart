import 'package:flutter/material.dart';

import '../models/orden.dart';
import '../services/notificacion_service.dart';
import '../services/ordenes_service.dart';
import '../widgets/tarjeta_orden.dart';
import 'detalle_page.dart';
import 'formulario_page.dart';
import 'tecnicos_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final _almacen = OrdenesService();
  final _notificaciones = NotificacionService();

  List<Orden> _ordenes = [];
  bool _cargando = true;
  EstadoOrden? _filtro;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    await _notificaciones.inicializar();
    await _notificaciones.pedirPermiso();
    await _cargar();
  }

  Future<void> _cargar() async {
    final lista = await _almacen.cargar();
    if (!mounted) return;
    setState(() {
      _ordenes = lista;
      _cargando = false;
    });
  }

  Future<void> _nueva() async {
    await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const FormularioPage()));
    await _cargar();
  }

  Future<void> _abrirDetalle(Orden orden) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => DetallePage(orden: orden)));
    await _cargar();
  }

  List<Orden> get _visibles => _filtro == null
      ? _ordenes
      : _ordenes.where((o) => o.estado == _filtro).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Órdenes de Mantenimiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.engineering),
            tooltip: 'Técnicos',
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const TecnicosPage())),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _chipFiltro('Todas', null),
                for (final e in EstadoOrden.values) _chipFiltro(e.texto, e),
              ],
            ),
          ),
          Expanded(child: _cuerpo()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nueva,
        icon: const Icon(Icons.add),
        label: const Text('Nueva orden'),
      ),
    );
  }

  Widget _chipFiltro(String texto, EstadoOrden? valor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(texto),
        selected: _filtro == valor,
        onSelected: (_) => setState(() => _filtro = valor),
      ),
    );
  }

  Widget _cuerpo() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    final lista = _visibles;
    if (lista.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No hay órdenes para mostrar.\nToca "Nueva orden" para crear una.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: lista.length,
      itemBuilder: (context, i) =>
          TarjetaOrden(orden: lista[i], onTap: () => _abrirDetalle(lista[i])),
    );
  }
}
