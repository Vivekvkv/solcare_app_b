import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/screens/more/sections/subscription_screen.dart';
import 'package:solcare_app4/screens/payment/payment_screen.dart';

class SubscriptionPlansSection extends StatefulWidget {
  const SubscriptionPlansSection({super.key});

  @override
  State<SubscriptionPlansSection> createState() => _SubscriptionPlansSectionState();
}

class _SubscriptionPlansSectionState extends State<SubscriptionPlansSection> {
  bool _isAnnual = true;
  String _systemCategory = 'Residential'; // Default system category
  double _systemSizeKW = 5.0; // Default system size in KW
  final TextEditingController _systemSizeController = TextEditingController(text: '5.0');
  Map<String, dynamic>? _selectedPlan;

  final List<String> _systemCategories = ['Residential', 'Commercial', 'Industrial'];

  // Plan details with features and pricing for different system categories
  final Map<String, List<Map<String, dynamic>>> _subscriptionPlans = {
    'Residential': [
      {
        'name': 'Basic Care',
        'description': 'Essential maintenance for home solar setups',
        'features': ['Basic Cleaning', 'Cleaning Frequency: Bi-Annually (2 times a year)', 'Standard Maintenance Checks: Once a year', 'Phone Call Support'],
        'pricePerKW': 800,
        'color': Colors.blue.shade100,
        'textColor': Colors.blue.shade800,
      },
      {
        'name': 'Standard Care',
        'description': 'Comprehensive care for optimal performance',
        'features': ['Deep Cleaning', 'Cleaning Frequency: Quarterly (4 times a year)', 'Standard Maintenance Checks: 4 times a year', 
        '5% discount on emergency extra services', 'Energy-Saving Tips & Consultation', ' Phone Call Support '],
        'pricePerKW': 1200,
        'color': Colors.green.shade100,
        'textColor': Colors.green.shade700,
      },
      {
        'name': 'Premium Care',
        'description': 'Complete protection for your home system',
        'features': ['Advanced Deep Cleaning', 'Cleaning Frequency: Monthly (12 times a year)', 'Standard Maintenance Checks: 12 times a year', '8% discount on emergency extra services',
         'Energy-Saving Tips & Consultation', 'Smart Home Energy Monitoring Integration', 'Phone Call & At-Home Support'],
        'pricePerKW': 2000,
        'color': Colors.purple.shade100,
        'textColor': Colors.purple.shade700,
      },
      {
        'name': 'Family Plus',
        'description': 'Ideal for family homes with extended coverage',
        'features': ['Advanced Deep Cleaning', 'Cleaning Frequency: Every 15 Days (24 times a year)', 'Standard Maintenance Checks: 24 times a year', '10% discount on emergency extra services',
         'Energy-Saving Tips & Consultation', 'Smart Home Energy Monitoring Integration', 'Personalized Energy Efficiency Audit', 'Phone Call & At-Home Support'],
        'pricePerKW': 2500,
        'color': Colors.orange.shade100,
        'textColor': Colors.orange.shade800,
      },
    ],
    'Commercial': [
      {
        'name': 'Business Care',
        'description': 'Professional maintenance for commercial installations',
        'features': ['Monthly Inspection', 'Commercial Cleaning', 'Dedicated Support Line', 'Performance Analytics'],
        'pricePerKW': 800,
        'color': Colors.teal.shade100,
        'textColor': Colors.teal.shade800,
      },
      {
        'name': 'Enterprise Care',
        'description': 'Comprehensive solution for business operations',
        'features': ['Bi-weekly Inspection', 'Advanced Cleaning', 'Priority Support', 'Real-time Monitoring', 'Repairs Included', 'Quarterly Reports'],
        'pricePerKW': 1200,
        'color': Colors.indigo.shade100,
        'textColor': Colors.indigo.shade700,
      },
      {
        'name': 'Professional Plus',
        'description': 'Enhanced service for demanding businesses',
        'features': ['Weekly Inspection', 'Premium Cleaning', '24/7 Support', 'Performance Optimization', 'Parts Coverage', 'Emergency Response'],
        'pricePerKW': 2000,
        'color': Colors.pink.shade100,
        'textColor': Colors.pink.shade700,
      },
      {
        'name': 'Corporate Value',
        'description': 'Cost-effective for essential business maintenance',
        'features': ['Monthly Inspection', 'Standard Cleaning', 'Professional Support', 'Energy Monitoring', 'Quarterly Business Reviews'],
        'pricePerKW': 2500,
        'color': Colors.amber.shade100,
        'textColor': Colors.amber.shade800,
      },
    ],
    'Industrial': [
      {
        'name': 'Industrial Care',
        'description': 'Heavy-duty maintenance for industrial installations',
        'features': ['Weekly Inspection', 'Industrial Cleaning', 'Dedicated Support Team', 'Advanced Analytics', 'Custom Reporting'],
        'pricePerKW': 800,
        'color': Colors.deepPurple.shade100,
        'textColor': Colors.deepPurple.shade800,
      },
      {
        'name': 'Manufacturing Plus',
        'description': 'Specialized care for production facilities',
        'features': ['Bi-weekly Inspection', 'Heavy-duty Cleaning', 'Dedicated Account Manager', 'Efficiency Reports', 'Emergency Repairs', '24/7 Monitoring'],
        'pricePerKW': 1200,
        'color': Colors.cyan.shade100,
        'textColor': Colors.cyan.shade800,
      },
      {
        'name': 'Industrial Premium',
        'description': 'All-inclusive solution for critical operations',
        'features': ['On-demand Inspection', 'Premium Industrial Cleaning', 'Executive Support', 'Real-time Analytics', 'Full Parts Coverage', 'Immediate Response Team'],
        'pricePerKW': 2000,
        'color': Colors.red.shade100,
        'textColor': Colors.red.shade800,
      },
      {
        'name': 'Enterprise Elite',
        'description': 'Ultimate protection for large industrial systems',
        'features': ['Weekly Inspection', 'Custom Cleaning Protocol', 'Dedicated Team', 'Custom Analytics', 'Complete Coverage', 'Strategic Support'],
        'pricePerKW': 2500,
        'color': Colors.lightGreen.shade100,
        'textColor': Colors.lightGreen.shade800,
      },
    ],
  };

