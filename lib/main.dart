import 'package:ecobee_wire_genie/screens/doorbell_screen.dart';
import 'package:ecobee_wire_genie/screens/enhanced_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:ecobee_wire_genie/screens/about_screen.dart';
import 'package:ecobee_wire_genie/screens/feature_request_screen.dart';
import 'package:ecobee_wire_genie/screens/home_screen.dart';
import 'package:ecobee_wire_genie/screens/premium_screen.dart';
import 'package:ecobee_wire_genie/screens/ecobee3_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBsLFYQiqETT9eqWTzvOF_xCp0OlHI_LMs",
        authDomain: "ecobee-wiring-diagrams.firebaseapp.com",
        databaseURL: "https://ecobee-wiring-diagrams-default-rtdb.firebaseio.com",
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
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WireGenie',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/about': (context) => const AboutScreen(),
        '/premium': (context) => const PremiumScreen(),
        '/ecobee3': (context) => const Ecobee3Screen(),
        '/enhanced': (context) => const EnhancedScreen(),
        '/doorbell': (context) => const DoorbellScreen(),
        '/feature_request': (context) => const FeatureRequestPage(),
      },
    );
  }
}
