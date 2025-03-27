import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _queryController = TextEditingController();
  bool _isTyping = false;
  
  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        children: [
          // Support options grid
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How can we help you?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildSupportOptionCard(
                      context: context,
                      title: 'Chat Support',
                      description: 'Chat with our support team',
                      iconData: Icons.chat,
                      color: Colors.blue,
                      onTap: _showChatDialog,
                    ),
                    _buildSupportOptionCard(
                      context: context,
                      title: 'Call Us',
                      description: 'Speak with customer service',
                      iconData: Icons.call,
                      color: Colors.green,
                      onTap: () {
                        launchUrl(Uri.parse('tel:+918007652273'));
                      },
                    ),
                    _buildSupportOptionCard(
                      context: context,
                      title: 'Email Support',
                      description: 'Send us an email',
                      iconData: Icons.email,
                      color: Colors.orange,
                      onTap: () {
                        launchUrl(Uri.parse('mailto:support@solcare.com'));
                      },
                    ),
                    _buildSupportOptionCard(
                      context: context,
                      title: 'Video Guide',
                      description: 'Watch tutorial videos',
                      iconData: Icons.video_library,
                      color: Colors.red,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Video guides coming soon')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // FAQs
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          _buildFaqItem(
            question: 'How do I book a service?',
            answer: 'You can book a service by going to the Services tab, selecting your desired service, and following the booking process. Alternatively, you can call our customer service number for assistance.',
          ),
          
          _buildFaqItem(
            question: 'How often should I clean my solar panels?',
            answer: 'For optimal performance, we recommend cleaning your solar panels every 3-4 months. However, this may vary based on your location, weather conditions, and surrounding environment.',
          ),
          
          _buildFaqItem(
            question: 'What payment methods do you accept?',
            answer: 'We accept all major credit/debit cards, UPI payments, net banking, and wallet payments. For subscription plans, you can also set up auto-debit.',
          ),
          
          _buildFaqItem(
            question: 'How do I cancel or reschedule a service?',
            answer: 'You can cancel or reschedule a service up to 24 hours before the scheduled time by going to the Bookings section, selecting the booking, and choosing the appropriate option.',
          ),
          
          _buildFaqItem(
            question: 'Do you provide emergency services?',
            answer: 'Yes, we provide emergency services for critical issues. Premium plan members receive priority emergency service, while others can access emergency services at standard rates.',
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton(
              onPressed: () {
                // View more FAQs
              },
              child: const Text('View More FAQs'),
            ),
          ),
          
          const Divider(),
          
          // Contact information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.call,
                  title: 'Phone',
                  value: '+91 800-SOLCARE',
                  onTap: () {
                    Clipboard.setData(const ClipboardData(text: '+918007652273'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phone number copied to clipboard')),
                    );
                  },
                ),
                _buildContactItem(
                  icon: Icons.email,
                  title: 'Email',
                  value: 'support@solcare.com',
                  onTap: () {
                    Clipboard.setData(const ClipboardData(text: 'support@solcare.com'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email address copied to clipboard')),
                    );
                  },
                ),
                _buildContactItem(
                  icon: Icons.access_time,
                  title: 'Working Hours',
                  value: 'Mon-Sat: 9:00 AM - 6:00 PM',
                  onTap: null,
                ),
                _buildContactItem(
                  icon: Icons.location_on,
                  title: 'Head Office',
                  value: 'SolCare Tower, Green Energy Road, Delhi',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening maps...')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOptionCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData iconData,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(Icons.content_copy, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showChatDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.support_agent, color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chat Support',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'We\'ll connect you with an agent',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    // Mock chat
                    const Text(
                      'Hello! Welcome to SolCare Support. How can I assist you today?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_isTyping)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _queryController.text,
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Text input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _queryController,
                            decoration: const InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {
                                _isTyping = text.isNotEmpty;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Send message
                            String message = _queryController.text;
                            if (message.isNotEmpty) {
                              _queryController.clear();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Your message "$message" has been sent. An agent will respond shortly.')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
