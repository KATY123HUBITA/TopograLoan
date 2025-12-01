import 'package:flutter/material.dart';
import 'equipos_screen.dart';
import 'calibracion_screen.dart';
import 'incidencias_screen.dart';
import 'reserva_screen.dart';

class HomeScreen extends StatelessWidget {
  final String usuario;
  final String rol;

  const HomeScreen({super.key, required this.usuario, required this.rol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TopograLoan - $rol")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        childAspectRatio: 1.2,
        children: _getMenuItems(context),
      ),
    );
  }

  List<Widget> _getMenuItems(BuildContext context) {
    List<Widget> items = [];

    // Todos pueden ver equipos
    items.add(_menuBtn(context, "Equipos", Icons.construction, EquiposScreen(usuario: usuario)));

    // Cliente y Gestor: reservas
    if (rol == "Cliente" || rol == "Gestor") {
      items.add(_menuBtn(
          context,
          "Reservas",
          Icons.assignment,
          ReservaScreen(usuario: usuario)
      ));
    }

    // Técnicos: calibraciones
    if (rol == "Técnico" || rol == "Gestor") {
      items.add(_menuBtn(
          context,
          "Calibraciones",
          Icons.build_circle,
          CalibracionScreen(equipoId: null, usuario: usuario)
      ));
    }

    // Responsable y Gestor: incidencias
    if (rol != "Cliente") {
      items.add(_menuBtn(context, "Incidencias", Icons.report_problem, const IncidenciasScreen()));
    }

    return items;
  }

  Widget _menuBtn(BuildContext ctx, String txt, IconData icon, Widget screen) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(txt, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
