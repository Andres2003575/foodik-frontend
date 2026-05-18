import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'split_bill_screen.dart';
import '../main.dart';

const dishes = [
  {'name': 'Bandeja Paisa', 'price': '\$38,000', 'img': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&h=200&fit=crop'},
  {'name': 'Ajiaco Bogotano', 'price': '\$28,000', 'img': 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=300&h=200&fit=crop'},
  {'name': 'Patacón Relleno', 'price': '\$22,000', 'img': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300&h=200&fit=crop'},
];

class RestaurantScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  const RestaurantScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHeader(context),
          _buildInfo(),
          _buildStatsRow(),
          _buildReserveButton(context),
          _buildMenu(),
          _buildDiscountBanner(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SplitBillScreen(
                    restaurantName: restaurant['name'] as String,
                  )),
                ),
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
                label: const Text('Dividir la cuenta'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1A1A2E),
                  side: const BorderSide(color: Color(0xFF1A1A2E)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(children: [
      SizedBox(
        height: 220, width: double.infinity,
        child: Image.network(restaurant['img'] as String, fit: BoxFit.cover),
      ),
      Container(
        height: 220,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Color(0x99000000)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
      ),
      Positioned(
        top: 48, left: 16,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
      ),
      Positioned(
        top: 48, right: 16,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(18)),
          child: const Icon(Icons.share_outlined, color: Colors.white, size: 18),
        ),
      ),
      Positioned(
        bottom: 16, left: 20, right: 20,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(restaurant['name'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          Row(children: [
            _tag(restaurant['cuisine'] as String),
            const SizedBox(width: 8),
            _tag(restaurant['tag2'] as String),
          ]),
        ]),
      ),
    ]);
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(children: [
        const Icon(Icons.star, size: 16, color: secondaryColor),
        const SizedBox(width: 4),
        Text('${restaurant['rating']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: darkColor)),
        const SizedBox(width: 4),
        Text('(${restaurant['reviews']} reseñas)', style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ]),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _stat(Icons.location_on_outlined, primaryColor, const Color(0x1AFF6B35), 'Distancia', restaurant['distance'] as String),
        Container(width: 1, height: 32, color: Colors.grey[200]),
        _stat(Icons.access_time_outlined, Colors.green, const Color(0x1A4CAF50), 'Horario', restaurant['status'] as String),
        Container(width: 1, height: 32, color: Colors.grey[200]),
        _stat(Icons.attach_money_outlined, secondaryColor, const Color(0x1AFFD166), 'Precio', restaurant['price'] as String),
      ]),
    );
  }

  Widget _stat(IconData icon, Color iconColor, Color bgColor, String label, String value) {
    return Row(children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 16, color: iconColor),
      ),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: darkColor)),
      ]),
    ]);
  }

  Widget _buildReserveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookingScreen(restaurant: restaurant)),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            shadowColor: primaryColor.withValues(alpha: 0.4),
          ),
          child: const Text('Reservar una mesa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Text('Menú del día', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: darkColor)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dishes.length,
            itemBuilder: (context, i) {
              final d = dishes[i];
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                  border: Border.all(color: Colors.grey[50]!),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(d['img'] as String, height: 80, width: 120, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(d['name'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: darkColor)),
                      const SizedBox(height: 2),
                      Text(d['price'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: primaryColor)),
                    ]),
                  ),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildDiscountBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: secondaryColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: secondaryColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
          child: const Center(child: Text('🏷️', style: TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 12),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('15% de descuento', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: darkColor)),
          SizedBox(height: 2),
          Text('Válido antes de las 7:00 PM hoy', style: TextStyle(fontSize: 11, color: Colors.grey)),
        ]),
      ]),
    );
  }
}