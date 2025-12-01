import 'package:cloud_firestore/cloud_firestore.dart';

class Prestamo {
  final String id;
  final String equipoId;
  final String proyecto;
  final DateTime fechaSalida;
  final DateTime? fechaRetorno;
  final String justificanteUrl;
  final String usuario;
  final String estadoPrestamo;
  final Map<String, dynamic>? checklistSalida;
  final Map<String, dynamic>? checklistRetorno;

  Prestamo({
    required this.id,
    required this.equipoId,
    required this.proyecto,
    required this.fechaSalida,
    this.fechaRetorno,
    required this.justificanteUrl,
    required this.usuario,
    required this.estadoPrestamo,
    this.checklistSalida,
    this.checklistRetorno,
  });

  Map<String, dynamic> toMap() {
    return {
      "equipoId": equipoId,
      "proyecto": proyecto,
      "fechaSalida": Timestamp.fromDate(fechaSalida),
      "fechaRetorno":
          fechaRetorno != null ? Timestamp.fromDate(fechaRetorno!) : null,
      "justificanteUrl": justificanteUrl,
      "usuario": usuario,
      "estadoPrestamo": estadoPrestamo,
      "checklistSalida": checklistSalida,
      "checklistRetorno": checklistRetorno,
    };
  }

  factory Prestamo.fromMap(String id, Map<String, dynamic> map) {
    return Prestamo(
      id: id,
      equipoId: map["equipoId"] ?? "",
      proyecto: map["proyecto"] ?? "",
      fechaSalida: (map["fechaSalida"] as Timestamp).toDate(),
      fechaRetorno: map["fechaRetorno"] != null
          ? (map["fechaRetorno"] as Timestamp).toDate()
          : null,
      justificanteUrl: map["justificanteUrl"] ?? "",
      usuario: map["usuario"] ?? "",
      estadoPrestamo: map["estadoPrestamo"] ?? "reservado",
      checklistSalida: map["checklistSalida"],
      checklistRetorno: map["checklistRetorno"],
    );
  }
}
