import 'package:flutter/material.dart';
import '../main.dart';
import '../services/bill_service.dart';
import '../services/menu_service.dart';
import '../services/user_service.dart';
import '../services/api_service.dart';
import '../services/reservation_service.dart';

class SplitBillScreen extends StatefulWidget {
  final String restaurantName;
  final String? reservationId;
  final String? restaurantId;
  const SplitBillScreen({
    super.key,
    required this.restaurantName,
    this.reservationId,
    this.restaurantId,
  });

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  int _selectedMode = 0;
  List<dynamic> _menuItems = [];
  List<Map<String, dynamic>> _selectedItems = [];
  List<Map<String, dynamic>> _participants = [];
  bool _loading = true;
  bool _creating = false;
  Map<String, dynamic>? _summary;
  final _emailController = TextEditingController();
  bool _searchingUser = false;
  String? _searchError;

  final modes = ['EQUAL', 'INDIVIDUAL', 'CHAINED'];
  final modeLabels = [
    {'icon': '⚖️', 'label': 'Partes\niguales'},
    {'icon': '🧾', 'label': 'Cada uno\nlo suyo'},
    {'icon': '🔗', 'label': 'Cadena'},
  ];

  @override
  void initState() {
    super.initState();
    _loadMenuAndUser();
    if (widget.reservationId != null) _checkExistingBill();
  }

  Future<void> _checkExistingBill() async {
    final bill = await BillService.getBillByReservation(widget.reservationId!);
    if (bill != null) {
      setState(
        () => _summary = {
          'totalAmount': bill['totalAmount'],
          'amountPerUser': {},
          'existingBill': true,
        },
      );
    }
  }

  Future<void> _loadMenuAndUser() async {
    // Cargar usuario actual como primer participante
    final me = await UserService.getMe();
    if (me != null) {
      setState(
        () => _participants.add({
          'id': me['id'],
          'name': me['name'],
          'email': me['email'],
        }),
      );
    }
    // Cargar menú
    if (widget.restaurantId != null) {
      final items = await MenuService.getMenu(widget.restaurantId!);
      setState(() => _menuItems = items);
    }
    setState(() => _loading = false);
  }

