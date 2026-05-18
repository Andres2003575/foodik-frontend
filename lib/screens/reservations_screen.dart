import 'package:flutter/material.dart';
import '../main.dart';
import 'split_bill_screen.dart';

const reservations = [
  {
    'restaurant': 'Andrés Carne de Res',
    'img': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=300&fit=crop',
    'date': 'Hoy, 13 May',
    'time': '8:00 PM',
    'personas': 4,
    'status': 'activa',
    'code': 'FDK-2891',
  },
  {
    'restaurant': 'Crepes & Waffles',
    'img': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=300&fit=crop',
    'date': 'Mañana, 14 May',
    'time': '1:00 PM',
    'personas': 2,
    'status': 'próxima',
    'code': 'FDK-3042',
  },
  {
    'restaurant': 'La Pinta',
    'img': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=300&fit=crop',
    'date': '10 May',
    'time': '7:30 PM',
    'personas': 5,
    'status': 'completada',
    'code': 'FDK-2654',
  },
];

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = reservations.where((r) => r['status'] != 'completada').toList();
    final past = reservations.where((r) => r['status'] == 'completada').toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildList(active, context),
                  _buildList(past, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mis reservas', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: darkColor)),
          SizedBox(height: 2),
          Text('Gestiona tus próximas visitas', style: TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(14)),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[500],
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: 'Próximas'), Tab(text: 'Historial')],
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list, BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📅', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 16),
            const Text('Sin reservas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkColor)),
            const SizedBox(height: 8),
            Text('Tus reservas aparecerán aquí', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: list.length,
      itemBuilder: (context, i) => _buildCard(list[i], context),
    );
  }

  Widget _buildCard(Map<String, dynamic> r, BuildContext context) {
    final isActive = r['status'] == 'activa';
    final isUpcoming = r['status'] == 'próxima';
    final isPast = r['status'] == 'completada';

    Color statusColor = isActive ? Colors.green : isUpcoming ? primaryColor : Colors.grey;
    String statusLabel = isActive ? '● Activa ahora' : isUpcoming ? '⏰ Próximamente' : '✓ Completada';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 15, offset: const Offset(0, 4))],
        border: Border.all(color: isActive ? Colors.green.withValues(alpha: 0.2) : Colors.grey[100]!),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(r['img'] as String, height: 120, width: double.infinity, fit: BoxFit.cover),
                Container(height: 120, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Color(0xAA000000)], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
                    child: Text(statusLabel, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                    child: Text(r['code'] as String, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  bottom: 12, left: 12,
                  child: Text(r['restaurant'] as String,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _infoChip(Icons.calendar_today_outlined, r['date'] as String),
                    const SizedBox(width: 10),
                    _infoChip(Icons.access_time_outlined, r['time'] as String),
                    const SizedBox(width: 10),
                    _infoChip(Icons.people_outline, '${r['personas']} personas'),
                  ],
                ),
                if (!isPast) ...[
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text('Cancelar', style: TextStyle(fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => SplitBillScreen(restaurantName: r['restaurant'] as String),
                        )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                        ),
                        child: const Text('Dividir cuenta', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Icon(icon, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500)),
      ]),
    );
  }
}