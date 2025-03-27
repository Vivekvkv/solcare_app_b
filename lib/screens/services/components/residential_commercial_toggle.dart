import 'package:flutter/material.dart';

class ResidentialCommercialToggle extends StatelessWidget {
  final bool isResidential;
  final Function(bool) onToggled;

  const ResidentialCommercialToggle({
    super.key,
    required this.isResidential,
    required this.onToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onToggled(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isResidential
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            color: isResidential ? Colors.white : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Residential',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isResidential ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onToggled(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isResidential
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.business,
                            color: !isResidential ? Colors.white : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Commercial',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: !isResidential ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
