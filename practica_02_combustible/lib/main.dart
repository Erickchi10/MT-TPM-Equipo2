import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const CombustiblePage(),
  );
}

class CombustiblePage extends StatefulWidget {
  const CombustiblePage({super.key});
  @override
  State<CombustiblePage> createState() => _CombustiblePageState();
}

class _CombustiblePageState extends State<CombustiblePage> {
  final km = TextEditingController();
  final litros = TextEditingController();

  double rendimiento = 0;
  String nivel = '';
  String error = '';
  bool tieneResultado = false;

  void calcular() {
    final valorKm = double.tryParse(km.text);
    final valorLitros = double.tryParse(litros.text);

    if (valorKm == null ||
        valorLitros == null ||
        valorKm <= 0 ||
        valorLitros <= 0) {
      setState(() {
        error = 'Escribe valores numéricos mayores a 0 en ambos campos.';
        tieneResultado = false;
      });
      return;
    }

    final resultado = valorKm / valorLitros;
    String clasificacion;
    if (resultado < 10) {
      clasificacion = 'Bajo rendimiento';
    } else if (resultado <= 18) {
      clasificacion = 'Rendimiento medio';
    } else {
      clasificacion = 'Alto rendimiento';
    }

    setState(() {
      rendimiento = resultado;
      nivel = clasificacion;
      error = '';
      tieneResultado = true;
    });
  }

  void limpiar() {
    km.clear();
    litros.clear();
    setState(() {
      rendimiento = 0;
      nivel = '';
      error = '';
      tieneResultado = false;
    });
  }

  @override
  void dispose() {
    km.dispose();
    litros.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consumo de combustible')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: km,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kilómetros recorridos',
                prefixIcon: Icon(Icons.route),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: litros,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Litros utilizados',
                prefixIcon: Icon(Icons.local_gas_station),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: calcular,
                  child: const Text('Calcular'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: limpiar,
                  child: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            if (tieneResultado) ...[
              Text(
                'Rendimiento: ${rendimiento.toStringAsFixed(2)} km/L',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(nivel, style: const TextStyle(fontSize: 18)),
            ],
          ],
        ),
      ),
    );
  }
}
