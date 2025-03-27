import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share('SolCare Privacy Policy: https://solcare.com/privacy');
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              launchUrl(Uri.parse('https://solcare.com/privacy'));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last updated
            Align(
              alignment: Alignment.center,
              child: Text(
                'Last Updated: June 15, 2023',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Introduction
            const Text(
              'Introduction',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'SolCare Technologies Pvt. Ltd. ("we", "our", or "us") respects your privacy and is committed to protecting your personal data. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.',
              style: TextStyle(height: 1.5),
            ),
            
            const SizedBox(height: 24),
            
            // Information We Collect
            const Text(
              'Information We Collect',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildPolicySection(
              title: 'Personal Information',
              content: 'We may collect personal information that you voluntarily provide when using our app, including but not limited to:\n\n'
                      '• Name, email address, phone number, and mailing address\n'
                      '• Payment information\n'
                      '• Profile pictures and account preferences\n'
                      '• Solar system details and configurations',
            ),
            _buildPolicySection(
              title: 'Device Information',
              content: 'When you access the app, we automatically collect certain information about your device, including:\n\n'
                      '• Device type, operating system, and browser type\n'
                      '• IP address and device identifiers\n'
                      '• Mobile network information\n'
                      '• App usage data and analytics',
            ),
            _buildPolicySection(
              title: 'Location Data',
              content: 'With your consent, we collect and process location data to provide location-based services such as:\n\n'
                      '• Connecting you with nearby service technicians\n'
                      '• Providing local weather data for solar performance metrics\n'
                      '• Giving you location-specific maintenance recommendations',
            ),
            
            const SizedBox(height: 24),
            
            // How We Use Your Information
            const Text(
              'How We Use Your Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We use the information we collect for various purposes, including:',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('To provide, maintain, and improve our services'),
            _buildBulletPoint('To process and complete transactions'),
            _buildBulletPoint('To send service updates and promotional materials'),
            _buildBulletPoint('To respond to your comments and questions'),
            _buildBulletPoint('To personalize your experience'),
            _buildBulletPoint('To monitor and analyze trends and usage'),
            _buildBulletPoint('To protect, investigate, and deter against fraudulent or illegal activity'),
            
            const SizedBox(height: 24),
            
            // Data Sharing and Disclosure
            const Text(
              'Data Sharing and Disclosure',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildPolicySection(
              title: 'Service Providers',
              content: 'We may share your information with third-party vendors, service providers, and contractors who perform services on our behalf, such as payment processing, data analysis, email delivery, and customer service.',
            ),
            _buildPolicySection(
              title: 'Business Transfers',
              content: 'If we are involved in a merger, acquisition, or sale of all or a portion of our assets, your information may be transferred as part of that transaction.',
            ),
            _buildPolicySection(
              title: 'Legal Requirements',
              content: 'We may disclose your information if required to do so by law or in response to valid requests by public authorities (e.g., court or government agency).',
            ),
            
            const SizedBox(height: 24),
            
            // Data Security
            const Text(
              'Data Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We implement appropriate technical and organizational measures to protect the security of your personal information. However, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
              style: TextStyle(height: 1.5),
            ),
            
            const SizedBox(height: 24),
            
            // Your Rights
            const Text(
              'Your Privacy Rights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Depending on your location, you may have the following rights:',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Access and receive a copy of your personal data'),
            _buildBulletPoint('Rectify inaccurate or incomplete personal data'),
            _buildBulletPoint('Request deletion of your personal data'),
            _buildBulletPoint('Restrict or object to processing of your data'),
            _buildBulletPoint('Data portability'),
            _buildBulletPoint('Withdraw consent at any time'),
            
            const SizedBox(height: 16),
            const Text(
              'To exercise these rights, please contact us using the information provided in the "Contact Us" section.',
              style: TextStyle(height: 1.5),
            ),
            
            const SizedBox(height: 24),
            
            // Children's Privacy
            const Text(
              'Children\'s Privacy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our app is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.',
              style: TextStyle(height: 1.5),
            ),
            
            const SizedBox(height: 24),
            
            // Changes to Policy
            const Text(
              'Changes to This Privacy Policy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We may update our Privacy Policy from time to time. The updated version will be indicated by an updated "Last Updated" date and the updated version will be effective as soon as it is accessible. We encourage you to review this Privacy Policy periodically.',
              style: TextStyle(height: 1.5),
            ),
            
            const SizedBox(height: 24),
            
            // Contact
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have any questions about this Privacy Policy or our privacy practices, please contact us at:',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('Email'),
              subtitle: const Text('privacy@solcare.com'),
              onTap: () {
                Clipboard.setData(const ClipboardData(text: 'privacy@solcare.com'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: const Text('Address'),
              subtitle: const Text('SolCare Technologies Pvt. Ltd., Green Energy Road, Delhi, India'),
              onTap: () {
                Clipboard.setData(const ClipboardData(text: 'SolCare Technologies Pvt. Ltd., Green Energy Road, Delhi, India'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address copied to clipboard')),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Download full policy
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading full privacy policy...')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Full Policy (PDF)'),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Acknowledgment
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'By using our app, you acknowledge that you have read and understand this Privacy Policy.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '© ${DateTime.now().year} SolCare Technologies Pvt. Ltd.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
        ],
      ),
    );
  }
}
