import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recycle_mania/screens/menu_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  late AnimationController _controller;
  final List<_FloatingIcon> _floatingIcons = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Create floating recycling icons
    for (int i = 0; i < 5; i++) {
      _floatingIcons.add(_FloatingIcon(
        icon: _getRandomRecyclingIcon(),
        position: Offset(
          math.Random().nextDouble() * 300,
          math.Random().nextDouble() * 600,
        ),
        speed: math.Random().nextDouble() * 2 + 1,
      ));
    }
  }

  IconData _getRandomRecyclingIcon() {
    final icons = [
      Icons.recycling,
      Icons.eco,
      Icons.nature,
      Icons.park,
      Icons.water_drop,
    ];
    return icons[math.Random().nextInt(icons.length)];
  }

  Future<void> _login() async {
    if (_usernameController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text);
      if (mounted) {
        // Add animation for transition
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MenuScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, escolhe um nome!'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade100,
                  Colors.green.shade200,
                  Colors.green.shade300,
                ],
              ),
            ),
          ),

          // Floating Icons Animation
          ...List.generate(_floatingIcons.length, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final icon = _floatingIcons[index];
                final value = _controller.value * icon.speed;
                final dx = math.sin(value * math.pi * 2) * 30;
                final dy = math.cos(value * math.pi * 2) * 30;

                return Positioned(
                  left: icon.position.dx + dx,
                  top: icon.position.dy + dy,
                  child: Icon(
                    icon.icon,
                    size: 30,
                    color: Colors.green.shade700.withOpacity(0.3),
                  ),
                );
              },
            );
          }),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Container
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.recycling,
                          size: 80,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Title
                      Text(
                        'RecycleMania',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Vamos salvar o planeta juntos! 🌍',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Login Card
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _usernameController,
                              style: GoogleFonts.poppins(),
                              decoration: InputDecoration(
                                labelText: 'Como te chamas, aventureiro?',
                                labelStyle:
                                    TextStyle(color: Colors.green.shade700),
                                prefixIcon: Icon(Icons.person,
                                    color: Colors.green.shade700),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.green.shade200),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.green.shade700, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.green.shade50,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Login Button
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Começar Aventura',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.green.shade100,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _controller.dispose();
    super.dispose();
  }
}

// Helper class for floating icons
class _FloatingIcon {
  final IconData icon;
  final Offset position;
  final double speed;

  _FloatingIcon({
    required this.icon,
    required this.position,
    required this.speed,
  });
}
