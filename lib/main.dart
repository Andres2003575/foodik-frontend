import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const FoodikApp());
}

const primaryColor = Color(0xFFFF6B35);
const secondaryColor = Color(0xFFFFD166);
const darkColor = Color(0xFF1A1A2E);

final restaurants = [
  {
    'name': 'Andrés Carne de Res',
    'cuisine': 'Colombiana',
    'rating': 4.8,
    'distance': '1.2 km',
    'discount': '20% off',
    'img': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=300&fit=crop',
    'tag2': 'Parrilla',
    'reviews': '2,345',
    'status': 'Abierto',
    'price': '\$\$\$',
  },
  {
    'name': 'Crepes & Waffles',
    'cuisine': 'Internacional',
    'rating': 4.6,
    'distance': '0.8 km',
    'discount': null,
    'img': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=300&fit=crop',
    'tag2': 'Café',
    'reviews': '1,892',
    'status': 'Abierto',
    'price': '\$\$',
  },
  {
    'name': 'La Pinta',
    'cuisine': 'Mariscos',
    'rating': 4.9,
    'distance': '2.1 km',
    'discount': '15% off',
    'img': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=300&fit=crop',
    'tag2': 'Pescados',
    'reviews': '987',
    'status': 'Abierto',
    'price': '\$\$\$\$',
  },
  {
    'name': 'El Corral',
    'cuisine': 'Hamburguesas',
    'rating': 4.3,
    'distance': '0.5 km',
    'discount': null,
    'img': 'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=400&h=300&fit=crop',
    'tag2': 'Rápido',
    'reviews': '3,210',
    'status': 'Cerrado',
    'price': '\$\$',
  },
];

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
      },
    );
  }
}