import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
  // Adjust path as needed

class DynamicFooter extends StatefulWidget {
  const DynamicFooter({super.key});

  @override
  _DynamicFooterState createState() => _DynamicFooterState();
}

class _DynamicFooterState extends State<DynamicFooter> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSubscribed = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubscribe() {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _isSubscribed = true;
      });
      _emailController.clear();

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _isSubscribed = false;
        });
      });
    }
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section with Company Info and Links
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildCompanyInfo(),
              _buildQuickLinks(),
              _buildContactInfo(),
              _buildNewsletter(),
            ],
          ),
          const SizedBox(height: 32),

          // Divider
          const Divider(color: Colors.grey),

          // Bottom Section with Copyright and Links
          _buildFooterBottom(),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.wb_sunny, color: Colors.yellow, size: 24),
            SizedBox(width: 8),
            Text(
              'SolCare',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Professional solar panel maintenance services to maximize your investment and extend the life of your system.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.grey, size: 18),
              onPressed: () => _launchURL('https://facebook.com'),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.grey, size: 18),
              onPressed: () => _launchURL('https://twitter.com'),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.grey, size: 18),
              onPressed: () => _launchURL('https://instagram.com'),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.youtube, color: Colors.grey, size: 18),
              onPressed: () => _launchURL('https://youtube.com'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickLinks() {
    List<Map<String, String>> links = [
      {'name': 'About Us', 'url': '#'},
      {'name': 'Services', 'url': '#'},
      {'name': 'Pricing', 'url': '#'},
      {'name': 'Testimonials', 'url': '#'},
      {'name': 'FAQs', 'url': '#'},
      {'name': 'Terms & Conditions', 'url': '#'},
      {'name': 'Privacy Policy', 'url': '#'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Links',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        ...links.map((link) => GestureDetector(
              onTap: () => _launchURL(link['url']!),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.chevron_right, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      link['name']!,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Us',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        _buildContactItem(Icons.location_on, 'PoloGround , Industrial Area, Indore'),
        _buildContactItem(Icons.phone, '(+91) 8818880540'),
        _buildContactItem(Icons.email, 'info@solcare.co.in'),
        _buildContactItem(Icons.access_time, 'Mon-Fri: 8AM-6PM'),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNewsletter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Newsletter',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Your email address',
            hintStyle: const TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_right, color: Colors.blue),
              onPressed: _handleSubscribe,
            ),
            filled: true,
            fillColor: Colors.grey[800],
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        if (_isSubscribed)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Thank you for subscribing!',
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildFooterBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '© ${DateFormat('yyyy').format(DateTime.now())} SolCare. All rights reserved.',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Row(
          children: [
            _buildFooterLink('Sitemap'),
            _buildFooterLink('Careers'),
            _buildFooterLink('Blog'),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: GestureDetector(
        onTap: () => _launchURL('#'),
        child: Text(text, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
