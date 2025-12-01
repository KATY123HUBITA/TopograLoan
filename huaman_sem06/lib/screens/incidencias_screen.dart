import 'package:flutter/material.dart';

class IncidenciasScreen extends StatelessWidget {
  const IncidenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporal, luego conectar con Firebase
    List<Map<String, String>> incidencias = [
      {"titulo": "GPS sin señal", "orden": "#001"},
      {"titulo": "Estación Total dañada", "orden": "#002"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Incidencias y Órdenes")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Registrar Incidencia"),
              onPressed: () {
                // abrir formulario de nueva incidencia
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: incidencias.length,
                itemBuilder: (_, i) {
                  final inc = incidencias[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.error, color: Colors.red),
                      title: Text(inc["titulo"]!),
                      subtitle: Text("Orden: ${inc["orden"]}"),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
