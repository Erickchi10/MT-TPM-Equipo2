import 'package:sensors_plus/sensors_plus.dart';

class LecturaSensor {
  const LecturaSensor(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;
}

class SensoresService {
  Stream<LecturaSensor> acelerometro() {
    return accelerometerEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).map((e) => LecturaSensor(e.x, e.y, e.z));
  }

  Stream<LecturaSensor> giroscopio() {
    return gyroscopeEventStream(samplingPeriod: SensorInterval.normalInterval)
        .map((e) => LecturaSensor(e.x, e.y, e.z));
  }
}
