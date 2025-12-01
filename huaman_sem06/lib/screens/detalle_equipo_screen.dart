import 'package:flutter/material.dart';
import '../models/equipo.dart';
import 'reserva_screen.dart';
import 'calibracion_screen.dart';

class DetalleEquipoScreen extends StatelessWidget {
  final Equipo equipo;
  final String usuario;

  const DetalleEquipoScreen({super.key, required this.equipo, required this.usuario});

  @override
  Widget build(BuildContext context) {
    Color statusColor = equipo.bloqueado
        ? Colors.red
        : equipo.requiereCalibracion
            ? Colors.orange
            : Colors.green;

    return Scaffold(
      appBar: AppBar(title: Text(equipo.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text("Estado: ${equipo.estado}", style: TextStyle(color: statusColor, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text("Accesorios:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...equipo.accesorios.map((a) => ListTile(leading: const Icon(Icons.check), title: Text(a))),
            const SizedBox(height: 15),
            Text("Condiciones de Uso:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(equipo.condicionesUso),
            const SizedBox(height: 20),
            if (!equipo.bloqueado)
              ElevatedButton.icon(
                icon: const Icon(Icons.assignment),
                label: const Text("Reservar"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReservaScreen(usuario: usuario, equipoId: equipo.id)),
                  );
                },
              ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.build_circle),
              label: const Text("Reportar Calibración"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CalibracionScreen(equipoId: equipo.id, usuario: usuario)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
