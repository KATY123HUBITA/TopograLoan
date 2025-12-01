import 'package:cloud_firestore/cloud_firestore.dart';

class Calibracion {
  final String id;
  final String equipoId;
  final DateTime fecha;
  final String descripcion;
  final String tecnico;
  final DateTime? proximaCalibracion;

  Calibracion({
    required this.id,
    required this.equipoId,
    required this.fecha,
    required this.descripcion,
    required this.tecnico,
    this.proximaCalibracion,
  });

  Map<String, dynamic> toMap() {
    return {
      "equipoId": equipoId,
      "fecha": Timestamp.fromDate(fecha),
      "descripcion": descripcion,
      "tecnico": tecnico,
      "proximaCalibracion": proximaCalibracion != null
          ? Timestamp.fromDate(proximaCalibracion!)
          : null,
    };
  }

  factory Calibracion.fromMap(Map<String, dynamic> map, String id) {
    return Calibracion(
      id: id,
      equipoId: map["equipoId"] ?? "",
      fecha: (map["fecha"] as Timestamp).toDate(),
      descripcion: map["descripcion"] ?? "",
      tecnico: map["tecnico"] ?? "",
      proximaCalibracion: map["proximaCalibracion"] != null
          ? (map["proximaCalibracion"] as Timestamp).toDate()
          : null,
    );
  }
}
