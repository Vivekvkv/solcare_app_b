import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;
    final referralCode = 'SOLCARE${profile.id.substring(0, 6).toUpperCase()}';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Program'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Referral illustration
          Container(
            height: 180,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_alt,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Refer & Earn Rewards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Referral explanation
          const Text(
            'Share SolCare with your friends and family who have solar panels. When they sign up and complete their first booking using your referral code, you both earn 100 reward points!',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 32),
          
          // Referral code
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    'Your Referral Code',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        referralCode,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: referralCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Referral code copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Share Referral Code'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    onPressed: () {
                      Share.share(
                        'Use my referral code $referralCode to get 100 bonus points when you sign up for SolCare - the best solar panel maintenance app! Download now: https://solcare.app/download',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Referral stats
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Referral Stats',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatItem(
                    icon: Icons.person_add,
                    title: 'Total Referrals',
                    value: '3',
                  ),
                  _buildStatItem(
                    icon: Icons.check_circle,
                    title: 'Successful Referrals',
                    value: '2',
                  ),
                  _buildStatItem(
                    icon: Icons.star,
                    title: 'Points Earned',
                    value: '200',
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Leaderboard
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.leaderboard, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Referral Leaderboard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildLeaderboardItem(
                  rank: '1',
                  name: 'Raj Kumar',
                  referrals: '12',
                  isCurrentUser: false,
                ),
                _buildLeaderboardItem(
                  rank: '2',
                  name: 'Priya Singh',
                  referrals: '8',
                  isCurrentUser: false,
                ),
                _buildLeaderboardItem(
                  rank: '3',
                  name: 'Amit Patel',
                  referrals: '7',
                  isCurrentUser: false,
                ),
                _buildLeaderboardItem(
                  rank: '4',
                  name: 'Neha Gupta',
                  referrals: '5',
                  isCurrentUser: false,
                ),
                _buildLeaderboardItem(
                  rank: '5',
                  name: 'Vikram Singh',
                  referrals: '4',
                  isCurrentUser: false,
                ),
                const Divider(),
                _buildLeaderboardItem(
                  rank: '14',
                  name: profile.name,
                  referrals: '2',
                  isCurrentUser: true,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Terms and conditions
          const Text(
            'Terms & Conditions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Referral bonus is credited after the referred user completes their first booking\n'
            '• Maximum 20 successful referrals per user per year\n'
            '• Referral code must be entered at the time of account creation\n'
            '• SolCare reserves the right to modify the referral program at any time',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(title),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLeaderboardItem({
    required String rank,
    required String name,
    required String referrals,
    required bool isCurrentUser,
  }) {
    return Container(
      color: isCurrentUser ? Colors.amber.withOpacity(0.1) : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: int.parse(rank) <= 3 ? Colors.amber : Colors.grey[300],
          child: Text(
            rank,
            style: TextStyle(
              color: int.parse(rank) <= 3 ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Text(
          '$referrals referrals',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
