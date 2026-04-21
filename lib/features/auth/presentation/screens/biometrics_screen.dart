import 'package:flutter/material.dart';
import 'package:orbit/shared/widgets/primary_button.dart';

class BiometricsScreen extends StatelessWidget {
  const BiometricsScreen({super.key});

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
                  "Secure your access with the\nsanctuary's digital fingerprint lock.",
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
                  // Top Drag Handle (pill)
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Concentric Fingerprint Circles
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF3F6FA), // Light blue-grey background
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.fingerprint,
                            size: 64,
                            color: Color(0xFF0D6E53),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(flex: 1),
                  
                  // Text Instructions
                  const Text(
                    'Touch the sensor to verify your\nfingerprint.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF424242),
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Verification required to access sensitive\nacademic records.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                      height: 1.4,
                    ),
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Action Buttons
                  PrimaryButton(
                    text: 'Add new fingerprint',
                    isOutlined: true,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.fingerprint,
                      color: Color(0xFF0D6E53),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 48), // Bottom safe area padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
