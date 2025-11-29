import 'package:ecobee_wiring_diagram/screens/about_screen.dart';
import 'package:ecobee_wiring_diagram/screens/enhanced_screen.dart';
import 'package:ecobee_wiring_diagram/screens/feature_request_screen.dart';
import 'package:ecobee_wiring_diagram/screens/home_screen.dart';
import 'package:ecobee_wiring_diagram/screens/premium_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const WiringApp());

class WiringApp extends StatelessWidget {
  const WiringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wiring Schematic',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/about': (context) => const AboutScreen(),
        '/premium': (context) => const PremiumScreen(),
        '/enhanced': (context) => const EnhancedScreen(),
        '/feature_request': (context) => const FeatureRequestScreen(),
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
