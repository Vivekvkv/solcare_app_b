import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'More',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          // User Info Card
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: profile.profileImage != null
                      ? AssetImage(profile.profileImage!)
                      : null,
                  child: profile.profileImage == null
                      ? Text(
                          profile.name.isNotEmpty ? profile.name[0] : '?',
                          style: const TextStyle(fontSize: 30),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${profile.rewardPoints} Reward Points',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'ACCOUNT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
          ),

          _buildMenuTile(
            icon: Icons.notifications_none,
            title: 'Notifications & Announcements',
            onTap: () {},
          ),

          _buildMenuTile(
            icon: Icons.card_giftcard,
            title: 'Reward Points',
            onTap: () {},
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                profile.rewardPoints.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          _buildMenuTile(
            icon: Icons.history,
            title: 'Maintenance History',
            onTap: () {},
          ),

          _buildMenuTile(
            icon: Icons.health_and_safety_outlined,
            title: 'Solar Health Status',
            iconColor: Theme.of(context).colorScheme.tertiary,
            onTap: () {},
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'SUPPORT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
          ),

          _buildMenuTile(
            icon: Icons.tips_and_updates_outlined,
            title: 'Tips & Guides',
            iconColor: Colors.amber,
            onTap: () {},
          ),

          _buildMenuTile(
            icon: Icons.forum_outlined,
            title: 'Community Forum',
            onTap: () {},
          ),

          _buildMenuTile(
            icon: Icons.emergency_outlined,
            title: 'Emergency Contact',
            iconColor: Colors.red,
            onTap: () {},
          ),

          _buildMenuTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'ABOUT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
          ),

          _buildMenuTile(
            icon: Icons.info_outline,
            title: 'About SolCare',
            onTap: () {},
          ),

          _buildMenuTile(
            icon: Icons.policy_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),

          _buildMenuTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: () {},
          ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              'App Version 1.0.0',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
