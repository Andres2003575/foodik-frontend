import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../services/restaurant_service.dart';
import '../config/secrets.dart';
import 'restaurant_screen.dart';
import 'reservations_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'bills_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeNav = 0;
  List<dynamic> _restaurants = [];
  bool _loadingRestaurants = true;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    final position = await RestaurantService.getCurrentPosition();
    final scraping = await RestaurantService.getRestaurants();
    final registered = await RestaurantService.getRegisteredRestaurants(
      lat: position.latitude,
      lng: position.longitude,
    );

    final scrapingList = (scraping['data'] as List? ?? [])
        .map(
          (r) => Map<String, dynamic>.from(r as Map)..['isRegistered'] = false,
        )
        .toList();

    final registeredList = ((registered['data']?['content']) as List? ?? [])
        .map(
          (r) => Map<String, dynamic>.from(r as Map)..['isRegistered'] = true,
        )
        .toList();

    setState(() {
      _restaurants = [...registeredList, ...scrapingList];
      _loadingRestaurants = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            _buildGreeting(),
            _buildMap(),
            _buildNearbyHeader(),
            _buildRestaurantCards(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'FOODIK',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: primaryColor,
              letterSpacing: -0.5,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on, size: 14, color: primaryColor),
                SizedBox(width: 4),
                Text(
                  'Bogotá, Colombia',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return FutureBuilder<String>(
      future: ApiService.getUserName(),
      builder: (context, snapshot) {
        final name = snapshot.data ?? 'Usuario';
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, $name 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkColor,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                '¿Qué quieres comer hoy?',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(4.711, -74.0721),
            zoom: 14,
          ),
          markers: _restaurants
              .where((r) => r['latitude'] != null && r['longitude'] != null)
              .map(
                (r) => Marker(
                  markerId: MarkerId(
                    r['osmId']?.toString() ?? r['id']?.toString() ?? r['name'],
                  ),
                  position: LatLng(
                    r['latitude'] as double,
                    r['longitude'] as double,
                  ),
                  infoWindow: InfoWindow(title: r['name']),
                ),
              )
              .toSet(),
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }

  Widget _buildNearbyHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Cerca de ti',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          const Text(
            'Ver todos',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCards() {
    if (_loadingRestaurants) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }
    if (_restaurants.isEmpty) {
      return const Expanded(
        child: Center(child: Text('No hay restaurantes cercanos')),
      );
    }
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20, bottom: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _restaurants.length,
        itemBuilder: (context, i) {
          final r = _restaurants[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RestaurantScreen(restaurant: r),
              ),
            ),
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey[50]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      r['imageUrl'] ??
                          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=300&fit=crop',
                      height: 90,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 90,
                        color: Colors.grey[200],
                        child: const Icon(Icons.restaurant, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['name'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: darkColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          r['category'] ?? r['cuisine'] ?? '',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(r['distanceKm'] as double?)?.toStringAsFixed(1) ?? '-'} km',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      (Icons.home_rounded, 'Inicio'),
      (Icons.favorite_outline, 'Favoritos'),
      (Icons.calendar_today_outlined, 'Reservas'),
      (Icons.receipt_outlined, 'Cuentas'),
      (Icons.person_outline_rounded, 'Perfil'),
    ];
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
      ),
      child: BottomNavigationBar(
        currentIndex: activeNav,
        onTap: (i) {
          if (i == 0) return;
          if (i == 1)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            );
          if (i == 2)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReservationsScreen()),
            );
          if (i == 3)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BillsScreen()),
            );
          if (i == 4)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          setState(() => activeNav = i);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 10,
        unselectedFontSize: 10,
        elevation: 0,
        items: items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.$1, size: 22),
                label: item.$2,
              ),
            )
            .toList(),
      ),
    );
  }
}
