import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Image.asset(
            'assets/images/jolly_logo.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'Jolly',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4E157),
                  fontStyle: FontStyle.italic,
                ),
              );
            },
          ),
          // Icons
          Row(
            children: [
              // Profile
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[800],
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Notifications
              const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              // Search Icon
              const Icon(
                Icons.search,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
