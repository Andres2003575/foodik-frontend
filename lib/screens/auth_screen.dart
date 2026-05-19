import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => isLogin = _tabController.index == 0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (response['data'] != null && response['data']['accessToken'] != null) {
        await ApiService.saveToken(response['data']['accessToken']);
        final role = response['data']['user']['role'];
        if (mounted) {
          if (role == 'RESTAURANT_ADMIN') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } else {
        setState(
          () =>
              _errorMessage = response['message'] ?? 'Error al iniciar sesión',
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'No se pudo conectar al servidor');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await ApiService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (response['data'] != null && response['data']['accessToken'] != null) {
        await ApiService.saveToken(response['data']['accessToken']);
        final role = response['data']['user']['role'];
        if (mounted) {
          if (role == 'RESTAURANT_ADMIN') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } else {
        setState(
          () => _errorMessage = response['message'] ?? 'Error al registrarse',
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'No se pudo conectar al servidor');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF6B35).withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD166).withValues(alpha: 0.05),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🍽️', style: TextStyle(fontSize: 38)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFFD166)],
                    ).createShader(bounds),
                    child: const Text(
                      'FOODIK',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tu compañero gastronómico',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: const Color(0xFFFF6B35),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey[500],
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(text: 'Iniciar sesión'),
                              Tab(text: 'Registrarse'),
                            ],
                          ),
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        SizedBox(
                          height: isLogin ? 320 : 400,
                          child: TabBarView(
                            controller: _tabController,
                            children: [_buildLoginForm(), _buildRegisterForm()],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Te damos la bienvenida 👋',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ingresa tus datos para continuar',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _inputField(
            controller: _emailController,
            hint: 'Correo electrónico',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 12),
          _inputField(
            controller: _passwordController,
            hint: 'Contraseña',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Ingresar',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crea tu cuenta 🍽️',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Únete a la comunidad Foodik',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _inputField(
            controller: _nameController,
            hint: 'Nombre completo',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _inputField(
            controller: _emailController,
            hint: 'Correo electrónico',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 12),
          _inputField(
            controller: _passwordController,
            hint: 'Contraseña',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey[400],
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
