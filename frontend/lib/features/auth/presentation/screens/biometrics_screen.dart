import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:orbit/shared/widgets/primary_button.dart';
import '../../data/repositories/auth_repository.dart';
import '../providers/auth_provider.dart';

class BiometricsScreen extends ConsumerStatefulWidget {
  const BiometricsScreen({super.key});

  @override
  ConsumerState<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState extends ConsumerState<BiometricsScreen>
    with SingleTickerProviderStateMixin {
  // ─── State ────────────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool _isScanning = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final _repo = AuthRepository();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> _handleBiometricLogin() async {
    // The email is passed as a route argument from LoginScreen
    final email = ModalRoute.of(context)?.settings.arguments as String?;

    if (email == null || email.isEmpty) {
      _showError('Please enter your email on the login screen first.');
      return;
    }

    setState(() {
      _isLoading = true;
      _isScanning = true;
    });

    // Simulate the fingerprint scan delay (1.5 seconds)
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      // The biometric token is a device-generated value.
      // In a real app this would come from local_auth package.
      // Here we simulate it with a stable, unique string.
      const simulatedBiometricToken = 'orbit-biometric-device-token-secure';

      final token = await _repo.biometricLogin(
        email: email,
        biometricToken: simulatedBiometricToken,
      );

      ref.read(authProvider.notifier).setAuthenticated(
            fullName: token.fullName,
            isStaff: token.isStaff,
          );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() {
        _isLoading = false;
        _isScanning = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D6E53),
      body: Column(
        children: [
          // Top Green Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 24,
              right: 24,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Use Biometrics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Verify your identity with your\nregistered fingerprint.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Bottom White Section
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Drag handle
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Animated Fingerprint Button
                  GestureDetector(
                    onTap: _isLoading ? null : _handleBiometricLogin,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isScanning ? _pulseAnimation.value : 1.0,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isScanning
                                ? const Color(0xFF0D6E53).withValues(alpha: 0.3)
                                : Colors.grey.shade100,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isScanning
                                  ? const Color(0xFF0D6E53).withValues(alpha: 0.1)
                                  : const Color(0xFFF3F6FA),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Color(0xFF0D6E53),
                                    )
                                  : Icon(
                                      Icons.fingerprint,
                                      size: 64,
                                      color: _isScanning
                                          ? const Color(0xFF0D6E53)
                                          : const Color(0xFF0D6E53)
                                              .withValues(alpha: 0.5),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  Text(
                    _isScanning ? 'Scanning...' : 'Tap to verify fingerprint',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF424242),
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Verification required to access your\nacademic records.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                      height: 1.4,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Login button (fallback)
                  PrimaryButton(
                    text: _isLoading ? 'Verifying...' : 'Scan Fingerprint',
                    onPressed: _handleBiometricLogin,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF757575),
                    ),
                    child: const Text(
                      'USE PASSWORD INSTEAD',
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
