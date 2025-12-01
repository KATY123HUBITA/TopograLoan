import 'package:flutter/material.dart';
import '../models/equipo.dart';
import 'detalle_equipo_screen.dart';

class EquiposScreen extends StatelessWidget {
  final String usuario;

  const EquiposScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    // Lista temporal para prueba
    List<Equipo> equipos = [
      Equipo(
        id: "1",
        nombre: "Estación Total Sokkia",
        disponible: true,
        accesorios: ["Trípode", "Prisma", "Baterías"],
        requiereCalibracion: false,
        condicionesUso: "Usar con cuidado, evitar golpes.",
        bloqueado: false,
        estado: "Disponible",
      ),
      Equipo(
        id: "2",
        nombre: "GPS Trimble",
        disponible: false,
        accesorios: ["Antena", "Base", "Cable"],
        requiereCalibracion: true,
        condicionesUso: "Mantener apagado cuando no se usa.",
        bloqueado: true,
        estado: "Bloqueado",
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Equipos Disponibles")),
      body: ListView.builder(
        itemCount: equipos.length,
        itemBuilder: (_, i) {
          final eq = equipos[i];
          Color statusColor = eq.bloqueado
              ? Colors.red
              : eq.requiereCalibracion
                  ? Colors.orange
                  : Colors.green;

          return Card(
            child: ListTile(
              title: Text(eq.nombre),
              subtitle: Text(eq.estado, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
              trailing: eq.bloqueado ? const Icon(Icons.lock, color: Colors.red) : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetalleEquipoScreen(equipo: eq, usuario: usuario)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
