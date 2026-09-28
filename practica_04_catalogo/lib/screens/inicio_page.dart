import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../widgets/producto_card.dart';
import 'detalle_page.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

      static const productos = [
         Producto('Teclado', 550, 'Teclado para computadora'),
         Producto('Mouse', 320, 'Mouse óptico'),
         Producto('Audífonos', 780, 'Audífonos inalámbricos'),
      ];

      @override
      Widget build(BuildContext context) => Scaffold(
         appBar: AppBar(title: const Text('Catálogo')),
         body: ListView(
            padding: const EdgeInsets.all(12),
            children: productos.map((p) => ProductoCard(
              producto: p,
              onTap: () => Navigator.push(
                 context,
                 MaterialPageRoute(builder: (_) => DetallePage(producto: p)),
              ),
            )).toList(),
         ),
      );
}

 