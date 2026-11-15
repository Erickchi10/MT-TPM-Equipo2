import 'package:intl/intl.dart';

class FormatoService {
  static final DateFormat _fechaHora = DateFormat('dd/MM/yyyy HH:mm:ss');
  static final NumberFormat _numero = NumberFormat.decimalPattern();

  static String fechaHora(DateTime fecha) => _fechaHora.format(fecha);

  static String numero(int valor) => _numero.format(valor);
}
