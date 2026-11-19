class Evidencia {
  final String imagePath;
  final DateTime fecha;
  final double acelerometroX;
  final double acelerometroY;
  final double acelerometroZ;
  final double giroscopioX;
  final double giroscopioY;
  final double giroscopioZ;

  const Evidencia({
    required this.imagePath,
    required this.fecha,
    required this.acelerometroX,
    required this.acelerometroY,
    required this.acelerometroZ,
    required this.giroscopioX,
    required this.giroscopioY,
    required this.giroscopioZ,
  });

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'fecha': fecha.toIso8601String(),
      'acelerometroX': acelerometroX,
      'acelerometroY': acelerometroY,
      'acelerometroZ': acelerometroZ,
      'giroscopioX': giroscopioX,
      'giroscopioY': giroscopioY,
      'giroscopioZ': giroscopioZ,
    };
  }

  factory Evidencia.fromMap(Map<String, dynamic> map) {
    return Evidencia(
      imagePath: map['imagePath'] as String,
      fecha: DateTime.parse(map['fecha'] as String),
      acelerometroX: (map['acelerometroX'] as num).toDouble(),
      acelerometroY: (map['acelerometroY'] as num).toDouble(),
      acelerometroZ: (map['acelerometroZ'] as num).toDouble(),
      giroscopioX: (map['giroscopioX'] as num).toDouble(),
      giroscopioY: (map['giroscopioY'] as num).toDouble(),
      giroscopioZ: (map['giroscopioZ'] as num).toDouble(),
    );
  }
}
