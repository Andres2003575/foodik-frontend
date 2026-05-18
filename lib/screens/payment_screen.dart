import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String personName;
  final double amount;
  const PaymentScreen({super.key, required this.personName, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  int selectedMethod = 0;
  bool isPaying = false;
  bool isPaid = false;
  late AnimationController _successController;
  late Animation<double> _successScale;

  final methods = [
    {'icon': '💳', 'label': 'Tarjeta', 'detail': '**** 4521'},
    {'icon': '🏦', 'label': 'Nequi', 'detail': '310 123 4567'},
    {'icon': '📱', 'label': 'Daviplata', 'detail': '312 987 6543'},
    {'icon': '💵', 'label': 'Efectivo', 'detail': 'Pago en caja'},
  ];

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _successScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    setState(() => isPaying = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    setState(() { isPaying = false; isPaid = true; });
    _successController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: isPaid ? _buildSuccessView(context) : _buildPaymentView(),
                ),
              ),
            ],
          ),
          if (isPaying) _buildLoadingOverlay(),
        ],
      ),
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
            const Text('Realizar pago',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monto
          Center(
            child: Column(
              children: [
                Text(
                  'Hola, ${widget.personName.split(' ')[0]} 👋',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text('Tu parte es', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  '\$${widget.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF1A1A2E)),
                ),
                const Text('Pesos colombianos (COP)',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Método de pago
          const Text('Método de pago',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 12),

          ...List.generate(methods.length, (i) {
            final m = methods[i];
            final selected = selectedMethod == i;
            return GestureDetector(
              onTap: () => setState(() => selectedMethod = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFFF6B35).withValues(alpha: 0.05) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? const Color(0xFFFF6B35) : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Text(m['icon']!, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['label']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                          Text(m['detail']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    if (selected)
                      Container(
                        width: 22, height: 22,
                        decoration: const BoxDecoration(color: Color(0xFFFF6B35), shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 14),
                      )
                    else
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // Resumen
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E).withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: Column(
              children: [
                _summaryRow('Subtotal', widget.amount),
                const Divider(height: 16),
                _summaryRow('Propina sugerida (10%)', widget.amount * 0.1),
                const Divider(height: 16),
                _summaryRow('Total', widget.amount * 1.1, isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double amount, {bool isBold = false}) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(
          fontSize: 13,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isBold ? const Color(0xFF1A1A2E) : Colors.grey,
        )),
        Text('\$$formatted', style: TextStyle(
          fontSize: 13,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isBold ? const Color(0xFFFF6B35) : const Color(0xFF1A1A2E),
        )),
      ],
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _successController,
        builder: (_, __) => Transform.scale(
          scale: _successScale.value,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('✅', style: TextStyle(fontSize: 48))),
                ),
                const SizedBox(height: 24),
                const Text('¡Pago exitoso!',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 8),
                Text(
                  '${widget.personName.split(' ')[0]}, tu pago de \$${widget.amount.toStringAsFixed(0)} fue procesado.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Volver a la cuenta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black45,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFF6B35)),
            SizedBox(height: 16),
            Text('Procesando pago...', style: TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget get _payButton => Container(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4))],
    ),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _pay,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B35),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: const Text('Confirmar pago', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}