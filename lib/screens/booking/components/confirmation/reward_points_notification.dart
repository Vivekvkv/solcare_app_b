import 'package:flutter/material.dart';

class RewardPointsNotification extends StatelessWidget {
  final int points;

  const RewardPointsNotification({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.1), // Changed from withAlpha(25) to withOpacity(0.1)
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.card_giftcard,
            color: colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Text(
            'You earned $points reward points!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSecondary, // Improved contrast
            ),
          ),
        ],
      ),
    );
  }
}