  Future<void> _searchUser() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    setState(() {
      _searchingUser = true;
      _searchError = null;
    });
    final user = await UserService.searchByEmail(email);
    if (user != null) {
      final exists = _participants.any((p) => p['id'] == user['id']);
      if (!exists) {
        setState(
          () => _participants.add({
            'id': user['id'],
            'name': user['name'],
            'email': user['email'],
          }),
        );
        _emailController.clear();
      } else {
        setState(() => _searchError = 'Este usuario ya está en la lista');
      }
    } else {
      setState(() => _searchError = 'Usuario no encontrado');
    }
    setState(() => _searchingUser = false);
  }

  void _addItem(Map<String, dynamic> item) {
    setState(() {
      final existing = _selectedItems.indexWhere(
        (i) => i['menuItemId'] == item['id'],
      );
      if (existing >= 0) {
        _selectedItems[existing]['quantity']++;
      } else {
        _selectedItems.add({
          'menuItemId': item['id'],
          'quantity': 1,
          'name': item['name'],
          'price': item['price'],
        });
      }
    });
  }

  void _removeItem(String menuItemId) {
    setState(() {
      final existing = _selectedItems.indexWhere(
        (i) => i['menuItemId'] == menuItemId,
      );
      if (existing >= 0) {
        if (_selectedItems[existing]['quantity'] > 1) {
          _selectedItems[existing]['quantity']--;
        } else {
          _selectedItems.removeAt(existing);
        }
      }
    });
  }

  double get _total => _selectedItems.fold(
    0,
    (sum, i) => sum + (i['price'] as num) * (i['quantity'] as int),
  );

  Future<void> _createBill() async {
    if (widget.reservationId == null || _selectedItems.isEmpty) return;
    setState(() => _creating = true);
    final items = _selectedItems
        .map((i) => {'menuItemId': i['menuItemId'], 'quantity': i['quantity']})
        .toList();
    final response = await BillService.createBill(
      widget.reservationId!,
      modes[_selectedMode],
      items,
    );
    if (response['success'] == true) {
      final billId = response['data']['id'] as String;
      final participantIds = _participants
          .map((p) => p['id'] as String)
          .toList();
      final splitResponse = await BillService.splitBill(
        billId,
        modes[_selectedMode],
        participantIds,
      );
      setState(() {
        _summary = splitResponse['data'];
        _creating = false;
      });
      print('SUMMARY: $_summary');
    } else {
      setState(() => _creating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Error al crear la cuenta'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: _summary != null ? _buildSummary() : _buildForm(),
            ),
          ),
        ],
      ),
      bottomSheet: _summary == null ? _buildBottomButton() : null,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const Text(
              'Dividir la cuenta',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.receipt_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.restaurantName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 20),

          // Modo de división
          const Text(
            'Modo de división',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(modeLabels.length, (i) {
              final selected = _selectedMode == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMode = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                      right: i < modeLabels.length - 1 ? 10 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: selected ? primaryColor : Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Text(
                          modeLabels[i]['icon']!,
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          modeLabels[i]['label']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Participantes
          const Text(
            'Participantes',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 12),
          ..._participants.map(
            (p) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        p['name'][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      p['name'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: darkColor,
                      ),
                    ),
                  ),
                  if (_participants.indexOf(p) > 0)
                    GestureDetector(
                      onTap: () => setState(() => _participants.remove(p)),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Agregar por email',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    errorText: _searchError,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _searchingUser ? null : _searchUser,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _searchingUser
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Platos
          const Text(
            'Platos',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 12),
          if (_loading)
            const Center(child: CircularProgressIndicator(color: primaryColor))
          else if (_menuItems.isEmpty)
            const Text(
              'Sin menú disponible',
              style: TextStyle(color: Colors.grey),
            )
          else
            ..._menuItems.map((item) {
              final selected = _selectedItems.firstWhere(
                (i) => i['menuItemId'] == item['id'],
                orElse: () => {},
              );
              final qty = selected.isNotEmpty ? selected['quantity'] as int : 0;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: qty > 0
                        ? primaryColor.withOpacity(0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          Text(
                            '\$${item['price']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (qty > 0) ...[
                          GestureDetector(
                            onTap: () => _removeItem(item['id']),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.remove, size: 16),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$qty',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        GestureDetector(
                          onTap: () => _addItem(item),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          if (_selectedItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: darkColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${_total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final isExisting = _summary?['existingBill'] == true;
    final amountPerUser = _summary?['amountPerUser'] as Map? ?? {};
    final total = _summary?['totalAmount'] ?? 0;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de la cuenta',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _summary?['existingBill'] == true
                ? 'Estado: Completada ✓'
                : 'Modo: ${modes[_selectedMode]}',
            style: TextStyle(
              fontSize: 13,
              color: _summary?['existingBill'] == true
                  ? Colors.green
                  : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$$total',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (isExisting)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Ya existe una cuenta para esta reserva. El resumen fue calculado anteriormente.',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ),
          const SizedBox(height: 12),
          ...amountPerUser.entries.map((entry) {
            final userId = entry.key as String;
            final amount = entry.value;
            final participant = _participants.firstWhere(
              (p) => p['id'] == userId,
              orElse: () => {'name': 'Usuario'},
            );
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (participant['name'] as String)[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        participant['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$$amount',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                '¡Cuenta saldada! 🎉',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _selectedItems.isEmpty || _creating ? null : _createBill,
          style: ElevatedButton.styleFrom(
            backgroundColor: darkColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _creating
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  _selectedItems.isEmpty
                      ? 'Selecciona platos para continuar'
                      : 'Crear cuenta · \$${_total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
