import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/publicaciones_provider.dart';
import '../widgets/barra_busqueda.dart';
import '../widgets/boton_filtro_favoritos.dart';
import '../widgets/estado_error.dart';
import '../widgets/publicacion_tile.dart';
import 'detalle_publicacion.dart';

class ListaPublicaciones extends StatelessWidget {
  const ListaPublicaciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones'),
        actions: const [BotonFiltroFavoritos()],
      ),
      body: const Column(
        children: [
          BarraBusqueda(),
          Expanded(child: _Contenido()),
        ],
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido();

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PublicacionesProvider>();
    return switch (prov.estado) {
      EstadoCarga.cargando => const Center(child: CircularProgressIndicator()),
      EstadoCarga.error => EstadoError(
        mensaje: prov.error ?? 'Error desconocido',
        alReintentar: prov.cargar,
      ),
      EstadoCarga.listo => _lista(context, prov),
    };
  }

  Widget _lista(BuildContext context, PublicacionesProvider prov) {
    final lista = prov.visibles;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('${lista.length} de ${prov.total} publicaciones'),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: prov.cargar,
            child: lista.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('No hay publicaciones que coincidan')),
                    ],
                  )
                : ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, i) {
                      final p = lista[i];
                      return PublicacionTile(
                        publicacion: p,
                        favorito: prov.esFavorito(p.id),
                        alTocar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetallePublicacion(publicacion: p),
                          ),
                        ),
                        alMarcarFavorito: () => prov.alternarFavorito(p.id),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
