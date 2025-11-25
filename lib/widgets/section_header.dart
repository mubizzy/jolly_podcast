import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // if (onSeeAllTap != null)
            //   TextButton(
            //     onPressed: onSeeAllTap,
            //     child: const Text(
            //       'See allll',
            //       style: TextStyle(
            //         color: Color(0xFFD4E157),
            //         fontSize: 13,
            //       ),
            //     ),
            //   ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ],
    );
  }
}
