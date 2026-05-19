import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/admin_screen.dart';

void main() {
  runApp(const FoodikApp());
}

const primaryColor = Color(0xFFFF6B35);
const secondaryColor = Color(0xFFFFD166);
const darkColor = Color(0xFF1A1A2E);

final restaurants = [];

class FoodikApp extends StatelessWidget {
  const FoodikApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/auth': (_) => const AuthScreen(),
        '/home': (_) => const HomeScreen(),
        '/admin': (_) => const AdminScreen(),
      },
    );
  }
}
