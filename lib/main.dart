import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';

import 'package:ecobee_wire_genie/screens/about_screen.dart';
import 'package:ecobee_wire_genie/screens/feature_request_screen.dart';
import 'package:ecobee_wire_genie/screens/home_screen.dart';
import 'package:ecobee_wire_genie/screens/premium_screen.dart';
import 'package:ecobee_wire_genie/screens/ecobee3_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBsLFYQiqETT9eqWTzvOF_xCp0OlHI_LMs",
        authDomain: "ecobee-wiring-diagrams.firebaseapp.com",
        projectId: "ecobee-wiring-diagrams",
        storageBucket: "ecobee-wiring-diagrams.firebasestorage.app",
        messagingSenderId: "884968177567",
        appId: "1:884968177567:web:60ad66ebd35594ce8e47aa",
        measurementId: "G-G4YFR417CY"
    ),
  );

  runApp(const WiringApp());
}

class WiringApp extends StatelessWidget {
  const WiringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WireGenie',
      //theme: ThemeData(primarySwatch: Colors.blue),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.grey[900],
          // Define other dark theme properties
        ),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/about': (context) => const AboutScreen(),
        '/premium': (context) => const PremiumScreen(),
        '/ecobee3': (context) => const Ecobee3Screen(),
       // '/enhanced': (context) => const EnhancedScreen(),
        '/feature_request': (context) => const FeatureRequestPage(),
      },
    );
  }
}

class Wire {
  final String id;
  final List<Offset> points;
  Color color;

  Wire({required this.id, required this.points, required this.color});

  Wire copyWith({String? id, Color? color}) =>
      Wire(id: id ?? this.id, points: points, color: color ?? this.color);
}
