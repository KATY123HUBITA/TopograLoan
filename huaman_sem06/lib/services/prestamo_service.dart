import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prestamo.dart';

class PrestamoService {
  final CollectionReference prestamosRef =
      FirebaseFirestore.instance.collection('prestamos');

  /// Crear una nueva reserva
  Future<String> crearPrestamo(Prestamo prestamo) async {
    try {
      final docRef = await prestamosRef.add(prestamo.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception("Error creando reserva: $e");
    }
  }

  /// Marcar equipo como devuelto (check-in)
  Future<void> devolverEquipo(String idPrestamo) async {
    try {
      await prestamosRef.doc(idPrestamo).update({
        'estadoPrestamo': 'Devuelto',
        'fechaDevolucion': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception("Error devolviendo equipo: $e");
    }
  }

  /// Obtener préstamos por proyecto
  Stream<List<Prestamo>> getPrestamosPorProyecto(String proyecto) {
    return prestamosRef
        .where('proyecto', isEqualTo: proyecto)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Prestamo.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  /// Reportar incidencia asociada a un préstamo
  Future<void> agregarIncidencia(String idPrestamo, Map<String, dynamic> incidencia) async {
    try {
      await prestamosRef.doc(idPrestamo).update({
        'incidencias': FieldValue.arrayUnion([incidencia])
      });
    } catch (e) {
      throw Exception("Error agregando incidencia: $e");
    }
  }

  /// Obtener todos los préstamos
  Stream<List<Prestamo>> getAllPrestamos() {
    return prestamosRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Prestamo.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
