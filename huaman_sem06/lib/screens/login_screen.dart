import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController();
  String rol = "Cliente";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TopograLoan - Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userCtrl,
              decoration: const InputDecoration(
                labelText: "Nombre de usuario",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              value: rol,
              items: const [
                DropdownMenuItem(value: "Cliente", child: Text("Cliente")),
                DropdownMenuItem(value: "Técnico", child: Text("Técnico")),
                DropdownMenuItem(value: "Responsable", child: Text("Responsable")),
                DropdownMenuItem(value: "Gestor", child: Text("Gestor")),
              ],
              onChanged: (val) => setState(() => rol = val!),
              decoration: const InputDecoration(
                labelText: "Rol",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                if (_userCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ingrese su nombre")));
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(usuario: _userCtrl.text, rol: rol),
                  ),
                );
              },
              child: const Text("Ingresar"),
            ),
          ],
        ),
      ),
    );
  }
}
