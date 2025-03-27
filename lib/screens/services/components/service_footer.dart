import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceFooter extends StatelessWidget {
  const ServiceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and tagline
          Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SolCare',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Keeping your solar shining bright',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Quick links
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    _FooterLink(text: 'About Us'),
                    SizedBox(height: 8),
                    _FooterLink(text: 'Our Team'),
                    SizedBox(height: 8),
                    _FooterLink(text: 'Careers'),
                    SizedBox(height: 8),
                    _FooterLink(text: 'Blog'),
                  ],
                ),
              ),
              
              // Services links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Services',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    _FooterLink(text: 'Cleaning'),
                    SizedBox(height: 8),
                    _FooterLink(text: 'Maintenance'),
                    SizedBox(height: 8),
                    _FooterLink(text: 'Inspection'),
                    SizedBox(height: 8),
                    _FooterLink(text: 'Repair'),
                  ],
                ),
              ),
              
              // Support links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    _FooterLink(text: 'Contact Us'),
                    SizedBox(height: 8),
                    _FooterLink(text: 'FAQs'),
                    SizedBox(height: 8),
                    _FooterLink(text: 'Terms of Service'),
                    SizedBox(height: 8),
                    _FooterLink(text: 'Privacy Policy'),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Divider
          Divider(color: Colors.grey.shade300),
          
          const SizedBox(height: 16),
          
          // Copyright
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© ${DateFormat('yyyy').format(DateTime.now())} SolCare. All rights reserved.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook, size: 20),
                    onPressed: () {},
                    color: Colors.grey.shade600,
                  ),
                  IconButton(
                    icon: const Icon(Icons.dark_mode, size: 20),
                    onPressed: () {},
                    color: Colors.grey.shade600,
                  ),
                  IconButton(
                    icon: const Icon(Icons.mail, size: 20),
                    onPressed: () {},
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;

  const _FooterLink({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the appropriate page
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
