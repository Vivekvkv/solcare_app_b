import 'package:flutter/material.dart';

class ServicesFAQSection extends StatefulWidget {
  const ServicesFAQSection({super.key});

  @override
  State<ServicesFAQSection> createState() => _ServicesFAQSectionState();
}

class _ServicesFAQSectionState extends State<ServicesFAQSection> {
  // Track expanded FAQs
  final Set<int> _expandedFAQs = {};
  
  final List<Map<String, String>> _faqs = [
    {
      'question': 'What type of solar services do you offer?',
      'answer': 'We offer a comprehensive range of solar services including cleaning, inspection, repair, emergency fixes, performance optimization, protection, replacement, and other specialized services for both residential and commercial solar systems.'
    },
    {
      'question': 'How often should I clean my solar panels?',
      'answer': 'For optimal performance, we recommend cleaning your solar panels every 3-6 months, depending on your location and environmental conditions. Areas with high dust, pollen, or bird activity may require more frequent cleaning.'
    },
    {
      'question': 'What is the average service time?',
      'answer': 'Service times vary depending on the type of service and system size. Basic cleaning typically takes 1-2 hours for residential systems, while comprehensive health checks and repairs may take 2-4 hours. Emergency services are prioritized for quick response within 24 hours.'
    },
    {
      'question': 'How can I schedule a service?',
      'answer': 'You can schedule a service through our app by selecting the desired service, choosing a convenient date and time, and confirming your booking. You can also add special instructions or requirements during the booking process.'
    },
    {
      'question': 'What happens if my system needs urgent repair?',
      'answer': 'For urgent repairs, select our "Emergency Repair Services" category. These requests are prioritized, and our technicians aim to respond within 24 hours. You can track the technician\'s arrival in real-time through the app.'
    },
    {
      'question': 'Are your services available nationwide?',
      'answer': 'Currently, our services are available in major cities and surrounding areas. You can check service availability for your location by entering your pin code in the app. We\'re continuously expanding our coverage to serve more regions.'
    },
  ];

  void _toggleFAQ(int index) {
    setState(() {
      if (_expandedFAQs.contains(index)) {
        _expandedFAQs.remove(index);
      } else {
        _expandedFAQs.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          const Row(
            children: [
              Icon(Icons.question_answer),
              SizedBox(width: 8),
              Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // FAQ items
          ...List.generate(_faqs.length, (index) {
            final isExpanded = _expandedFAQs.contains(index);
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  // Question (always visible)
                  InkWell(
                    onTap: () => _toggleFAQ(index),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _faqs[index]['question']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Answer (visible only when expanded)
                  AnimatedCrossFade(
                    firstChild: const SizedBox(height: 0),
                    secondChild: Container(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0,
                      ),
                      child: Text(
                        _faqs[index]['answer']!,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            );
          }),
          
          // Additional help section
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // Navigate to help center or show more FAQs
            },
            icon: const Icon(Icons.help_outline),
            label: const Text('Visit Help Center For More Questions'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
