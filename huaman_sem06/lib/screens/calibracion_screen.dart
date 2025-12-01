import 'package:flutter/material.dart';
import '../models/calibracion.dart';
import '../services/equipo_service.dart';
import 'package:provider/provider.dart';

class CalibracionScreen extends StatefulWidget {
  final String? equipoId;
  final String usuario;

  const CalibracionScreen({super.key, this.equipoId, required this.usuario});

  @override
  State<CalibracionScreen> createState() => _CalibracionScreenState();
}

class _CalibracionScreenState extends State<CalibracionScreen> {
  final TextEditingController descCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _guardar() async {
    if (descCtrl.text.isEmpty || widget.equipoId == null) return;
    setState(() => _loading = true);
    final calib = Calibracion(
      id: '',
      equipoId: widget.equipoId!,
      fecha: DateTime.now(),
      descripcion: descCtrl.text,
      tecnico: widget.usuario,
    );

    try {
      final service = Provider.of<EquipoService>(context, listen: false);
      await service.registrarCalibracion(widget.equipoId!, calib);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calibración registrada')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (!mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Calibración")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: "Descripción de la calibración",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _guardar,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Guardar Calibración"),
            ),
          ],
        ),
      ),
    );
  }
}
