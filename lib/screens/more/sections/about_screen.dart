import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About SolCare'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section with logo and tagline
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Column(
                children: [
                  Icon(
                    Icons.solar_power,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SolCare',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Simplifying Solar Care',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Version 3.0.1',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Mission statement
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our Mission',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: const Text(
                      'SolCare is committed to accelerating India\'s transition to clean energy by making solar panel maintenance simple, accessible, and affordable for every solar system owner. We aim to maximize the lifespan and efficiency of solar installations across the country, reducing carbon footprints and promoting sustainable energy practices.',
                      style: TextStyle(
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Key features
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What We Offer',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    icon: Icons.cleaning_services,
                    title: 'Professional Cleaning',
                    description: 'Expert cleaning services to maintain optimal panel efficiency',
                  ),
                  _buildFeatureItem(
                    icon: Icons.build,
                    title: 'Maintenance & Repairs',
                    description: 'Comprehensive maintenance and quick repair services',
                  ),
                  _buildFeatureItem(
                    icon: Icons.health_and_safety,
                    title: 'Health Monitoring',
                    description: 'Advanced diagnostics and performance monitoring',
                  ),
                  _buildFeatureItem(
                    icon: Icons.emergency,
                    title: 'Emergency Support',
                    description: '24/7 emergency services for critical issues',
                  ),
                ],
              ),
            ),
            
            // Company growth stats
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green.withOpacity(0.1),
              ),
              child: Column(
                children: [
                  const Text(
                    'Our Impact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        value: '50,000+',
                        label: 'Solar Systems Maintained',
                      ),
                      _buildStatItem(
                        value: '30+',
                        label: 'Cities Covered',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        value: '200+',
                        label: 'Trained Technicians',
                      ),
                      _buildStatItem(
                        value: '4.8/5',
                        label: 'Average Rating',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Team section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Leadership Team',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTeamMemberCard(
                          name: 'Rajat Sharma',
                          position: 'Founder & CEO',
                          imageAsset: 'assets/images/team/ceo.jpg',
                        ),
                        _buildTeamMemberCard(
                          name: 'Priya Mehta',
                          position: 'CTO',
                          imageAsset: 'assets/images/team/cto.jpg',
                        ),
                        _buildTeamMemberCard(
                          name: 'Vikram Singh',
                          position: 'Head of Operations',
                          imageAsset: 'assets/images/team/operations.jpg',
                        ),
                        _buildTeamMemberCard(
                          name: 'Anjali Gupta',
                          position: 'Head of Customer Experience',
                          imageAsset: 'assets/images/team/customer.jpg',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Social links
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Connect With Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: Icons.language,
                        label: 'Website',
                        onTap: () {
                          launchUrl(Uri.parse('https://www.solcare.com'));
                        },
                      ),
                      _buildSocialButton(
                        icon: Icons.facebook,
                        label: 'Facebook',
                        onTap: () {
                          // Open Facebook
                        },
                      ),
                      _buildSocialButton(
                        icon: Icons.video_library,
                        label: 'YouTube',
                        onTap: () {
                          // Open YouTube
                        },
                      ),
                      _buildSocialButton(
                        icon: Icons.share,
                        label: 'Share',
                        onTap: () {
                          Share.share('Check out SolCare - the best app for solar panel maintenance. Download now: https://solcare.app/download');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Request features
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton(
                onPressed: () {
                  // Show feature request form
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature request form coming soon')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Text('Suggest a Feature'),
              ),
            ),
            
            // Copyright
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                '© ${DateTime.now().year} SolCare Technologies Pvt. Ltd.\nAll rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMemberCard({
    required String name,
    required String position,
    required String imageAsset,
  }) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(imageAsset),
            onBackgroundImageError: (exception, stackTrace) {},
            child: const Icon(Icons.person),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            position,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
