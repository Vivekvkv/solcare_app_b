import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solcare_app4/models/profile_model.dart';

class SubscriptionSection extends StatelessWidget {
  final ProfileModel profile;

  const SubscriptionSection({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${profile.subscriptionType} Subscription',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Valid till: ${dateFormat.format(profile.subscriptionExpiry)}',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Renew subscription
              },
              child: const Text('Renew / Upgrade Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
