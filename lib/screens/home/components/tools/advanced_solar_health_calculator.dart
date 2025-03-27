import 'package:flutter/material.dart';

class AdvancedSolarHealthCalculator extends StatefulWidget {
  const AdvancedSolarHealthCalculator({super.key});

  @override
  State<AdvancedSolarHealthCalculator> createState() => _AdvancedSolarHealthCalculatorState();
}

class _AdvancedSolarHealthCalculatorState extends State<AdvancedSolarHealthCalculator> {
  // User Inputs
  final TextEditingController systemSizeController = TextEditingController();
  final TextEditingController initialOutputController = TextEditingController();
  final TextEditingController currentOutputController = TextEditingController();
  final TextEditingController inverterEfficiencyController = TextEditingController(text: '97');
  final TextEditingController panelTemperatureController = TextEditingController();
  
  // Dropdown values
  String _lastCleaningPeriod = '0-3 months';
  String _systemAge = '0-2 years';
  String _installationType = 'Residential';
  String _shadingLevel = 'None';
  
  // Result variables
  double performanceRatio = 0.0;
  double energyLoss = 0.0;
  String recommendation = "";
  bool _showResults = false;
  
  // Dropdown options
  final List<String> _cleaningPeriods = [
    '0-3 months',
    '3-6 months',
    '6-12 months',
    'More than 12 months'
  ];
  
  final List<String> _systemAgeOptions = [
    '0-2 years',
    '2-5 years',
    '5-10 years',
    'More than 10 years'
  ];
  
  final List<String> _installationTypes = [
    'Residential',
    'Commercial',
    'Industrial'
  ];

  final List<String> _shadingLevels = [
    'None',
    'Light',
    'Moderate',
    'Heavy'
  ];

  // Helper functions for calculation
  int _getMonthsFromPeriod(String period) {
    switch (period) {
      case '0-3 months': return 2;
      case '3-6 months': return 4;
      case '6-12 months': return 9;
      case 'More than 12 months': return 15;
      default: return 0;
    }
  }

  int _getYearsFromAge(String age) {
    switch (age) {
      case '0-2 years': return 1;
      case '2-5 years': return 3;
      case '5-10 years': return 7;
      case 'More than 10 years': return 12;
      default: return 0;
    }
  }

  double _getShadingFactor(String level) {
    switch (level) {
      case 'None': return 1.0;
      case 'Light': return 0.9;
      case 'Moderate': return 0.8;
      case 'Heavy': return 0.6;
      default: return 1.0;
    }
  }

  void _calculateHealth() {
    // Get inputs
    double systemSize = double.tryParse(systemSizeController.text) ?? 0.0;
    double initialOutput = double.tryParse(initialOutputController.text) ?? 0.0;
    double currentOutput = double.tryParse(currentOutputController.text) ?? 0.0;
    double inverterEfficiency = double.tryParse(inverterEfficiencyController.text) ?? 97;
    double panelTemperature = double.tryParse(panelTemperatureController.text) ?? 25;
    
    // Convert string selections to numeric values
    int lastCleaningMonths = _getMonthsFromPeriod(_lastCleaningPeriod);
    int systemAgeYears = _getYearsFromAge(_systemAge);
    double shadingFactor = _getShadingFactor(_shadingLevel);
    
    if (systemSize > 0 && initialOutput > 0 && currentOutput > 0) {
      // Calculate Performance Ratio (PR)
      performanceRatio = (currentOutput / initialOutput) * 100;
      
      // Calculate Energy Loss Percentage
      energyLoss = 100 - performanceRatio;
      
      // Temperature factor
      double temperatureFactor = 1.0;
      if (panelTemperature > 25) {
        // Typically panels lose about 0.4% efficiency per degree C above 25°C
        temperatureFactor = 1.0 - ((panelTemperature - 25) * 0.004);
      }
      
      // Age degradation (panels typically degrade about 0.5-1% per year)
      double ageFactor = 1.0 - (systemAgeYears * 0.007);
      
      // Calculate expected performance considering all factors
      double expectedPerformance = initialOutput * ageFactor * temperatureFactor * 
                                  (inverterEfficiency / 100) * shadingFactor;
      
      // Determine maintenance recommendation
      if (performanceRatio < 70) {
        recommendation = "Urgent maintenance required. Schedule a professional inspection.";
      } else if (performanceRatio < 85) {
        recommendation = "Maintenance recommended. System is underperforming.";
      } else if (lastCleaningMonths > 6) {
        recommendation = "Schedule cleaning to maintain optimal performance.";
      } else {
        recommendation = "System is performing well. Continue regular maintenance.";
      }
      
      setState(() {
        _showResults = true;
      });
    } else {
      // Show error message if inputs are invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values for all fields'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Solar Health Calculator'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Your System Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            
            // Initial Output
            TextField(
              controller: initialOutputController,
              decoration: const InputDecoration(
                labelText: 'Initial Output (kWh/day)',
                border: OutlineInputBorder(),
                hintText: 'When system was new',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            
            // Current Output
            TextField(
              controller: currentOutputController,
              decoration: const InputDecoration(
                labelText: 'Current Output (kWh/day)',
                border: OutlineInputBorder(),
                hintText: 'Current daily production',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            
            // Panel Temperature
            TextField(
              controller: panelTemperatureController,
              decoration: const InputDecoration(
                labelText: 'Average Panel Temperature (°C)',
                border: OutlineInputBorder(),
                hintText: 'e.g., 30',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            
            // Inverter Efficiency
            TextField(
              controller: inverterEfficiencyController,
              decoration: const InputDecoration(
                labelText: 'Inverter Efficiency (%)',
                border: OutlineInputBorder(),
                hintText: 'Usually 95-98%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            
            // Dropdown for Last Cleaning
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Last Cleaning',
                border: OutlineInputBorder(),
              ),
              value: _lastCleaningPeriod,
              items: _cleaningPeriods.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _lastCleaningPeriod = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),
            
            // Dropdown for System Age
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'System Age',
                border: OutlineInputBorder(),
              ),
              value: _systemAge,
              items: _systemAgeOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _systemAge = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),
            
            // Dropdown for Installation Type
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Installation Type',
                border: OutlineInputBorder(),
              ),
              value: _installationType,
              items: _installationTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _installationType = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),
            
            // Dropdown for Shading Level
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Shading Level',
                border: OutlineInputBorder(),
              ),
              value: _shadingLevel,
              items: _shadingLevels.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _shadingLevel = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            
            // Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateHealth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Calculate Health',
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
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'System Health Results',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // Performance Gauge
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 100,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.yellow, Colors.green],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100),
                                topRight: Radius.circular(100),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 60,
                              width: 4,
                              color: Colors.black,
                              margin: EdgeInsets.only(
                                left: (performanceRatio / 100) * 200 - 100
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: Text(
                              '${performanceRatio.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Results Details
                    Text(
                      'Performance Ratio: ${performanceRatio.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Energy Loss: ${energyLoss.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Recommendation:',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      recommendation,
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
