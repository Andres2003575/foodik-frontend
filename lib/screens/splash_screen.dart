import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _pulseController;
  late AnimationController _buttonController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineOpacity;
  late Animation<double> _pulse;
  late Animation<double> _buttonOpacity;
  late Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _taglineController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _buttonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.5)));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _taglineController, curve: Curves.easeIn));
    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeIn));
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeOut));
    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _runAnimations();
  }

  Future<void> _runAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _taglineController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _buttonController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _buttonController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80, right: -80,
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Transform.scale(
                  scale: _pulse.value,
                  child: Container(
                    width: 300, height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF6B35).withValues(alpha: 0.08),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100, left: -60,
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Transform.scale(
                  scale: _pulse.value,
                  child: Container(
                    width: 250, height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFD166).withValues(alpha: 0.06),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (_, __) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Container(
                          width: 110, height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B35).withValues(alpha: 0.5),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 52))),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (_, __) => FadeTransition(
                      opacity: _textOpacity,
                      child: SlideTransition(
                        position: _textSlide,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFFFF6B35), Color(0xFFFFD166)],
                          ).createShader(bounds),
                          child: const Text(
                            'FOODIK',
                            style: TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                    animation: _taglineController,
                    builder: (_, __) => Opacity(
                      opacity: _taglineOpacity.value,
                      child: const Text(
                        'Tu compañero gastronómico',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white54,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  AnimatedBuilder(
                    animation: _buttonController,
                    builder: (_, __) => FadeTransition(
                      opacity: _buttonOpacity,
                      child: SlideTransition(
                        position: _buttonSlide,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, '/auth'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 8,
                                shadowColor: const Color(0xFFFF6B35).withValues(alpha: 0.5),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Descubrir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _taglineController,
                    builder: (_, __) => Opacity(
                      opacity: _taglineOpacity.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == 1 ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == 1 ? const Color(0xFFFF6B35) : Colors.white24,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}