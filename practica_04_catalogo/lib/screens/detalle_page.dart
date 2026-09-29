import 'package:flutter/material.dart';
import '../models/producto.dart';

class DetallePage extends StatelessWidget {
  final Producto producto;
  const DetallePage({super.key, required this.producto});

  @override
  Widget build(BuildContext context) => Scaffold(
     appBar: AppBar(title: Text(producto.nombre)),
     body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.inventory_2, size: 100),
          Text(producto.nombre, style: Theme.of(context).textTheme.headlineMedium),
          Text('\$${producto.precio.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          Text(producto.descripcion),
        ]),
     ),
  );
}

