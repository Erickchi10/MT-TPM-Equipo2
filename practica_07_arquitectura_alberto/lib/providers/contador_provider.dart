import 'package:flutter/foundation.dart';

import '../models/registro.dart';

class ContadorProvider extends ChangeNotifier {
  int _valor = 0;
  final List<Registro> _historial = [];

  int get valor => _valor;
  List<Registro> get historial => List.unmodifiable(_historial);

  void incrementar() {
    _valor++;
    _registrar(TipoAccion.incremento);
  }

  void decrementar() {
    if (_valor == 0) return; // No permite valores negativos.
    _valor--;
    _registrar(TipoAccion.decremento);
  }

  void reiniciar() {
    _valor = 0;
    _historial.clear();
    _registrar(TipoAccion.reinicio);
  }

  void _registrar(TipoAccion tipo) {
    _historial.insert(
      0,
      Registro(tipo: tipo, valorResultante: _valor, fecha: DateTime.now()),
    );
    notifyListeners();
  }
}
