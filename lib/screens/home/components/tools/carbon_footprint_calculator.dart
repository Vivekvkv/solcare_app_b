import 'package:flutter/material.dart';

class CarbonFootprintCalculator extends StatefulWidget {
  const CarbonFootprintCalculator({super.key});

  @override
  State<CarbonFootprintCalculator> createState() => _CarbonFootprintCalculatorState();
}

class _CarbonFootprintCalculatorState extends State<CarbonFootprintCalculator> {
  // Controllers for input fields
  final TextEditingController systemSizeController = TextEditingController();
  final TextEditingController monthlyOutputController = TextEditingController();
  final TextEditingController systemAgeYearsController = TextEditingController();
  final TextEditingController systemAgeMonthsController = TextEditingController();
  
  // Dropdown value
  String _regionEmissionFactor = 'Average';
  
  // Results
  double totalCO2Saved = 0.0;
  int carMilesEquivalent = 0;
  int flightsEquivalent = 0;
  bool _showResults = false;
  
  // Constants for calculation
  static const Map<String, double> emissionFactors = {
    'Average': 0.85, // kg CO2 per kWh
    'Coal Heavy': 1.1,
    'Natural Gas Heavy': 0.7,
    'Low Carbon Mix': 0.4,
  };
  
  // Car emissions: average passenger vehicle emits about 404 grams CO2 per mile
  static const double kgCO2PerMile = 0.404;
  
  // Flight emissions: avg domestic flight emits about 0.15 kg CO2 per kilometer
  // For a 1000km flight, that's about 150 kg CO2
  static const double kgCO2PerFlight = 150.0;
  
  // List of regions
  final List<String> _regions = [
    'Average',
    'Coal Heavy',
    'Natural Gas Heavy',
    'Low Carbon Mix'
  ];

  void _calculateCarbonFootprint() {
    // Get values from input fields
    double systemSize = double.tryParse(systemSizeController.text) ?? 0.0;
    double monthlyOutput = double.tryParse(monthlyOutputController.text) ?? 0.0;
    int systemAgeYears = int.tryParse(systemAgeYearsController.text) ?? 0;
    int systemAgeMonths = int.tryParse(systemAgeMonthsController.text) ?? 0;
    
    // Validate inputs
    if (systemSize <= 0 || monthlyOutput <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values for system size and monthly output'))
      );
      return;
    }
    
    // Get emission factor for selected region
    double emissionFactor = emissionFactors[_regionEmissionFactor] ?? 0.85;
    
    // Calculate total months the system has been operating
    int totalMonths = (systemAgeYears * 12) + systemAgeMonths;
    if (totalMonths < 1) totalMonths = 1;
    
    // Calculate total kWh generated
    double totalKWh = monthlyOutput * totalMonths;
    
    // Calculate total CO2 saved (kg)
    totalCO2Saved = totalKWh * emissionFactor;
    
    // Calculate equivalents
    carMilesEquivalent = (totalCO2Saved / kgCO2PerMile).round();
    flightsEquivalent = (totalCO2Saved / kgCO2PerFlight).round();
    
    setState(() {
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Footprint Calculator'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate Your Carbon Savings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Discover your impact on reducing carbon emissions',
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
            
            // Monthly Output
            TextField(
              controller: monthlyOutputController,
              decoration: const InputDecoration(
                labelText: 'Average Monthly Output (kWh)',
                border: OutlineInputBorder(),
                hintText: 'e.g., 650',
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
            const SizedBox(height: 12),
            
            // Region Selection
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Grid Region',
                border: OutlineInputBorder(),
              ),
              value: _regionEmissionFactor,
              items: _regions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _regionEmissionFactor = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            
            // Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateCarbonFootprint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Calculate Carbon Savings',
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
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Your Climate Impact',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    
                    // CO2 Saved
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.green, width: 3),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.co2,
                            color: Colors.green,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${totalCO2Saved.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text(
                            'kg CO₂ Saved',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    const Text(
                      'That\'s equivalent to:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    
                    // Car miles equivalent
                    Row(
                      children: [
                        const Icon(Icons.directions_car, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$carMilesEquivalent',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Miles not driven'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Flights equivalent
                    Row(
                      children: [
                        const Icon(Icons.airplanemode_active, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$flightsEquivalent',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('One-way flights avoided (1000km)'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Impact message
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Your Contribution',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'By generating clean energy with your solar system, you\'ve made a significant contribution to fighting climate change!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade800,
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
