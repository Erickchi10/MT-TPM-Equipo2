
import 'package:flutter/material.dart';

import '../modelos/inspeccion.dart';
import '../servicios/api_service.dart';
import '../servicios/database_service.dart';
import 'formulario_page.dart';
import 'detalle_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  late Future<List<Map<String, Object?>>> inspecciones;

  final Set<int> _sincronizando = {};

  @override
  void initState() {
    super.initState();
    cargarInspecciones();
  }

  void cargarInspecciones() {
    inspecciones = DatabaseService.obtenerInspecciones();
  }

  void actualizarListado() {
    setState(() {
      cargarInspecciones();
    });
  }


Future<void> eliminarInspeccion(int id) async {
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar inspección'),
      content: const Text(
        '¿Deseas eliminar esta inspección?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );

  if (confirmar != true) return;

  await DatabaseService.eliminarInspeccion(id);

  if (!mounted) return;

  actualizarListado();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Inspección eliminada correctamente'),
    ),
  );
}


  Future<void> abrirFormulario() async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const FormularioPage(),
      ),
    );

    if (resultado == true && mounted) {
      actualizarListado();
    }
  }

  void abrirDetalle(Map<String, Object?> registro) {
    final inspeccion = Inspeccion.fromMap(registro);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetallePage(
          inspeccion: inspeccion,
        ),
      ),
    );
  }

  Future<void> sincronizar(
    Map<String, Object?> registro,
  ) async {
    final id = registro['id'] as int?;

    if (id == null || registro['sincronizado'] == 1) {
      return;
    }

    setState(() {
      _sincronizando.add(id);
    });

    try {
      final inspeccion = Inspeccion.fromMap(registro);

      final respuesta = await ApiService.enviarReporte(
        inspeccion,
      );

      await DatabaseService.marcarComoSincronizada(id);

      if (!mounted) return;

      actualizarListado();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reporte enviado correctamente. ID API: ${respuesta['id']}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de sincronización: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sincronizando.remove(id);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de Inspecciones'),
        centerTitle: true,
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: actualizarListado,
            tooltip: 'Actualizar listado',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, Object?>>>(
        future: inspecciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar registros: ${snapshot.error}',
              ),
            );
          }

          final registros = snapshot.data ?? [];

          if (registros.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 75,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'No hay inspecciones registradas',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Presiona el botón para crear una.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final registro = registros[index];

              final id = registro['id'] as int?;
              final sincronizado =
                  registro['sincronizado'] == 1;

              final estaSincronizando =
                  id != null && _sincronizando.contains(id);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.assignment),
                  ),
                  title: Text(
                    registro['titulo'] as String,
                  ),
                  subtitle: Text(
                    '${registro['categoria']} · '
                    '${registro['fecha']}\n'
                    '${sincronizado ? 'Enviado a API (demo)' : 'Pendiente de sincronización'}',
                  ),
                  isThreeLine: true,
                 
trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    if (sincronizado)
      const Icon(
        Icons.cloud_done,
        color: Colors.green,
      )
    else if (estaSincronizando)
      const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      )
    else
      IconButton(
        icon: const Icon(Icons.cloud_upload_outlined),
        tooltip: 'Sincronizar reporte',
        onPressed: id == null
            ? null
            : () => sincronizar(registro),
      ),
    IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      tooltip: 'Eliminar inspección',
      onPressed: id == null
          ? null
          : () => eliminarInspeccion(id),
    ),
  ],
),

                  onTap: () => abrirDetalle(registro),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Nueva inspección'),
      ),
    );
  }
}
