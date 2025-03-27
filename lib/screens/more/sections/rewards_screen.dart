import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Points'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Reward points card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${profile.rewardPoints}',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Available Points',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // How to earn section
          const Text(
            'How to Earn Points',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildEarningMethod(
            icon: Icons.cleaning_services,
            title: 'Book Services',
            description: 'Earn 1 point for every ₹10 spent on services',
            points: '+1 pt/₹10',
          ),
          _buildEarningMethod(
            icon: Icons.people,
            title: 'Refer Friends',
            description: 'When your friend completes their first booking',
            points: '+100 pts',
          ),
          _buildEarningMethod(
            icon: Icons.star_rate,
            title: 'Write Reviews',
            description: 'Share your experience after a service',
            points: '+25 pts',
          ),
          _buildEarningMethod(
            icon: Icons.loyalty,
            title: 'Loyalty Bonus',
            description: 'Every 6 months as an active customer',
            points: '+50 pts',
          ),
          
          const SizedBox(height: 24),
          
          // How to use section
          const Text(
            'How to Use Points',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildRedemptionOption(
            icon: Icons.discount,
            title: 'Service Discounts',
            description: 'Use points for discounts on services',
            requirement: '100 pts = ₹50 off',
          ),
          _buildRedemptionOption(
            icon: Icons.card_membership,
            title: 'Membership Upgrade',
            description: 'Upgrade your maintenance plan',
            requirement: '500 pts = 1 month free',
          ),
          _buildRedemptionOption(
            icon: Icons.schedule,
            title: 'Priority Scheduling',
            description: 'Get priority service scheduling',
            requirement: '200 pts per booking',
          ),
          
          const SizedBox(height: 24),
          
          // Points history
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'Points History',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                _buildHistoryItem(
                  title: 'Service Booking',
                  date: '15 Jun 2023',
                  points: '+75',
                  isPositive: true,
                ),
                _buildHistoryItem(
                  title: 'Discount Redemption',
                  date: '02 May 2023',
                  points: '-100',
                  isPositive: false,
                ),
                _buildHistoryItem(
                  title: 'Review Bonus',
                  date: '28 Apr 2023',
                  points: '+25',
                  isPositive: true,
                ),
                _buildHistoryItem(
                  title: 'Referral Reward',
                  date: '15 Apr 2023',
                  points: '+100',
                  isPositive: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: () {
                      // View complete history
                    },
                    child: const Text('View Complete History'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEarningMethod({
    required IconData icon,
    required String title,
    required String description,
    required String points,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.amber.withOpacity(0.2),
        child: Icon(icon, color: Colors.amber),
      ),
      title: Text(title),
      subtitle: Text(description),
      trailing: Text(
        points,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }
  
  Widget _buildRedemptionOption({
    required IconData icon,
    required String title,
    required String description,
    required String requirement,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.2),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title),
      subtitle: Text(description),
      trailing: Text(
        requirement,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String points,
    required bool isPositive,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(
        points,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isPositive ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
