import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  const BookingScreen({super.key, required this.restaurant});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedDay = 1;
  int selectedHour = 4;
  int personas = 4;
  final _notasController = TextEditingController();

  final days = [
    {'day': 'Lun', 'num': '12'},
    {'day': 'Mar', 'num': '13'},
    {'day': 'Mié', 'num': '14'},
    {'day': 'Jue', 'num': '15'},
    {'day': 'Vie', 'num': '16'},
  ];

  final hours = [
    '12:00', '12:30', '1:00', '1:30',
    '2:00', '2:30', '7:00', '7:30',
    '8:00', '8:30', '9:00', '9:30',
  ];

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRestaurantInfo(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Selecciona la fecha'),
                    const SizedBox(height: 12),
                    _buildDaySelector(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Selecciona la hora'),
                    const SizedBox(height: 12),
                    _buildHourSelector(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Número de personas'),
                    const SizedBox(height: 12),
                    _buildPersonasSelector(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Peticiones especiales'),
                    const SizedBox(height: 12),
                    _buildNotasField(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildConfirmButton(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 16),
            const Text('Reservar tu mesa',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            widget.restaurant['img'] as String,
            width: 52, height: 52,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.restaurant['name'] as String,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 2),
            const Row(
              children: [
                Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                SizedBox(width: 2),
                Text('Chía, Cundinamarca', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)));
  }

  Widget _buildDaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (i) {
        final selected = selectedDay == i;
        return GestureDetector(
          onTap: () => setState(() => selectedDay = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56, height: 68,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFFF6B35) : Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              boxShadow: selected
                  ? [BoxShadow(color: const Color(0xFFFF6B35).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(days[i]['day']!,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: selected ? Colors.white70 : Colors.grey)),
                const SizedBox(height: 4),
                Text(days[i]['num']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF1A1A2E))),
                const SizedBox(height: 2),
                Text('May',
                    style: TextStyle(fontSize: 9, color: selected ? Colors.white60 : Colors.grey[400])),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHourSelector() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: hours.length,
      itemBuilder: (context, i) {
        final selected = selectedHour == i;
        return GestureDetector(
          onTap: () => setState(() => selectedHour = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFFF6B35) : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: selected
                  ? [BoxShadow(color: const Color(0xFFFF6B35).withValues(alpha: 0.3), blurRadius: 8)]
                  : [],
            ),
            child: Center(
              child: Text(hours[i],
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : const Color(0xFF1A1A2E))),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPersonasSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _circleButton(Icons.remove, () { if (personas > 1) setState(() => personas--); }),
          const SizedBox(width: 24),
          Column(
            children: [
              Text('$personas', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
              const Text('personas', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(width: 24),
          _circleButton(Icons.add, () { if (personas < 20) setState(() => personas++); }),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8)],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF1A1A2E)),
      ),
    );
  }

  Widget _buildNotasField() {
    return TextField(
      controller: _notasController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Cumpleaños, alergias, silla para bebé...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _showConfirmDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            shadowColor: const Color(0xFFFF6B35).withValues(alpha: 0.4),
          ),
          child: const Text('Confirmar reserva', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('🎉', style: TextStyle(fontSize: 32))),
            ),
            const SizedBox(height: 16),
            const Text('¡Reserva confirmada!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 8),
            Text('Tu mesa en ${widget.restaurant['name']} está lista.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Volver al inicio', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}