import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart'; // <--- Import agregado
import 'screens/home_screen.dart';
import 'screens/reserva_screen.dart';
import 'screens/calibracion_screen.dart';

import 'services/equipo_service.dart';
import 'services/prestamo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TopograLoanApp());
}

class TopograLoanApp extends StatelessWidget {
  const TopograLoanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EquipoService>(create: (_) => EquipoService()),
        Provider<PrestamoService>(create: (_) => PrestamoService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TopograLoan',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 84, 94, 161),
          scaffoldBackgroundColor: const Color(0xFFF2F2F2),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 84, 96, 165),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 84, 94, 161),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/home': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
            return HomeScreen(
              usuario: args?['usuario'] ?? 'invitado',
              rol: args?['rol'] ?? 'Cliente',
            );
          },
          '/reserva': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
            return ReservaScreen(
              usuario: args?['usuario'] ?? 'invitado',
              equipoId: args?['equipoId'],
            );
          },
          '/calibracion': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
            return CalibracionScreen(
              equipoId: args?['equipoId'],
              usuario: args?['usuario'] ?? '',
            );
          },
        },
      ),
    );
  }
}
