import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/publicaciones_provider.dart';

class BotonFiltroFavoritos extends StatelessWidget {
  const BotonFiltroFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    final (solo, total) = context.select<PublicacionesProvider, (bool, int)>(
      (p) => (p.soloFavoritos, p.totalFavoritos),
    );
    return IconButton(
      tooltip: solo ? 'Mostrar todas' : 'Mostrar solo favoritos',
      icon: Badge(
        isLabelVisible: total > 0,
        label: Text('$total'),
        child: Icon(solo ? Icons.favorite : Icons.favorite_border),
      ),
      onPressed: () =>
          context.read<PublicacionesProvider>().alternarSoloFavoritos(),
    );
  }
}
