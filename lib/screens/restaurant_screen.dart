import 'package:flutter/material.dart';
import '../main.dart';
import '../services/favorite_service.dart';
import '../services/reservation_service.dart';

class RestaurantScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  const RestaurantScreen({super.key, required this.restaurant});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  bool _isFavorite = false;

  String get _name => widget.restaurant['name'] ?? 'Restaurante';
  String get _address =>
      widget.restaurant['address'] ?? 'Dirección no disponible';
  String get _cuisine =>
      widget.restaurant['cuisine'] ??
      widget.restaurant['category'] ??
      'Variado';
  String get _rating => widget.restaurant['rating']?.toString() ?? '-';
  String get _priceRange => widget.restaurant['priceRange'] ?? '-';
  String get _openingHours =>
      widget.restaurant['openingHours'] ?? 'Horario no disponible';
  String get _phone => widget.restaurant['phone'] ?? 'No disponible';
  bool get _isRegistered => widget.restaurant['isRegistered'] == true;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final fav = await FavoriteService.isFavorite(_name);
    setState(() => _isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoriteService.removeFavorite(_name);
    } else {
      await FavoriteService.addFavorite(widget.restaurant);
    }
    setState(() => _isFavorite = !_isFavorite);
  }

  void _showReservationSheet() {
    final restaurantId = widget.restaurant['id'] as String?;
    if (restaurantId == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) =>
          ReservationSheet(restaurantId: restaurantId, restaurantName: _name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildInfo(),
            _buildStatsRow(),
            _buildStatusCard(),
            if (_isRegistered) _buildReserveButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: Image.network(
            widget.restaurant['imageUrl'] ??
                'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=300&fit=crop',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 220,
              color: Colors.grey[200],
              child: const Icon(Icons.restaurant, size: 60, color: Colors.grey),
            ),
          ),
        ),
        Container(
          height: 220,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Color(0x99000000)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          top: 48,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          top: 48,
          right: 16,
          child: GestureDetector(
            onTap: _toggleFavorite,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _isFavorite
                    ? primaryColor
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              if (_cuisine.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _cuisine,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Icon(Icons.star, size: 16, color: secondaryColor),
          const SizedBox(width: 4),
          Text(
            _rating,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _priceRange,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: darkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _infoRow(
            Icons.location_on_outlined,
            primaryColor,
            'Dirección',
            _address,
          ),
          const SizedBox(height: 12),
          _infoRow(
            Icons.access_time_outlined,
            Colors.green,
            'Horario',
            _openingHours,
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.phone_outlined, Colors.blue, 'Teléfono', _phone),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, Color color, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: darkColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isRegistered
            ? Colors.green.withOpacity(0.08)
            : primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isRegistered
              ? Colors.green.withOpacity(0.15)
              : primaryColor.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Text(
            _isRegistered ? '🟢' : '🔵',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isRegistered
                      ? 'Registrado en FOODIK'
                      : 'Restaurante del barrio',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: darkColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isRegistered
                      ? 'Puedes hacer reservas y ver el menú completo.'
                      : 'Este restaurante aún no está registrado en FOODIK.',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReserveButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _showReservationSheet,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Reservar una mesa',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class ReservationSheet extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  const ReservationSheet({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<ReservationSheet> createState() => _ReservationSheetState();
}

class _ReservationSheetState extends State<ReservationSheet> {
  int _partySize = 2;
  DateTime _date = DateTime.now();
  List<dynamic> _slots = [];
  bool _loading = false;
  String? _selectedSlotId;
  bool _booking = false;

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    setState(() => _loading = true);
    final dateStr =
        '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';
    final response = await ReservationService.getAvailability(
      widget.restaurantId,
      dateStr,
      _partySize,
    );
    setState(() {
      _slots = response['data'] as List? ?? [];
      _loading = false;
      _selectedSlotId = null;
    });
  }

  Future<void> _reserve() async {
    if (_selectedSlotId == null) return;
    setState(() => _booking = true);
    final response = await ReservationService.createReservation(
      widget.restaurantId,
      _selectedSlotId!,
      _partySize,
      '',
    );
    setState(() => _booking = false);
    if (response['success'] == true) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Reserva creada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Error al reservar'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reservar en ${widget.restaurantName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Personas',
                  style: TextStyle(fontSize: 14, color: darkColor),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_partySize > 1) {
                          setState(() => _partySize--);
                          _loadSlots();
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$_partySize',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => _partySize++);
                        _loadSlots();
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fecha',
                  style: TextStyle(fontSize: 14, color: darkColor),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      setState(() => _date = picked);
                      _loadSlots();
                    }
                  },
                  child: Text(
                    '${_date.day}/${_date.month}/${_date.year}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Horarios disponibles',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: darkColor,
              ),
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Center(
                child: CircularProgressIndicator(color: primaryColor),
              )
            else if (_slots.isEmpty)
              const Text(
                'No hay disponibilidad para esta fecha',
                style: TextStyle(color: Colors.grey),
              )
            else
              Wrap(
                spacing: 8,
                children: _slots.map((s) {
                  final id = s['id'] as String;
                  final time = s['timeSlot'] as String;
                  final count = s['availableCount'] as int;
                  final selected = _selectedSlotId == id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSlotId = id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: selected ? primaryColor : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${time.substring(0, 5)} ($count mesas)',
                        style: TextStyle(
                          color: selected ? Colors.white : darkColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedSlotId == null || _booking
                    ? null
                    : _reserve,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _booking
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Confirmar reserva',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
