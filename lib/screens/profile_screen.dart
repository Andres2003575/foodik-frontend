import 'package:flutter/material.dart';
import '../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildStats(),
            _buildMenu(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [darkColor, Color(0xFF0F3460)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mi perfil',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(18)),
                    child: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Stack(
                children: [
                  Container(
                    width: 86, height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [primaryColor, Color(0xFFFF8C42)]),
                      boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.4), blurRadius: 16)],
                    ),
                    child: const Center(child: Text('G', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white))),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 24, height: 24,
                      decoration: const BoxDecoration(color: secondaryColor, shape: BoxShape.circle),
                      child: const Icon(Icons.edit, size: 12, color: darkColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Gaby M.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              const Text('gaby@email.com', style: TextStyle(fontSize: 13, color: Colors.white54)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🍽️', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text('Foodie Premium', style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _stat('12', 'Reservas'),
            _divider(),
            _stat('6', 'Favoritos'),
            _divider(),
            _stat('\$430K', 'Ahorrado'),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(children: [
      Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: darkColor)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    ]);
  }

  Widget _divider() => Container(width: 1, height: 32, color: Colors.grey[200]);

  Widget _buildMenu(BuildContext context) {
    final sections = [
      {
        'title': 'Mi cuenta',
        'items': [
          {'icon': Icons.person_outline, 'label': 'Datos personales', 'color': primaryColor},
          {'icon': Icons.notifications_outlined, 'label': 'Notificaciones', 'color': Colors.blue},
          {'icon': Icons.lock_outline, 'label': 'Privacidad y seguridad', 'color': Colors.purple},
        ],
      },
      {
        'title': 'Preferencias',
        'items': [
          {'icon': Icons.restaurant_menu_outlined, 'label': 'Preferencias de comida', 'color': Colors.orange},
          {'icon': Icons.location_on_outlined, 'label': 'Mis direcciones', 'color': Colors.green},
          {'icon': Icons.credit_card_outlined, 'label': 'Métodos de pago', 'color': Colors.teal},
        ],
      },
      {
        'title': 'Soporte',
        'items': [
          {'icon': Icons.help_outline, 'label': 'Centro de ayuda', 'color': Colors.indigo},
          {'icon': Icons.star_outline, 'label': 'Calificar la app', 'color': secondaryColor},
          {'icon': Icons.logout, 'label': 'Cerrar sesión', 'color': Colors.red},
        ],
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections.map((section) {
          final items = section['items'] as List;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(section['title'] as String,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    final isLast = i == items.length - 1;
                    final isLogout = item['label'] == 'Cerrar sesión';
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            if (isLogout) Navigator.pushReplacementNamed(context, '/auth');
                          },
                          leading: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item['icon'] as IconData, size: 18, color: item['color'] as Color),
                          ),
                          title: Text(item['label'] as String,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isLogout ? Colors.red : darkColor)),
                          trailing: isLogout
                              ? null
                              : const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        ),
                        if (!isLast) Divider(height: 1, color: Colors.grey[200], indent: 68),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }).toList(),
      ),
    );
  }
}