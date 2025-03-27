import 'package:flutter/material.dart';

class QuickQuestionButton extends StatelessWidget {
  final String question;
  final VoidCallback onTap;
  
  const QuickQuestionButton({
    super.key,
    required this.question,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade50,
          ),
          child: Text(
            question,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
