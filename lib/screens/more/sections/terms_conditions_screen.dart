import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share('SolCare Terms & Conditions: https://solcare.com/terms');
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              launchUrl(Uri.parse('https://solcare.com/terms'));
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
              'These Terms and Conditions ("Terms") govern your use of the SolCare mobile application ("App") provided by SolCare Technologies Pvt. Ltd. ("we", "our", or "us"). By downloading, accessing, or using our App, you agree to be bound by these Terms. If you disagree with any part of these Terms, you may not access or use our App.',
              style: TextStyle(height: 1.5),
            ),
            
            const SizedBox(height: 24),
            
            // User Accounts
            _buildSection(
              title: 'User Accounts',
              content: 'To use certain features of the App, you must register for an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.\n\n'
                       'You are responsible for safeguarding the password that you use to access the App and for any activities or actions under your password. We encourage you to use a strong, unique password for your account.',
            ),
            
            // Services
            _buildSection(
              title: 'Services',
              content: 'SolCare provides solar panel maintenance, monitoring, and related services through our App. The availability of services may vary based on your location and the type of solar system you have.\n\n'
                       'We reserve the right to modify, suspend, or discontinue any part of our services at any time without notice or liability.',
            ),
            
            // Service Bookings and Cancellations
            _buildSection(
              title: 'Service Bookings and Cancellations',
              content: 'When you book a service through our App, you agree to provide accurate information about your solar system and location.\n\n'
                       'Cancellation policies vary depending on the service type. In general, cancellations made at least 24 hours before the scheduled service time will not incur any charges. Late cancellations or no-shows may be subject to a cancellation fee of up to 50% of the service cost.',
            ),
            
            // Payments
            _buildSection(
              title: 'Payments',
              content: 'All payments are processed securely through our payment partners. By providing payment information, you represent that you are authorized to use the payment method.\n\n'
                       'Service prices are as listed in the App and may vary based on your solar system size, location, and specific requirements. Additional charges may apply for emergency services or services performed outside standard business hours.',
            ),
            
            // User Content
            _buildSection(
              title: 'User Content',
              content: 'Our App may allow you to post, upload, or share content such as reviews, feedback, and images ("User Content"). You retain ownership of your User Content, but you grant us a non-exclusive, royalty-free, worldwide license to use, display, and distribute your User Content in connection with our services.\n\n'
                       'You are solely responsible for your User Content and the consequences of posting it. You represent that you have all necessary rights to your User Content and that it does not violate any third-party rights or applicable laws.',
            ),
            
            // Prohibited Activities
            _buildSection(
              title: 'Prohibited Activities',
              content: 'You agree not to engage in any of the following prohibited activities:\n\n'
                       '• Using the App for any illegal purpose\n'
                       '• Attempting to interfere with or disrupt the integrity or performance of the App\n'
                       '• Attempting to gain unauthorized access to the App or related systems\n'
                       '• Collecting or harvesting any information from the App without our permission\n'
                       '• Using the App to transmit any viruses, malware, or other harmful code',
            ),
            
            // Intellectual Property
            _buildSection(
              title: 'Intellectual Property',
              content: 'The App and its original content, features, and functionality are and will remain the exclusive property of SolCare Technologies Pvt. Ltd. and its licensors. The App is protected by copyright, trademark, and other intellectual property laws.\n\n'
                       'You may not reproduce, distribute, modify, create derivative works of, publicly display, or otherwise use any of our intellectual property without our prior written consent.',
            ),
            
            // Disclaimer of Warranties
            _buildSection(
              title: 'Disclaimer of Warranties',
              content: 'THE APP AND ALL SERVICES ARE PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.\n\n'
                       'We do not guarantee that the App will be uninterrupted, secure, or error-free. We make no warranty regarding the quality, accuracy, timeliness, truthfulness, completeness, or reliability of any content available through the App.',
            ),
            
            // Limitation of Liability
            _buildSection(
              title: 'Limitation of Liability',
              content: 'TO THE MAXIMUM EXTENT PERMITTED BY LAW, SOLCARE TECHNOLOGIES PVT. LTD. SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING LOSS OF PROFITS, DATA, OR GOODWILL, ARISING OUT OF OR IN CONNECTION WITH YOUR ACCESS TO OR USE OF, OR INABILITY TO ACCESS OR USE, THE APP.\n\n'
                       'In no event shall our total liability to you for all claims exceed the amount you paid to us, if any, during the six (6) months preceding the event giving rise to the liability.',
            ),
            
            // Indemnification
            _buildSection(
              title: 'Indemnification',
              content: 'You agree to defend, indemnify, and hold harmless SolCare Technologies Pvt. Ltd., its officers, directors, employees, and agents, from and against any claims, liabilities, damages, losses, and expenses, including reasonable attorneys\' fees, arising out of or in any way connected with your access to or use of the App or your violation of these Terms.',
            ),
            
            // Termination
            _buildSection(
              title: 'Termination',
              content: 'We may terminate or suspend your account and access to the App immediately, without prior notice or liability, for any reason, including but not limited to a breach of these Terms.\n\n'
                       'Upon termination, your right to use the App will cease immediately. All provisions of these Terms which by their nature should survive termination shall survive, including without limitation, ownership provisions, warranty disclaimers, indemnity, and limitations of liability.',
            ),
            
            // Governing Law
            _buildSection(
              title: 'Governing Law',
              content: 'These Terms shall be governed by and construed in accordance with the laws of India, without regard to its conflict of law provisions.\n\n'
                       'Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable, the remaining provisions will remain in effect.',
            ),
            
            // Changes to Terms
            _buildSection(
              title: 'Changes to Terms',
              content: 'We reserve the right to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.\n\n'
                       'By continuing to access or use our App after those revisions become effective, you agree to be bound by the revised terms.',
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
              'If you have any questions about these Terms, please contact us at:',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('Email'),
              subtitle: const Text('legal@solcare.com'),
              onTap: () {
                Clipboard.setData(const ClipboardData(text: 'legal@solcare.com'));
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
            
            // Download full terms
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading full terms and conditions...')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Full Terms (PDF)'),
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
                    'By using our app, you acknowledge that you have read and agree to these Terms and Conditions.',
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

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }
}
