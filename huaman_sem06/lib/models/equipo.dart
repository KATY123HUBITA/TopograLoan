import 'package:cloud_firestore/cloud_firestore.dart';

class Equipo {
  final String id;
  final String nombre;
  final bool disponible;
  final List<String> accesorios;
  final bool requiereCalibracion;
  final String condicionesUso;
  final bool bloqueado;
  final String estado; // nuevo
  final DateTime? proximaCalibracion;
  final DateTime? ultimoMantenimiento;

  Equipo({
    required this.id,
    required this.nombre,
    required this.disponible,
    required this.accesorios,
    required this.requiereCalibracion,
    required this.condicionesUso,
    required this.bloqueado,
    required this.estado,
    this.proximaCalibracion,
    this.ultimoMantenimiento,
  });

  Map<String, dynamic> toMap() {
    return {
      "nombre": nombre,
      "disponible": disponible,
      "accesorios": accesorios,
      "requiereCalibracion": requiereCalibracion,
      "condicionesUso": condicionesUso,
      "bloqueado": bloqueado,
      "estado": estado,
      "proximaCalibracion": proximaCalibracion != null
          ? Timestamp.fromDate(proximaCalibracion!)
          : null,
      "ultimoMantenimiento": ultimoMantenimiento != null
          ? Timestamp.fromDate(ultimoMantenimiento!)
          : null,
    };
  }

  factory Equipo.fromMap(Map<String, dynamic> map, String id) {
    return Equipo(
      id: id,
      nombre: map["nombre"] ?? "",
      disponible: map["disponible"] ?? true,
      accesorios: List<String>.from(map["accesorios"] ?? []),
      requiereCalibracion: map["requiereCalibracion"] ?? false,
      condicionesUso: map["condicionesUso"] ?? "",
      bloqueado: map["bloqueado"] ?? false,
      estado: map["estado"] ?? "disponible",
      proximaCalibracion: map["proximaCalibracion"] != null
          ? (map["proximaCalibracion"] as Timestamp).toDate()
          : null,
      ultimoMantenimiento: map["ultimoMantenimiento"] != null
          ? (map["ultimoMantenimiento"] as Timestamp).toDate()
          : null,
    );
  }
}
