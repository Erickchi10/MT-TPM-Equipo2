import 'package:sensors_plus/sensors_plus.dart';

/// Lectura de un sensor en los tres ejes.
typedef Lectura = ({double x, double y, double z});

class SensoresService {
  /// Acelerómetro en m/s² (incluye la gravedad).
  Stream<Lectura> acelerometro() =>
      accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
          .map((e) => (x: e.x, y: e.y, z: e.z));

  /// Giroscopio en rad/s (velocidad de giro).
  Stream<Lectura> giroscopio() =>
      gyroscopeEventStream(samplingPeriod: SensorInterval.uiInterval)
          .map((e) => (x: e.x, y: e.y, z: e.z));
}
