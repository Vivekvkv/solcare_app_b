import 'package:flutter/material.dart';
import 'faq_item.dart';

class FAQsSection extends StatelessWidget {
  final List<Map<String, String>> faqs;
  final bool showAllFAQs;
  final VoidCallback toggleShowAllFAQs;

  const FAQsSection({
    super.key,
    required this.faqs,
    required this.showAllFAQs,
    required this.toggleShowAllFAQs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...faqs.take(showAllFAQs ? faqs.length : 3).map((faq) => FAQItem(
              question: faq['question']!,
              answer: faq['answer']!,
            )),
        if (faqs.length > 3)
          TextButton(
            onPressed: toggleShowAllFAQs,
            child: Text(
              showAllFAQs ? 'Show Less' : 'View All FAQs',
            ),
          ),
      ],
    );
  }
}
