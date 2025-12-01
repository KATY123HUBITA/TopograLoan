import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/prestamo.dart';
import '../services/prestamo_service.dart';
import '../services/equipo_service.dart';

class ReservaScreen extends StatefulWidget {
  final String usuario;
  final String? equipoId;

  const ReservaScreen({super.key, required this.usuario, this.equipoId});

  @override
  State<ReservaScreen> createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  final TextEditingController proyectoCtrl = TextEditingController();
  File? _justificante;
  bool _loading = false;

  Future<void> _pickJustificante() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _justificante = File(file.path));
  }

  Future<String?> _uploadJustificante(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('justificantes/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(file);
    final snap = await uploadTask.whenComplete(() {});
    return await snap.ref.getDownloadURL();
  }

  Future<void> _confirmReserva() async {
    if (proyectoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ingrese el nombre del proyecto")));
      return;
    }

    setState(() => _loading = true);

    String justificanteUrl = '';
    if (_justificante != null) {
      try {
        justificanteUrl = (await _uploadJustificante(_justificante!)) ?? '';
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error subiendo justificante: $e')));
        setState(() => _loading = false);
        return;
      }
    }

    final prestamo = Prestamo(
      id: '',
      equipoId: widget.equipoId ?? '',
      proyecto: proyectoCtrl.text,
      fechaSalida: DateTime.now(),
      justificanteUrl: justificanteUrl,
      usuario: widget.usuario,
      estadoPrestamo: 'Prestado',
    );

    try {
      final service = Provider.of<PrestamoService>(context, listen: false);
      final idNuevo = await service.crearPrestamo(prestamo);

      if ((widget.equipoId ?? '').isNotEmpty) {
        final eqService = Provider.of<EquipoService>(context, listen: false);
        await eqService.setDisponibilidad(widget.equipoId!, false, prestamoId: idNuevo);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Reserva creada')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error creando reserva: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reservar Equipo")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: proyectoCtrl,
              decoration: const InputDecoration(
                  labelText: "Proyecto", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text("Adjuntar Justificante"),
              onPressed: _pickJustificante,
            ),
            if (_justificante != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Archivo seleccionado', style: TextStyle(color: Colors.blue)),
              ),
            const SizedBox(height: 25),
            _loading
                ? const LinearProgressIndicator()
                : ElevatedButton(
                    onPressed: _confirmReserva,
                    child: const Text("Confirmar Reserva"),
                  ),
          ],
        ),
      ),
    );
  }
}
