import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import 'signup2_screen.dart';

class Signup1Screen extends StatefulWidget {
  const Signup1Screen({super.key});

  @override
  State<Signup1Screen> createState() => _Signup1ScreenState();
}

class _Signup1ScreenState extends State<Signup1Screen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/signup_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
            onError: (exception, stackTrace) {},
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/images/jolly_logo.png',
                      height: 60,
                      // errorBuilder: (context, error, stackTrace) {
                      //   return const Text(
                      //     'Jolly',
                      //     style: TextStyle(
                      //       fontSize: 48,
                      //       fontWeight: FontWeight.bold,
                      //       color: Color(0xFFD4E157),
                      //       fontStyle: FontStyle.italic,
                      //     ),
                      //   );
                      // },
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Tagline
                  const Center(
                    child: Text(
                      'PODCASTS FOR\nAFRICA, BY AFRICANS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  // Phone Input
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        // Country Flag
                        const Text('🇳🇬', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter your phone number',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Continue Button
                  PrimaryButton(
                    text: 'Continue',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signup2Screen(
                            phoneNumber: _phoneController.text.isEmpty
                                ? '08023400000'
                                : _phoneController.text,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Terms and Conditions
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        children: [
                          const TextSpan(
                            text: 'By proceeding, you agree and accept our ',
                          ),
                          TextSpan(
                            text: 'T&C',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Become a Podcast Creator
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'BECOME A PODCAST CREATOR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
