import 'package:flutter/material.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../services/restaurant_service.dart';
import 'restaurant_screen.dart';
import 'search_screen.dart';
import 'reservations_screen.dart';
import 'profile_screen.dart';
import 'split_bill_screen.dart';

const filters = ['Todos', 'Cerca', 'Descuentos', 'Abiertos', 'Tendencia'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeFilter = 0;
  int activeNav = 0;
  List<dynamic> _restaurants = [];
  bool _loadingRestaurants = true;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    final response = await RestaurantService.getRestaurants();
    if (response['data'] != null) {
      setState(() {
        _restaurants = response['data']; // ← sin el ['content']
        _loadingRestaurants = false;
      });
    } else {
      setState(() => _loadingRestaurants = false);
    }
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
            _buildFilters(),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Stack(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
                'Buenas noches, $name 👋',
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

  Widget _buildFilters() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, i) {
          final active = activeFilter == i;
          return GestureDetector(
            onTap: () => setState(() => activeFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? primaryColor : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                filters[i],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : Colors.grey[500],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf0fdf4), Color(0xFFecfdf5), Color(0xFFf0fdfa)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Stack(
        children: [
          ...List.generate(
            5,
            (i) => Positioned(
              top: (i + 1) * 25.0,
              left: 0,
              right: 0,
              child: Container(height: 1, color: Colors.grey.withOpacity(0.15)),
            ),
          ),
          ...List.generate(
            4,
            (i) => Positioned(
              left: (i + 1) * 60.0,
              top: 0,
              bottom: 0,
              child: Container(width: 1, color: Colors.grey.withOpacity(0.15)),
            ),
          ),
          _pin(0.30, 0.25),
          _pin(0.45, 0.60),
          _pin(0.55, 0.35),
          _pin(0.25, 0.72),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Ver mapa completo →',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pin(double top, double left) {
    return Positioned(
      top: 160 * top - 16,
      left: (MediaQuery.of(context).size.width - 40) * left - 16,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: primaryColor.withOpacity(0.4), blurRadius: 8),
              ],
            ),
            child: const Icon(Icons.navigation, size: 14, color: Colors.white),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ],
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
                          r['category'] ?? '',
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
      (Icons.search_rounded, 'Buscar'),
      (Icons.calendar_today_outlined, 'Reservas'),
      (Icons.receipt_outlined, 'Cuenta'),
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
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            );
          if (i == 2)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReservationsScreen()),
            );
          if (i == 3)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SplitBillScreen(
                  restaurantName: 'Andrés Carne de Res',
                ),
              ),
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
