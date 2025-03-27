import 'package:flutter/material.dart';

class SolarHealthCalculator extends StatefulWidget {
  const SolarHealthCalculator({super.key});

  @override
  State<SolarHealthCalculator> createState() => _SolarHealthCalculatorState();
}

class _SolarHealthCalculatorState extends State<SolarHealthCalculator> {
  // User Inputs for Basic Solar Health Checker
  final TextEditingController systemSizeController = TextEditingController();
  final TextEditingController initialOutputController = TextEditingController();
  final TextEditingController currentOutputController = TextEditingController();
  
  // Dropdown values
  String _lastCleaningPeriod = '0-3 months';
  String _systemAge = '0-2 years';
  String _installationType = 'Residential';
  
  // Variables to store the results
  double performanceRatio = 0.0;
  double energyLoss = 0.0;
  String recommendation = "";
  bool _showBookingOption = false;
  
  // Cleaning period options
  final List<String> _cleaningPeriods = [
    '0-3 months',
    '3-6 months',
    '6-12 months',
    'More than 12 months'
  ];
  
  // System age options
  final List<String> _systemAgeOptions = [
    '0-2 years',
    '2-5 years',
    '5-10 years',
    'More than 10 years'
  ];
  
  // Installation type options
  final List<String> _installationTypes = [
    'Residential',
    'Commercial',
    'Industrial'
  ];

  // Function to calculate Basic Solar Health
  void calculateBasicHealth() {
    double systemSize = double.tryParse(systemSizeController.text) ?? 0.0;
    double initialOutput = double.tryParse(initialOutputController.text) ?? 0.0;
    double currentOutput = double.tryParse(currentOutputController.text) ?? 0.0;
    
    // Convert string selections to numeric values for calculation
    int lastCleaningMonths = _getMonthsFromPeriod(_lastCleaningPeriod);
    int systemAgeYears = _getYearsFromAge(_systemAge);
    
    if (systemSize > 0 && initialOutput > 0) {
      // Calculate Energy Loss Percentage
      energyLoss = ((initialOutput - currentOutput) / initialOutput) * 100;

      // Calculate Performance Ratio (PR)
      performanceRatio = currentOutput / initialOutput;

      // Cleaning Impact Estimation (Dirt Losses)
      double dirtLoss = lastCleaningMonths * 0.5; // Reduced coefficient for realism
      
      // Age degradation factor (panels naturally degrade over time)
      double ageDegradation = systemAgeYears * 0.7; // Typical degradation is ~0.5-1% per year
      
      // Define recommendations based on losses, accounting for age
      _showBookingOption = false;
      
      if (energyLoss < 5 + ageDegradation) {
        recommendation = "✅ Your solar system is working efficiently.";
      } else if (energyLoss < 15 + ageDegradation) {
        recommendation = "⚠️ Consider cleaning & minor maintenance.";
        _showBookingOption = true;
      } else {
        recommendation = "🚨 Urgent check-up needed! Possible inverter failure or severe issues.";
        _showBookingOption = true;
      }

      // Suggest cleaning if dirt loss is high
      if (dirtLoss > 3) {
        recommendation += "\n🧼 Cleaning suggested due to dirt accumulation.";
        _showBookingOption = true;
      }
      
      // Add installation-specific recommendations
      if (_installationType == 'Commercial' && energyLoss > 8) {
        recommendation += "\n💼 Commercial systems require more frequent maintenance for optimal ROI.";
      } else if (_installationType == 'Industrial' && energyLoss > 5) {
        recommendation += "\n🏭 Industrial systems should maintain >95% efficiency for maximum production.";
      }
    } else {
      recommendation = "Please enter valid inputs.";
      _showBookingOption = false;
    }

    setState(() {});
  }
  
  // Helper function to convert period string to months
  int _getMonthsFromPeriod(String period) {
    switch (period) {
      case '0-3 months':
        return 2; // Average of 0-3
      case '3-6 months':
        return 4; // Average of 3-6
      case '6-12 months':
        return 9; // Average of 6-12
      case 'More than 12 months':
        return 15; // Estimate for >12
      default:
        return 0;
    }
  }
  
  // Helper function to convert age string to years
  int _getYearsFromAge(String age) {
    switch (age) {
      case '0-2 years':
        return 1; // Average of 0-2
      case '2-5 years':
        return 3; // Average of 2-5
      case '5-10 years':
        return 7; // Average of 5-10
      case 'More than 10 years':
        return 12; // Estimate for >10
      default:
        return 0;
    }
  }
  
  // Function to handle booking action
  void _bookService() {
    // Show dialog to confirm booking
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Book a Service"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Based on your solar system's performance, we recommend scheduling a maintenance service.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              "Issue detected: ${energyLoss.toStringAsFixed(1)}% energy loss",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Recommended service: ${_getRecommendedService()}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Navigate to booking screen (simplified example)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Navigating to booking page..."))
              );
              
              // In a real implementation, you would navigate to the booking screen:
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context) => BookingScreen(
              //     recommendedService: _getRecommendedService(),
              //   ),
              // ));
            },
            child: const Text("Book Now"),
          ),
        ],
      ),
    );
  }
  
  // Helper to determine which service to recommend
  String _getRecommendedService() {
    if (energyLoss > 15) {
      return "Comprehensive System Checkup";
    } else if (_getMonthsFromPeriod(_lastCleaningPeriod) > 6) {
      return "Solar Panel Cleaning";
    } else {
      return "Maintenance Inspection";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Solar Health Calculator",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Installation Type Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Installation Type",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              value: _installationType,
              items: _installationTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _installationType = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            
            // System Age Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "System Age",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              value: _systemAge,
              items: _systemAgeOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _systemAge = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            
            // User Input Fields
            TextField(
              controller: systemSizeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "System Size (kW)",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: initialOutputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Initial Output (kWh/day)",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: currentOutputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Current Output (kWh/day)",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            
            // Last Cleaning Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Last Cleaning Period",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              value: _lastCleaningPeriod,
              items: _cleaningPeriods.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _lastCleaningPeriod = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculateBasicHealth,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Calculate Solar Health"),
              ),
            ),
            const SizedBox(height: 20),
            
            if (energyLoss > 0 || recommendation.isNotEmpty)
              Card(
                color: _showBookingOption 
                    ? Colors.amber.withOpacity(0.1) 
                    : Theme.of(context).colorScheme.surface,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Performance Ratio: ${performanceRatio.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Energy Loss: ${energyLoss.toStringAsFixed(2)}%",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recommendation,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      if (_showBookingOption) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.handyman),
                            label: const Text("Book a Service"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: _bookService,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
