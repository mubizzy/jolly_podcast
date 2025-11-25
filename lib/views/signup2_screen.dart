import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import 'signup3_screen.dart';

class Signup2Screen extends StatefulWidget {
  final String phoneNumber;
  
  const Signup2Screen({super.key, required this.phoneNumber});

  @override
  State<Signup2Screen> createState() => _Signup2ScreenState();
}

class _Signup2ScreenState extends State<Signup2Screen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/signup_bg2.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
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
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'Jolly',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD4E157),
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Instructions
                  Center(
                    child: Text(
                      'Enter the 6 digit code sent to your\nphone number ${widget.phoneNumber}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  // OTP Input
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        letterSpacing: 8,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter code',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 0,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
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
                          builder: (context) => Signup3Screen(
                            phoneNumber: widget.phoneNumber,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
