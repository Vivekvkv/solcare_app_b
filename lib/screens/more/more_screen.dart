import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/providers/theme_provider.dart';
import 'package:solcare_app4/screens/more/components/index.dart';
import 'package:solcare_app4/screens/more/sections/rewards_screen.dart';
import 'package:solcare_app4/screens/more/sections/referral_screen.dart';
import 'package:solcare_app4/screens/more/sections/subscription_screen.dart';
import 'package:solcare_app4/screens/more/sections/tips_guide_screen.dart';
import 'package:solcare_app4/screens/more/sections/help_support_screen.dart';
import 'package:solcare_app4/screens/more/sections/about_screen.dart';
import 'package:solcare_app4/screens/more/sections/privacy_policy_screen.dart';
import 'package:solcare_app4/screens/more/sections/terms_conditions_screen.dart';
import 'package:solcare_app4/screens/more/sections/solar_system_info_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'More',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          // User Info Card with editable fields
          UserInfoCard(profile: profile),
          
          // Solar System Information
          const MenuSectionHeader(title: 'SOLAR SYSTEM'),
          
          MenuTile(
            icon: Icons.solar_power,
            title: 'My Solar System Information',
            subtitle: '${profile.solarSystemSize}kW • ${profile.numberOfPanels} panels',
            iconColor: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SolarSystemInfoScreen(),
                ),
              );
            },
          ),

          const Divider(),
          
          // Rewards & Referrals
          const MenuSectionHeader(title: 'REWARDS & REFERRALS'),
          
          MenuTile(
            icon: Icons.card_giftcard,
            title: 'Reward Points',
            subtitle: 'You have ${profile.rewardPoints} points',
            iconColor: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RewardsScreen(),
                ),
              );
            },
            trailing: RewardPointsBadge(points: profile.rewardPoints),
          ),

          MenuTile(
            icon: Icons.people_alt_outlined,
            title: 'Referral Program',
            subtitle: 'Earn points by referring friends',
            iconColor: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReferralScreen(),
                ),
              );
            },
          ),

          const Divider(),
          
          // Subscription Plans
          const MenuSectionHeader(title: 'SUBSCRIPTION & SERVICES'),
          
          MenuTile(
            icon: Icons.star_border,
            title: 'Subscription Plans',
            subtitle: profile.subscriptionPlan ?? 'Explore maintenance plans',
            iconColor: Colors.amber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionScreen(),
                ),
              );
            },
          ),

          const Divider(),
          
          // App Settings
          const MenuSectionHeader(title: 'APP SETTINGS'),
          
          // Theme Switcher
          SwitchMenuTile(
            icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: 'Dark Mode',
            subtitle: themeProvider.isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
            iconColor: themeProvider.isDarkMode ? Colors.indigo : Colors.amber,
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
          
          // Language Selection
          MenuTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English (US)',
            iconColor: Colors.green,
            onTap: () {
              _showLanguageSelector(context);
            },
          ),

          const Divider(),
          
          // Announcements
          const MenuSectionHeader(title: 'UPDATES & ANNOUNCEMENTS'),
          
          MenuTile(
            icon: Icons.campaign_outlined,
            title: 'Announcements',
            subtitle: 'Coming Soon',
            iconColor: Colors.red,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Announcements feature coming soon!')),
              );
            },
          ),

          const Divider(),
          
          // Support & Help
          const MenuSectionHeader(title: 'SUPPORT'),
          
          MenuTile(
            icon: Icons.tips_and_updates_outlined,
            title: 'Tips & Guides',
            subtitle: 'Best practices for solar maintenance',
            iconColor: Colors.amber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TipsGuideScreen(),
                ),
              );
            },
          ),

          MenuTile(
            icon: Icons.emergency_outlined,
            title: 'Emergency Contact',
            subtitle: 'Quick dial for solar emergencies',
            iconColor: Colors.red,
            onTap: () {
              _showEmergencyContactDialog(context);
            },
          ),

          MenuTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'FAQs, chat support, and contact options',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),

          const Divider(),
          
          // About & Legal
          const MenuSectionHeader(title: 'ABOUT & LEGAL'),
          
          MenuTile(
            icon: Icons.info_outline,
            title: 'About SolCare',
            subtitle: 'Company information & mission',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),

          MenuTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),

          MenuTile(
            icon: Icons.gavel_outlined,
            title: 'Terms & Conditions',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsConditionsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 32),
          
          // Version info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'Version 3.0.1',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildLanguageOption(context, 'English (US)', true),
              _buildLanguageOption(context, 'Hindi', false),
              _buildLanguageOption(context, 'Bengali', false),
              _buildLanguageOption(context, 'Tamil', false),
              _buildLanguageOption(context, 'Telugu', false),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildLanguageOption(BuildContext context, String language, bool isSelected) {
    return ListTile(
      title: Text(language),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        Navigator.pop(context);
        if (!isSelected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Language changing to $language')),
          );
        }
      },
    );
  }
  
  void _showEmergencyContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Contact'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'For solar system emergencies, please contact our 24/7 helpline:',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  '+91 800-SOLCARE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.call),
            label: Text('Call Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              launchUrl(Uri.parse('tel:+918007652273'));
            },
          ),
        ],
      ),
    );
  }
}
