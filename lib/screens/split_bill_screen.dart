import 'package:flutter/material.dart';
import 'payment_screen.dart';

class SplitBillScreen extends StatefulWidget {
  final String restaurantName;
  const SplitBillScreen({super.key, required this.restaurantName});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  int selectedMode = 0;

  final modes = [
    {'icon': '⚖️', 'label': 'Partes\niguales'},
    {'icon': '🧾', 'label': 'Cada uno\nlo suyo'},
    {'icon': '🔗', 'label': 'Cadena'},
  ];

  final participants = [
    {'name': 'Gaby M.', 'initial': 'G', 'color': 0xFFFF6B35, 'amount': 43500.0, 'paid': true},
    {'name': 'Carlos R.', 'initial': 'C', 'color': 0xFF4ECDC4, 'amount': 43500.0, 'paid': false},
    {'name': 'Laura S.', 'initial': 'L', 'color': 0xFF9B59B6, 'amount': 43500.0, 'paid': false},
    {'name': 'Andrés P.', 'initial': 'A', 'color': 0xFF2ECC71, 'amount': 43500.0, 'paid': false},
  ];

  double get total => participants.fold(0, (sum, p) => sum + (p['amount'] as double));
  double get collected => participants.where((p) => p['paid'] as bool).fold(0, (sum, p) => sum + (p['amount'] as double));
  double get pending => total - collected;

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
                    _buildTotalCard(),
                    const SizedBox(height: 24),
                    _buildModeSelector(),
                    const SizedBox(height: 24),
                    _buildParticipants(context),
                    const SizedBox(height: 20),
                    _buildReminderButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomButton(context),
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
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
            const Text('Dividir la cuenta',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.receipt_outlined, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    final paidCount = participants.where((p) => p['paid'] as bool).length;
    final progress = collected / total;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  const Icon(Icons.restaurant, size: 12, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(widget.restaurantName, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                ]),
              ),
              Text('$paidCount de ${participants.length} personas pagaron',
                  style: const TextStyle(fontSize: 11, color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('TOTAL DE LA CUENTA', style: TextStyle(fontSize: 11, color: Colors.white38, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(
            '\$${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const Text('Pesos colombianos (COP)', style: TextStyle(fontSize: 11, color: Colors.white38)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFF6B35)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _progressLabel('Cobrado', collected, Colors.green),
              _progressLabel('Pendiente', pending, const Color(0xFFFF6B35)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressLabel(String label, double amount, Color color) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white38)),
        Text('\$$formatted', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Modo de división',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
        const SizedBox(height: 12),
        Row(
          children: List.generate(modes.length, (i) {
            final selected = selectedMode == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedMode = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: i < modes.length - 1 ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFFF6B35) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: selected
                        ? [BoxShadow(color: const Color(0xFFFF6B35).withValues(alpha: 0.3), blurRadius: 10)]
                        : [],
                  ),
                  child: Column(
                    children: [
                      Text(modes[i]['icon']!, style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 6),
                      Text(
                        modes[i]['label']!,
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
      ],
    );
  }

  Widget _buildParticipants(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Participantes',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            Text('Cada uno: \$${(total / participants.length).toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 12),
        ...participants.map((p) => _buildParticipantRow(context, p)),
      ],
    );
  }

  Widget _buildParticipantRow(BuildContext context, Map<String, dynamic> p) {
    final paid = p['paid'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: paid ? Colors.green.withValues(alpha: 0.2) : Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Color(p['color'] as int).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(p['initial'] as String,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(p['color'] as int))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(p['name'] as String,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                  if (p['name'] == 'Gaby M.')
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('tú', style: TextStyle(fontSize: 9, color: Color(0xFFFF6B35), fontWeight: FontWeight.bold)),
                    ),
                ]),
                const SizedBox(height: 2),
                Row(children: [
                  Icon(paid ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 12, color: paid ? Colors.green : Colors.grey),
                  const SizedBox(width: 4),
                  Text(paid ? '✓ Pagado' : '⏳ Pendiente',
                      style: TextStyle(fontSize: 11, color: paid ? Colors.green : Colors.grey)),
                ]),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${(p['amount'] as double).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
              ),
              if (!paid)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PaymentScreen(
                      personName: p['name'] as String,
                      amount: p['amount'] as double,
                    )),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Pagar', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReminderButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.notifications_outlined, size: 18),
        label: const Text('Enviar recordatorios'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1A1A2E),
          side: BorderSide(color: Colors.grey[300]!),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final pendingCount = participants.where((p) => !(p['paid'] as bool)).length;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A2E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            pendingCount > 0 ? 'Cerrar cuenta · $pendingCount pendientes' : '¡Cuenta saldada! 🎉',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}