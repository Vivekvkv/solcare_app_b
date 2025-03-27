import 'package:solcare_app4/models/service_model.dart';

class ServicesData {
  static List<ServiceModel> getAllServices() {
    int id = 1;
    
    // Helper function to generate service models
    ServiceModel createService(String name, String category, double price, String description, double popularity) {
      return ServiceModel(
        id: (id++).toString(),
        name: name,
        category: category,
        price: price,
        description: "Professional $name service with guaranteed results. $description",
        shortDescription: description.length > 70 ? description.substring(0, 70) + '...' : description,
        image: "assets/images/service_${id-1}.jpg", // Using id-1 since we've already incremented
        popularity: popularity,
        duration: "${(id % 3) + 1} hours",
        discount: id % 10,
      );
    }
    
    return [
      // Category 1: Cleaning Services
      createService(
        'Basic Panel Cleaning (Dry & Wet)', 
        'Cleaning', 
        999.0,
        'Regular cleaning service using dry and wet methods to remove dust and debris from solar panels.',
        4.7
      ),
      createService(
        'Deep Panel Cleaning', 
        'Cleaning', 
        1499.0,
        'Intensive cleaning for heavy dust, stains, and pollution buildup on solar panels.',
        4.8
      ),
      createService(
        'Waterless Solar Panel Cleaning', 
        'Cleaning', 
        1299.0,
        'Eco-friendly cleaning method that uses no water, perfect for water-scarce regions.',
        4.6
      ),
      createService(
        'Nano Coating Protection', 
        'Cleaning', 
        2499.0,
        'Application of dust & water-resistant layer to keep panels cleaner for longer periods.',
        4.9
      ),
      
      // Category 2: Inspection & Health Check Services
      createService(
        'Complete Solar System Health Check', 
        'Inspection', 
        1599.0,
        'Thorough inspection of all components in your solar system to ensure optimal performance.',
        4.8
      ),
      createService(
        'Solar Panel Performance Testing', 
        'Inspection', 
        999.0,
        'Specialized testing to measure actual energy output and efficiency of each panel.',
        4.7
      ),
      createService(
        'Shadow & Dirt Analysis', 
        'Inspection', 
        899.0,
        'Assessment of efficiency loss due to shadows and dirt accumulation with detailed report.',
        4.5
      ),
      createService(
        'Wiring & Connection Safety Check', 
        'Inspection', 
        799.0,
        'Thorough inspection of all electrical connections to prevent hazards and ensure safety.',
        4.6
      ),
      createService(
        'Solar Inverter System Check', 
        'Inspection', 
        1099.0,
        'Detailed diagnostics and error detection for your solar inverter system.',
        4.7
      ),
      
      // Category 3: Repair & Fixing Services
      createService(
        'Solar Panel Crack or Hotspot Repair', 
        'Repair', 
        1899.0,
        'Expert repair of damaged panels, cracks, and hotspots to restore performance.',
        4.8
      ),
      createService(
        'Inverter Repair & Troubleshooting', 
        'Repair', 
        1699.0,
        'Fixing common and complex inverter issues to ensure consistent power output.',
        4.7
      ),
      createService(
        'Battery & Storage System Repair', 
        'Repair', 
        2199.0,
        'Specialized repair service for hybrid and off-grid battery storage systems.',
        4.8
      ),
      createService(
        'Wiring & Connector Replacement', 
        'Repair', 
        999.0,
        'Replacement of damaged, worn-out, or underperforming wiring and connectors.',
        4.6
      ),
      createService(
        'Short Circuit Fix & Overheating Issues', 
        'Repair', 
        1499.0,
        'Resolution of short circuits and overheating problems in your solar setup.',
        4.7
      ),
      
      // Category 4: Emergency Repair Services
      createService(
        'Power Drop or System Failure Diagnosis', 
        'Emergency', 
        1999.0,
        'Urgent diagnosis service for sudden power drops or complete system failures.',
        4.9
      ),
      createService(
        'Quick Response Repair Service', 
        'Emergency', 
        2499.0,
        'Priority emergency fixing service with technicians dispatched within hours.',
        4.9
      ),
      createService(
        'Short Circuit & Fire Hazard Prevention', 
        'Emergency', 
        1899.0,
        'Immediate intervention to prevent potential fire hazards from electrical issues.',
        4.8
      ),
      createService(
        'Post-Lightning Strike System Check', 
        'Emergency', 
        1799.0,
        'Thorough inspection and repair after lightning strikes to ensure system safety.',
        4.7
      ),
      createService(
        'Post-Storm & Heavy Rain Damage Inspection', 
        'Emergency', 
        1699.0,
        'Urgent assessment and fixing of damage caused by severe weather conditions.',
        4.7
      ),
      
      // Category 5: Performance Optimization Services
      createService(
        'Solar Panel Tilt & Angle Adjustment', 
        'Optimization', 
        1299.0,
        'Expert adjustment of panel angles to maximize energy capture throughout the year.',
        4.6
      ),
      createService(
        'Load Balancing & Power Management', 
        'Optimization', 
        1499.0,
        'Optimization of load distribution and power management for better efficiency.',
        4.7
      ),
      createService(
        'MPPT Configuration & Settings Adjustment', 
        'Optimization', 
        1199.0,
        'Fine-tuning of Maximum Power Point Tracking settings in your inverter for optimal performance.',
        4.8
      ),
      createService(
        'Inverter Firmware Update & Optimization', 
        'Optimization', 
        999.0,
        'Latest firmware updates and configuration optimization for your inverter system.',
        4.7
      ),
      
      // Category 6: Protection & Safety Services
      createService(
        'Lightning & Surge Protection Setup', 
        'Protection', 
        1699.0,
        'Installation of advanced protection systems against lightning strikes and power surges.',
        4.8
      ),
      createService(
        'Earthing & Grounding System Inspection', 
        'Protection', 
        999.0,
        'Verification and improvement of earthing systems for better safety and performance.',
        4.6
      ),
      createService(
        'Anti-Theft Security for Solar Panels', 
        'Protection', 
        1999.0,
        'Installation of security measures to prevent theft of valuable solar components.',
        4.7
      ),
      createService(
        'Animal Guard Installation', 
        'Protection', 
        1299.0,
        'Setup of pigeon nets, rodent proofing, and other animal deterrents for system protection.',
        4.5
      ),
      
      // Category 7: Replacement & Upgradation Services
      createService(
        'Old Panel Replacement with Advanced Panels', 
        'Replacement', 
        4999.0,
        'Upgrade your existing panels with latest high-efficiency models for better performance.',
        4.9
      ),
      createService(
        'Solar Inverter Replacement & Capacity Upgrade', 
        'Replacement', 
        3999.0,
        'Replace old inverters with new models offering higher capacity and better features.',
        4.8
      ),
      createService(
        'Battery Bank Replacement & Expansion', 
        'Replacement', 
        5999.0,
        'Upgrade or expand your battery storage capacity for improved energy independence.',
        4.8
      ),
      createService(
        'Upgrading Wiring & Connectors', 
        'Replacement', 
        1999.0,
        'Replace old wiring and connectors with higher efficiency models to reduce power loss.',
        4.7
      ),
      createService(
        'Adding More Solar Panels to Existing System', 
        'Replacement', 
        6999.0,
        'Expand your solar system capacity by adding additional panels to your current setup.',
        4.9
      ),
    ];
  }
}