  // Annual discount rates for each category
  final Map<String, double> _annualDiscountRates = {
    'Residential': 0.10, // 10% discount
    'Commercial': 0.08,  // 8% discount
    'Industrial': 0.05,  // 5% discount
  };

  @override
  void initState() {
    super.initState();
    _systemSizeController.text = _systemSizeKW.toString();
  }

  @override
  void dispose() {
    _systemSizeController.dispose();
    super.dispose();
  }

  // Calculate price based on system size in KW
  double calculatePrice(Map<String, dynamic> plan, bool isAnnual) {
    final double basePrice = plan['pricePerKW'] * _systemSizeKW;
    
    if (isAnnual) {
      // Apply category-specific discount for annual billing
      final double discountRate = _annualDiscountRates[_systemCategory]!;
      final double monthlyPrice = basePrice;
      final double annualPrice = monthlyPrice * 12;
      final double discountedPrice = annualPrice * (1 - discountRate);
      return discountedPrice;
    } else {
      // Monthly price without discount
      return basePrice;
    }
  }

  // Get discount percentage for the current category
  int getCategoryDiscount() {
    return (_annualDiscountRates[_systemCategory]! * 100).round();
  }

  // Navigate to detailed subscription screen
  void _navigateToSubscriptionDetails(BuildContext context, Map<String, dynamic> selectedPlan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionScreen(
          initialSelectedPlan: selectedPlan['name'],
          systemCategory: _systemCategory,
          systemSizeKW: _systemSizeKW,
        ),
      ),
    );
  }
  
  // Navigate to payment screen
  void _navigateToPayment(BuildContext context, Map<String, dynamic> plan) {
    final price = calculatePrice(plan, _isAnnual);
    final billingCycle = _isAnnual ? 'Annual' : 'Monthly';
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          title: 'Subscribe to ${plan['name']}',
          amount: price,
          description: '${plan['name']} Subscription - $billingCycle',
          onSuccess: (transactionId) {
            // Update the user's subscription after successful payment
            final DateTime expiryDate = DateTime.now().add(
              _isAnnual ? const Duration(days: 365) : const Duration(days: 30)
            );
            
            Provider.of<ProfileProvider>(context, listen: false).updateSubscription(
              plan['name'],
              expiryDate,
            );
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully subscribed to ${plan['name']}!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          itemDetails: [
            {'label': 'Plan', 'value': plan['name']},
            {'label': 'Category', 'value': _systemCategory},
            {'label': 'System Size', 'value': '${_systemSizeKW.toStringAsFixed(1)} KW'},
            {'label': 'Billing Cycle', 'value': billingCycle},
            if (_isAnnual) {'label': 'Discount', 'value': '${getCategoryDiscount()}%'},
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final currentPlans = _subscriptionPlans[_systemCategory]!;
    
    // Get screen size for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // Set minimum height to ensure consistent spacing
          minHeight: 300,
          // Set maximum height to prevent overflow
          maxHeight: isSmallScreen ? 520 : 480,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and description
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Subscription Plans',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubscriptionScreen(
                            systemCategory: _systemCategory,
                            initialSelectedPlan: _selectedPlan?['name'],
                            systemSizeKW: _systemSizeKW,
                          ),
                        ),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Choose a maintenance plan that fits your solar system needs',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 12),
              
              // Responsive controls layout
              _buildResponsiveControls(isSmallScreen),
              
              const SizedBox(height: 12),
              
              // Selected plan widget if a plan is selected - with reduced spacing
              if (_selectedPlan != null)
                _buildSelectedPlanWidget(context, _selectedPlan!, isSmallScreen),
              
              const SizedBox(height: 12),
              
              // Flexible container for the plans carousel to expand/shrink as needed
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currentPlans.length,
                  itemBuilder: (context, index) {
                    final plan = currentPlans[index];
                    final price = calculatePrice(plan, _isAnnual);
                    final discount = _isAnnual ? getCategoryDiscount() : 0;
                    final isSelected = _selectedPlan != null && _selectedPlan!['name'] == plan['name'];
                    
                    return Container(
                      width: isSmallScreen ? screenSize.width * 0.75 : 220, // Responsive width
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: plan['color'],
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected 
                            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2.5)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plan header - with reduced padding
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: plan['textColor'],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        plan['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  plan['description'],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          
                          // Content with scrollable area if needed
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Price section - with more compact layout
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '₹${price.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: plan['textColor'],
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        _isAnnual ? '/year' : '/month',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_isAnnual && discount > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      margin: const EdgeInsets.only(top: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Save $discount%',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Features list - show all features with scroll if needed
                                  SizedBox(
                                    height: isSmallScreen ? 110 : 100, // Fixed height container
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: (plan['features'] as List).map((feature) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 4),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  size: 14,
                                                  color: plan['textColor'],
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    feature,
                                                    style: const TextStyle(fontSize: 11),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                          
                          // Action buttons - more compact with better spacing
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      if (!isSelected) {
                                        setState(() {
                                          _selectedPlan = plan;
                                        });
                                      } else {
                                        _navigateToSubscriptionDetails(context, plan);
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: plan['textColor'],
                                      side: BorderSide(color: plan['textColor']!),
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      minimumSize: const Size(0, 30),
                                      textStyle: const TextStyle(fontSize: 11),
                                    ),
                                    child: Text(isSelected ? 'Details' : 'Select'),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _navigateToPayment(context, plan),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: plan['textColor'],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      minimumSize: const Size(0, 30),
                                      textStyle: const TextStyle(fontSize: 11),
                                    ),
                                    child: const Text('Subscribe'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Page indicator for mobile
              if (isSmallScreen) 
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        currentPlans.length,
                        (index) => Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  // New widget for displaying the selected plan
  Widget _buildSelectedPlanWidget(BuildContext context, Map<String, dynamic> plan, bool isSmallScreen) {
    final price = calculatePrice(plan, _isAnnual);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: plan['textColor'],
                  radius: 12,
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Plan',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        plan['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPlan = null;
                    });
                  },
                  child: const Icon(Icons.close, size: 16),
                ),
              ],
            ),
            const Divider(height: 16),
            
            // System size and price - more compact horizontal layout
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.straighten, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${_systemSizeKW.toStringAsFixed(1)} KW',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.category, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          _systemCategory,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.payments, size: 14, color: plan['textColor']),
                      const SizedBox(width: 4),
                      Text(
                        '₹${price.toStringAsFixed(0)}/${_isAnnual ? 'yr' : 'mo'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: plan['textColor'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResponsiveControls(bool isSmallScreen) {
    if (isSmallScreen) {
      // Stacked layout for small screens - more compact
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Annual/Monthly toggle
          _buildBillingToggle(),
          const SizedBox(height: 8),
          // System category and size on same row
          Row(
            children: [
              Expanded(
                child: _buildCategoryDropdown(),
              ),
              const SizedBox(width: 8),
              _buildSystemSizeField(),
            ],
          ),
        ],
      );
    } else {
      // Horizontal layout for larger screens
      return Row(
        children: [
          _buildBillingToggle(),
          const Spacer(),
          _buildSystemSizeField(),
          const SizedBox(width: 8),
          _buildCategoryDropdown(),
        ],
      );
    }
  }
  
  Widget _buildBillingToggle() {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleOption(true, 'Annual'),
            _buildToggleOption(false, 'Monthly'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildToggleOption(bool isAnnualOption, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAnnual = isAnnualOption;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _isAnnual == isAnnualOption 
              ? Theme.of(context).colorScheme.primary 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _isAnnual == isAnnualOption ? Colors.white : Colors.black87,
            fontWeight: _isAnnual == isAnnualOption ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
  
  Widget _buildSystemSizeField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: 70,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        controller: _systemSizeController,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 12),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          border: InputBorder.none,
          hintText: 'KW',
          suffixText: 'KW',
          suffixStyle: TextStyle(fontSize: 10),
        ),
        onChanged: (value) {
          setState(() {
            _systemSizeKW = double.tryParse(value) ?? 5.0;
          });
        },
      ),
    );
  }
  
  Widget _buildCategoryDropdown() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _systemCategory,
          icon: const Icon(Icons.arrow_drop_down, size: 18),
          isDense: true,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _systemCategory = newValue;
              });
            }
          },
          items: _systemCategories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
