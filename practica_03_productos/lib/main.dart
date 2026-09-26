import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const ProductosPage(),
  );
}

class Producto {
  final String nombre;
  final String categoria;
  final double precio;
  final int existencia;
  Producto({
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.existencia,
  });
}

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});
  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final formKey = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final precio = TextEditingController();
  final existencia = TextEditingController();
  String categoria = 'Electrónica';

  final categorias = ['Electrónica', 'Ropa', 'Alimentos', 'Hogar', 'Otros'];
  final List<Producto> productos = [];

  double get valorTotal => productos.fold(
    0,
    (suma, p) => suma + (p.precio * p.existencia),
  );

  void guardar() {
    if (formKey.currentState!.validate()) {
      setState(() {
        productos.add(Producto(
          nombre: nombre.text.trim(),
          categoria: categoria,
          precio: double.parse(precio.text),
          existencia: int.parse(existencia.text),
        ));
        nombre.clear();
        precio.clear();
        existencia.clear();
        categoria = 'Electrónica';
      });
    }
  }

  void eliminar(int index) {
    setState(() => productos.removeAt(index));
  }

  @override
  void dispose() {
    nombre.dispose();
    precio.dispose();
    existencia.dispose();
    super.dispose();
  }
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de productos')),
      body: LayoutBuilder(builder: (context, c) {
        final ancho = c.maxWidth > 700 ? 600.0 : c.maxWidth;
        return Center(
          child: SizedBox(
            width: ancho,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Form(
                  key: formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: nombre,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Escribe el nombre del producto'
                          : null,
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: categoria,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      items: categorias
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => categoria = v!,
                    ),
                    TextFormField(
                      controller: precio,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Precio'),
                      validator: (v) {
                        final val = double.tryParse(v ?? '');
                        if (val == null || val <= 0) {
                          return 'Escribe un precio válido mayor a 0';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: existencia,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Existencia'),
                      validator: (v) {
                        final val = int.tryParse(v ?? '');
                        if (val == null || val < 0) {
                          return 'Escribe una existencia válida (0 o más)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: guardar, child: const Text('Agregar producto')),
                  ]),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (_, i) {
                      final p = productos[i];
                      return ListTile(
                        leading: const Icon(Icons.inventory_2),
                        title: Text('${p.nombre} (${p.categoria})'),
                        subtitle: Text(
                          'Precio: \$${p.precio.toStringAsFixed(2)}  |  Existencia: ${p.existencia}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => eliminar(i),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Valor total del inventario: \$${valorTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
          ),
        );
      }),
    );
  }
}