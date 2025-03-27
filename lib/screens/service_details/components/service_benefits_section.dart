import 'package:flutter/material.dart';
import 'benefit_item.dart';

class ServiceBenefitsSection extends StatelessWidget {
  const ServiceBenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Benefits',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // ✅ Added const to the BenefitItem instances
        const BenefitItem(
          icon: Icons.battery_charging_full,
          title: 'Improved Efficiency',
          description: 'Maximize your system\'s power output',
        ),
        const BenefitItem(
          icon: Icons.attach_money,
          title: 'Cost Savings',
          description: 'Reduce long-term maintenance costs',
        ),
        const BenefitItem(
          icon: Icons.update,
          title: 'Extended Lifespan',
          description: 'Prolong the life of your solar system',
        ),
      ],
    );
  }
}
