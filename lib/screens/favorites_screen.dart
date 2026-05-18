import 'package:flutter/material.dart';
import '../main.dart';
import 'restaurant_screen.dart';

const favoriteRestaurants = [
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
  {
    'name': 'Wok',
    'cuisine': 'Asiática',
    'rating': 4.5,
    'distance': '1.5 km',
    'discount': null,
    'img': 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=400&h=300&fit=crop',
    'tag2': 'Sushi',
    'reviews': '2,100',
    'status': 'Abierto',
    'price': '\$\$\$',
  },
  {
    'name': 'Harry Sasson',
    'cuisine': 'Autor',
    'rating': 4.9,
    'distance': '3.2 km',
    'discount': null,
    'img': 'https://images.unsplash.com/photo-1424847651672-bf20a4b0982b?w=400&h=300&fit=crop',
    'tag2': 'Gourmet',
    'reviews': '876',
    'status': 'Abierto',
    'price': '\$\$\$\$',
  },
  {
    'name': 'Andrés D.C.',
    'cuisine': 'Colombiana',
    'rating': 4.7,
    'distance': '2.8 km',
    'discount': '10% off',
    'img': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=300&fit=crop',
    'tag2': 'Parrilla',
    'reviews': '4,521',
    'status': 'Abierto',
    'price': '\$\$\$',
  },
];

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Set<int> _favorites = {0, 1, 2, 3, 4, 5};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(18)),
                  child: const Icon(Icons.arrow_back, size: 20, color: darkColor),
                ),
              ),
              const SizedBox(width: 12),
              const Text('Tus favoritos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkColor)),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Text('${_favorites.length} restaurantes guardados',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: favoriteRestaurants.length,
      itemBuilder: (context, i) {
        final r = favoriteRestaurants[i];
        final isFav = _favorites.contains(i);
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: r))),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(r['img'] as String, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xCC000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Heart button
                  Positioned(
                    top: 10, right: 10,
                    child: GestureDetector(
                      onTap: () => setState(() => isFav ? _favorites.remove(i) : _favorites.add(i)),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: isFav ? primaryColor : Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  // Discount badge
                  if (r['discount'] != null)
                    Positioned(
                      top: 10, left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(8)),
                        child: Text(r['discount'] as String,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: darkColor)),
                      ),
                    ),
                  // Info
                  Positioned(
                    bottom: 12, left: 12, right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 2),
                        Text(r['cuisine'] as String,
                            style: const TextStyle(fontSize: 10, color: Colors.white70)),
                        const SizedBox(height: 6),
                        Row(children: [
                          const Icon(Icons.star, size: 12, color: secondaryColor),
                          const SizedBox(width: 3),
                          Text('${r['rating']}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}