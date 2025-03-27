import 'package:flutter/material.dart';
import 'dart:math';

class ROICalculator extends StatefulWidget {
  const ROICalculator({super.key});

  @override
  State<ROICalculator> createState() => _ROICalculatorState();
}

class _ROICalculatorState extends State<ROICalculator> {
  // Controllers for input fields
  final TextEditingController systemCostController = TextEditingController();
  final TextEditingController systemSizeController = TextEditingController();
  final TextEditingController electricityCostController = TextEditingController();
  final TextEditingController annualConsumptionController = TextEditingController();
  final TextEditingController annualMaintenanceController = TextEditingController(text: '100');
  
  // Dropdown values
  int _systemLifetime = 25;
  double _solarCoveragePercentage = 80;
  double _electricityPriceInflation = 3.0;
  
  // Results
  double paybackPeriod = 0.0;
  double roiPercentage = 0.0;
  double annualSavings = 0.0;
  double lifetimeSavings = 0.0;
  bool _showResults = false;
  
  // Options for dropdowns
  final List<int> _lifetimeOptions = [20, 25, 30, 35];
  final List<double> _coverageOptions = [50, 60, 70, 80, 90, 100];
  final List<double> _inflationOptions = [1.0, 2.0, 3.0, 4.0, 5.0];

  void _calculateROI() {
    // Get values from input fields
    double systemCost = double.tryParse(systemCostController.text) ?? 0.0;
    double systemSize = double.tryParse(systemSizeController.text) ?? 0.0;
    double electricityCost = double.tryParse(electricityCostController.text) ?? 0.0;
    double annualConsumption = double.tryParse(annualConsumptionController.text) ?? 0.0;
    double annualMaintenance = double.tryParse(annualMaintenanceController.text) ?? 100.0;
    
    // Validate inputs
    if (systemCost <= 0 || systemSize <= 0 || electricityCost <= 0 || annualConsumption <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values for all fields'))
      );
      return;
    }
    
    // Calculate average daily solar production (using 4 hours of peak sun as average)
    double dailyProduction = systemSize * 4.0; // kWh per day
    double annualProduction = dailyProduction * 365; // kWh per year
    
    // Apply solar coverage percentage
    double actualProduction = annualProduction * (_solarCoveragePercentage / 100);
    
    // Cap production at consumption
    double usefulProduction = min(actualProduction, annualConsumption);
    
    // Calculate annual savings
    annualSavings = usefulProduction * electricityCost / 100; // Convert cents to dollars if needed
    
    // Calculate lifetime savings (accounting for inflation and maintenance)
    lifetimeSavings = 0;
    for (int year = 1; year <= _systemLifetime; year++) {
      // Apply electricity price inflation for this year
      double inflatedElectricityCost = electricityCost * 
          pow((1 + _electricityPriceInflation / 100), year);
      
      // Calculate savings for this year
      double yearSavings = usefulProduction * inflatedElectricityCost / 100;
      
      // Subtract maintenance costs
      yearSavings -= annualMaintenance;
      
      // Add to lifetime savings
      lifetimeSavings += yearSavings;
    }
    
    // Calculate ROI percentage
    roiPercentage = (lifetimeSavings - systemCost) / systemCost * 100;
    
    // Calculate simple payback period (years)
    paybackPeriod = systemCost / annualSavings;
    
    setState(() {
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar ROI Calculator'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Input Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // System Cost
            TextField(
              controller: systemCostController,
              decoration: const InputDecoration(
                labelText: 'Total System Cost (\$)',
                border: OutlineInputBorder(),
                hintText: 'e.g., 15000',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            
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
            
            // Electricity Cost
            TextField(
              controller: electricityCostController,
              decoration: const InputDecoration(
                labelText: 'Electricity Cost (cents/kWh)',
                border: OutlineInputBorder(),
                hintText: 'e.g., 12.5',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            
            // Annual Consumption
            TextField(
              controller: annualConsumptionController,
              decoration: const InputDecoration(
                labelText: 'Annual Electricity Consumption (kWh)',
                border: OutlineInputBorder(),
                hintText: 'e.g., 9000',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            
            // Annual Maintenance
            TextField(
              controller: annualMaintenanceController,
              decoration: const InputDecoration(
                labelText: 'Annual Maintenance Cost (\$)',
                border: OutlineInputBorder(),
                hintText: 'e.g., 100',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            
            // System Lifetime Dropdown
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'System Lifetime (years)',
                border: OutlineInputBorder(),
              ),
              value: _systemLifetime,
              items: _lifetimeOptions.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value years'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _systemLifetime = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),
            
            // Solar Coverage Dropdown
            DropdownButtonFormField<double>(
              decoration: const InputDecoration(
                labelText: 'Solar Coverage of Consumption (%)',
                border: OutlineInputBorder(),
              ),
              value: _solarCoveragePercentage,
              items: _coverageOptions.map((double value) {
                return DropdownMenuItem<double>(
                  value: value,
                  child: Text('$value%'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _solarCoveragePercentage = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),
            
            // Electricity Price Inflation Dropdown
            DropdownButtonFormField<double>(
              decoration: const InputDecoration(
                labelText: 'Electricity Price Inflation (%)',
                border: OutlineInputBorder(),
              ),
              value: _electricityPriceInflation,
              items: _inflationOptions.map((double value) {
                return DropdownMenuItem<double>(
                  value: value,
                  child: Text('$value% per year'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _electricityPriceInflation = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            
            // Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateROI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Calculate ROI',
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
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Investment Results',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // ROI Percentage Visual
                    LinearProgressIndicator(
                      value: min(roiPercentage, 500) / 500, // Cap at 500% for visualization
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.blue,
                      minHeight: 15,
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'ROI: ${roiPercentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Results Details
                    Text(
                      'Payback Period: ${paybackPeriod.toStringAsFixed(1)} years',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Annual Savings: \$${annualSavings.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Lifetime Savings: \$${lifetimeSavings.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Savings After Payback: \$${(lifetimeSavings - double.parse(systemCostController.text)).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
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
