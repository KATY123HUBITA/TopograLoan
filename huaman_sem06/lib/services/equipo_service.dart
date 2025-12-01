import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/equipo.dart';
import '../models/calibracion.dart';

class EquipoService {
  final CollectionReference equiposRef =
      FirebaseFirestore.instance.collection('equipos');

  /// Stream de todos los equipos
  Stream<List<Equipo>> getEquiposStream() {
    return equiposRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Equipo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Agregar nuevo equipo
  Future<void> agregarEquipo(Equipo equipo) async {
    try {
      await equiposRef.add(equipo.toMap());
    } catch (e) {
      throw Exception("Error al agregar equipo: $e");
    }
  }

  /// Actualizar estado de equipo (Disponible / Prestado / Bloqueado)
  Future<void> actualizarEstado(String idEquipo, String nuevoEstado) async {
    try {
      await equiposRef.doc(idEquipo).update({'estado': nuevoEstado});
    } catch (e) {
      throw Exception("Error actualizando estado: $e");
    }
  }

  /// Cambiar disponibilidad (boolean) y opcionalmente guardar prestamoId
  Future<void> setDisponibilidad(String idEquipo, bool disponible, {String? prestamoId}) async {
    try {
      final Map<String, dynamic> data = {'disponible': disponible};
      if (prestamoId != null) data['currentPrestamoId'] = prestamoId;
      await equiposRef.doc(idEquipo).update(data);
    } catch (e) {
      throw Exception("Error al actualizar disponibilidad: $e");
    }
  }

  /// Registrar una calibración
  Future<void> registrarCalibracion(String idEquipo, Calibracion calibracion) async {
    try {
      await equiposRef.doc(idEquipo).update({
        'historialCalibraciones': FieldValue.arrayUnion([calibracion.toMap()])
      });
    } catch (e) {
      throw Exception("Error registrando calibración: $e");
    }
  }

  /// Bloquear equipo por fallo o mantenimiento
  Future<void> bloquearEquipo(String idEquipo, {String motivo = "Falla reportada"}) async {
    try {
      await equiposRef.doc(idEquipo).update({
        'estado': 'Bloqueado',
        'bloqueado': true,
        'motivoBloqueo': motivo,
      });
    } catch (e) {
      throw Exception("Error bloqueando equipo: $e");
    }
  }

  /// Desbloquear equipo (opcional)
  Future<void> desbloquearEquipo(String idEquipo) async {
    try {
      await equiposRef.doc(idEquipo).update({
        'estado': 'Disponible',
        'bloqueado': false,
        'motivoBloqueo': FieldValue.delete(),
      });
    } catch (e) {
      throw Exception("Error desbloqueando equipo: $e");
    }
  }
}
