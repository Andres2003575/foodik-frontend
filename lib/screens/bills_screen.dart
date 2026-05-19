import 'package:flutter/material.dart';
import 'dart:convert';
import '../main.dart';
import '../services/bill_service.dart';
import '../services/user_service.dart';
import 'split_bill_screen.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _pending = [];
  List<dynamic> _paid = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBills();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBills() async {
    final bills = await BillService.getMyBills();
    setState(() {
      _pending = bills.where((b) => b['status'] == 'PENDING').toList();
      _paid = bills.where((b) => b['status'] != 'PENDING').toList();
      _loading = false;
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
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [_buildList(_pending), _buildList(_paid)],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: darkColor),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Mis cuentas',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Historial de cuentas divididas',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(14),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[500],
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Pendientes'),
          Tab(text: 'Pagadas'),
        ],
      ),
    );
  }

  Widget _buildList(List<dynamic> bills) {
    if (bills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🧾', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 16),
            const Text(
              'Sin cuentas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tus cuentas aparecerán aquí',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: bills.length,
      itemBuilder: (context, i) => _buildCard(bills[i]),
    );
  }

  Widget _buildCard(dynamic bill) {
    final status = bill['status'] as String;
    final isPending = status == 'PENDING';
    final total = bill['totalAmount'] ?? 0;
    final splitMode = bill['splitMode'] ?? '';
    final splitResult = bill['splitResult'];
    final reservationId = bill['reservationId'] as String?;

    Map<String, dynamic> amountPerUser = {};
    if (splitResult != null) {
      amountPerUser = jsonDecode(splitResult);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isPending ? primaryColor.withOpacity(0.2) : Colors.grey[100]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPending
                      ? primaryColor.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPending ? '⏰ Pendiente' : '✓ Pagada',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPending ? primaryColor : Colors.green,
                  ),
                ),
              ),
              Text(
                '\$$total',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Modo: $splitMode',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (amountPerUser.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'División:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: darkColor,
              ),
            ),
            const SizedBox(height: 6),
            ...amountPerUser.entries.map(
              (entry) => FutureBuilder<Map<String, dynamic>?>(
                future: UserService.getUserById(entry.key),
                builder: (context, snapshot) {
                  final name = snapshot.data?['name'] ?? 'Usuario';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: darkColor,
                          ),
                        ),
                        Text(
                          '\$${entry.value}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          if (isPending && reservationId != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SplitBillScreen(
                      restaurantName: 'Restaurante',
                      reservationId: reservationId,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Ver detalle',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
