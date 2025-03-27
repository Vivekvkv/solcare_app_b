import 'package:flutter/material.dart';

class TreesSavedCalculator extends StatefulWidget {
  const TreesSavedCalculator({super.key});

  @override
  State<TreesSavedCalculator> createState() => _TreesSavedCalculatorState();
}

class _TreesSavedCalculatorState extends State<TreesSavedCalculator> {
  // Controllers for input fields
  final TextEditingController systemSizeController = TextEditingController();
  final TextEditingController dailyOutputController = TextEditingController();
  final TextEditingController systemAgeYearsController = TextEditingController();
  final TextEditingController systemAgeMonthsController = TextEditingController();
  
  // Results
  int treesSaved = 0;
  double carbonSaved = 0.0;
  bool _showResults = false;
  
  // Constants for calculation
  // Average mature tree absorbs about 21 kg of CO2 per year
  static const double kgCO2PerTreePerYear = 21.0;
  
  // 1 kWh of solar energy saves approximately 0.85 kg CO2 compared to grid
  static const double kgCO2PerKWh = 0.85;

  void _calculateTreesSaved() {
    // Get values from input fields
    double systemSize = double.tryParse(systemSizeController.text) ?? 0.0;
    double dailyOutput = double.tryParse(dailyOutputController.text) ?? 0.0;
    int systemAgeYears = int.tryParse(systemAgeYearsController.text) ?? 0;
    int systemAgeMonths = int.tryParse(systemAgeMonthsController.text) ?? 0;
    
    // Validate inputs
    if (systemSize <= 0 || dailyOutput <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values for system size and daily output'))
      );
      return;
    }
    
    // Convert system age to total months
    int totalMonths = (systemAgeYears * 12) + systemAgeMonths;
    
    // If no age provided, assume at least 1 month
    if (totalMonths < 1) {
      totalMonths = 1;
    }
    
    // Calculate total kWh generated over lifetime
    double totalKWh = dailyOutput * (totalMonths * 30.44); // Average days per month
    
    // Calculate total kg of CO2 saved
    carbonSaved = totalKWh * kgCO2PerKWh;
    
    // Calculate equivalent number of trees
    // (How many trees would absorb the same amount of CO2 in one year)
    treesSaved = (carbonSaved / kgCO2PerTreePerYear).round();
    
    setState(() {
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trees Saved Calculator'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate Trees Equivalent',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Find out how many trees your solar system has saved!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            // System Size
            TextField(
              controller: systemSizeController,
              decoration: const InputDecoration(
                labelText: 'System Size (kW)',
                border: OutlineInputBorder(),
                hintText: 'e.g., 5.5',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            
            // Daily Output
            TextField(
              controller: dailyOutputController,
              decoration: const InputDecoration(
                labelText: 'Average Daily Output (kWh)',
                border: OutlineInputBorder(),
                hintText: 'e.g., 22',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            
            // System Age
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: systemAgeYearsController,
                    decoration: const InputDecoration(
                      labelText: 'System Age (Years)',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., 2',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: systemAgeMonthsController,
                    decoration: const InputDecoration(
                      labelText: 'Months',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., 6',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateTreesSaved,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Calculate Trees Saved',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            // Results Section
            if (_showResults) ...[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.brown.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Environmental Impact',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    
                    // Tree Visualization
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(
                        treesSaved > 50 ? 50 : treesSaved,
                        (index) => const Icon(
                          Icons.nature,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    Text(
                      'Your solar system has saved',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '$treesSaved trees',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'That\'s equivalent to absorbing',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${carbonSaved.toStringAsFixed(1)} kg of CO₂',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Fun Fact
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Did you know?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A mature tree absorbs about 21 kg of CO₂ per year. Your solar system is doing the work of an entire forest!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.brown.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
