import 'package:flutter/material.dart';

class EmergencySupportBar extends StatelessWidget {
  const EmergencySupportBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: ElevatedButton.icon(
        onPressed: () {
          // Show mock emergency contact
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Emergency Contact'),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.red),
                    title: Text('Emergency Helpline'),
                    subtitle: Text('+91 1800-SOL-CARE'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.blue),
                    title: Text('Email Support'),
                    subtitle: Text('emergency@solcare.com'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.phone),
                  label: const Text('Call Now'),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling emergency helpline...')),
                    );
                  },
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.emergency),
        label: const Text('Emergency Support'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
