class Formato {
  static String _dos(int n) => n.toString().padLeft(2, '0');

  static String fecha(DateTime f) =>
      '${_dos(f.day)}/${_dos(f.month)}/${f.year}';

  static String hora(DateTime f) =>
      '${_dos(f.hour)}:${_dos(f.minute)}:${_dos(f.second)}';

  static String valor(double v) => v.toStringAsFixed(2);
}
