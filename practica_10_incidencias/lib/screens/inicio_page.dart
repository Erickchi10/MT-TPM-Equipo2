import 'package:flutter/material.dart';

import '../models/incidencia.dart';
import '../services/incidencias_service.dart';
import '../services/notificacion_service.dart';
import '../widgets/tarjeta_incidencia.dart';
import 'avisos_page.dart';
import 'detalle_page.dart';
import 'formulario_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final _almacen = IncidenciasService();
  final _notificaciones = NotificacionService();

  List<Incidencia> _incidencias = [];
  bool _cargando = true;

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
      _incidencias = lista;
      _cargando = false;
    });
  }

  Future<void> _nuevo() async {
    final guardado = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const FormularioPage()));
    if (guardado == true) await _cargar();
  }

  Future<void> _eliminar(Incidencia incidencia) async {
    await _almacen.borrarFoto(incidencia.fotoPath);
    _incidencias.removeWhere((i) => i.id == incidencia.id);
    await _almacen.guardar(_incidencias);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte Móvil de Incidencias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign),
            tooltip: 'Avisos',
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const AvisosPage())),
          ),
        ],
      ),
      body: _cuerpo(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nuevo,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo reporte'),
      ),
    );
  }

  Widget _cuerpo() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_incidencias.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No hay reportes guardados.\nToca "Nuevo reporte" para crear el primero.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: _incidencias.length,
      itemBuilder: (context, i) {
        final inc = _incidencias[i];
        return TarjetaIncidencia(
          incidencia: inc,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DetallePage(incidencia: inc)),
          ),
          onEliminar: () => _eliminar(inc),
        );
      },
    );
  }
}
