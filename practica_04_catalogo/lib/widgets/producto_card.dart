import 'package:flutter/material.dart';
import '../models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;
  const ProductoCard({super.key, required this.producto, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
     child: ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: Text(producto.nombre),
        subtitle: Text('\$${producto.precio.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
     ),
  );
}

