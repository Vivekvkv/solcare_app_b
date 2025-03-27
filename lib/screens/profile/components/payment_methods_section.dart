import 'package:flutter/material.dart';

class PaymentMethodsSection extends StatelessWidget {
  final List<String> paymentMethods;

  const PaymentMethodsSection({
    super.key,
    required this.paymentMethods,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add New'),
              onPressed: () {
                // Show add payment method dialog
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...paymentMethods.map((method) {
          IconData icon = method.contains('@')
              ? Icons.account_balance_wallet
              : Icons.credit_card;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(icon),
              title: Text(method),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  // Delete payment method
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
