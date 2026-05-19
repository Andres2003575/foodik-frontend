import 'package:flutter/material.dart';
import '../main.dart';
import '../services/user_service.dart';
import '../services/admin_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<dynamic> _reservations = [];
  bool _loading = true;
  String _restaurantName = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final restaurants = await AdminService.getMyRestaurants();
    if (restaurants.isNotEmpty) {
      setState(
        () => _restaurantName = restaurants.map((r) => r['name']).join(' · '),
      );
      List<dynamic> allReservations = [];
      for (final r in restaurants) {
        final reservations = await AdminService.getRestaurantReservations(
          r['id'],
        );
        allReservations.addAll(reservations);
      }
      setState(() {
        _reservations = allReservations;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _updateStatus(String reservationId, String status) async {
    await AdminService.updateReservationStatus(reservationId, status);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Panel Admin',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await UserService.logout();
                  Navigator.pushReplacementNamed(context, '/auth');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _restaurantName,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final pending = _reservations
        .where((r) => r['status'] == 'PENDING')
        .toList();
    final confirmed = _reservations
        .where((r) => r['status'] == 'CONFIRMED')
        .toList();
    final others = _reservations
        .where((r) => r['status'] != 'PENDING' && r['status'] != 'CONFIRMED')
        .toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (pending.isNotEmpty) ...[
          _sectionTitle('⏰ Pendientes (${pending.length})'),
          ...pending.map((r) => _buildCard(r)),
        ],
        if (confirmed.isNotEmpty) ...[
          _sectionTitle('✅ Confirmadas (${confirmed.length})'),
          ...confirmed.map((r) => _buildCard(r)),
        ],
        if (others.isNotEmpty) ...[
          _sectionTitle('📋 Historial'),
          ...others.map((r) => _buildCard(r)),
        ],
        if (_reservations.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                'No hay reservas',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: darkColor,
        ),
      ),
    );
  }

  Widget _buildCard(dynamic r) {
    final status = r['status'] as String;
    final isPending = status == 'PENDING';
    final isConfirmed = status == 'CONFIRMED';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
        border: Border.all(
          color: isPending
              ? Colors.orange.withOpacity(0.3)
              : isConfirmed
              ? Colors.green.withOpacity(0.3)
              : Colors.grey[100]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r['userName'] ?? 'Usuario',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: darkColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPending
                      ? Colors.orange.withOpacity(0.1)
                      : isConfirmed
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPending
                        ? Colors.orange
                        : isConfirmed
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            r['restaurantName'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                '${r['reservationDate']} · ${r['reservationTime']}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.people_outline, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${r['partySize']} personas',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          if (isPending || isConfirmed) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (isPending)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateStatus(r['id'], 'CONFIRMED'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                if (isPending) const SizedBox(width: 8),
                if (isConfirmed)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateStatus(r['id'], 'COMPLETED'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Completar',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _updateStatus(r['id'], 'CANCELLED'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
