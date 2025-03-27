import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/screens/payment/payment_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  final String? initialSelectedPlan;
  final String? systemCategory;
  final double? systemSizeKW;

  const SubscriptionScreen({
    Key? key, 
    this.initialSelectedPlan,
    this.systemCategory,
    this.systemSizeKW,
  }) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'Residential';
  String? _selectedPlanCategory; // New field to track selected plan's category
  bool _showComparison = false;
  bool _isAnnual = true;
  double _systemSizeKW = 5.0;
  final TextEditingController _systemSizeController = TextEditingController(text: '5.0');
  Map<String, dynamic>? _selectedPlan;

  // Plan details with features and pricing for different system categories
  final Map<String, List<Map<String, dynamic>>> _subscriptionPlans = {
    'Residential': [
      {
        'name': 'Basic Care',
        'description': 'Essential maintenance for home solar setups',
        'features': ['Basic Cleaning', 'Cleaning Frequency: Bi-Annually (2 times a year)', 'Standard Maintenance Checks: Once a year', 'Phone Call Support', 'Standard Response Time: 48 hours', 'Basic Health Reports'],
        'pricePerKW': 800,
        'color': Colors.blue.shade100,
        'textColor': Colors.blue.shade800,
        'isRecommended': false,
        'isPremium': false,
      },
      {
        'name': 'Standard Care',
        'description': 'Comprehensive care for optimal performance',
        'features': ['Deep Cleaning', 'Cleaning Frequency: Quarterly (4 times a year)', 'Standard Maintenance Checks: 4 times a year', '5% discount on emergency extra services', 'Energy-Saving Tips & Consultation', 'Phone Call Support', 'Priority Response Time: 24 hours', 'Detailed Performance Reports'],
        'pricePerKW': 1200,
        'color': Colors.green.shade100,
        'textColor': Colors.green.shade700,
        'isRecommended': true,
        'isPremium': false,
      },
      {
        'name': 'Premium Care',
        'description': 'Advanced care with premium features',
        'features': ['Advanced Deep Cleaning', 'Cleaning Frequency: Monthly (12 times a year)', 'Standard Maintenance Checks: 12 times a year', '8% discount on emergency extra services', 'Energy-Saving Tips & Consultation', 'Smart Home Energy Monitoring Integration', 'Phone Call & At-Home Support', 'Express Response Time: 8 hours', 'Comprehensive Analytics Dashboard', 'Dedicated Service Manager'],
        'pricePerKW': 2000,
        'color': Colors.purple.shade100,
        'textColor': Colors.purple.shade700,
        'isRecommended': false,
        'isPremium': true,
      },
      {
        'name': 'Family Plus',
        'description': 'Ultimate care for large family setups',
        'features': ['Advanced Deep Cleaning', 'Cleaning Frequency: Every 15 Days (24 times a year)', 'Standard Maintenance Checks: 24 times a year', '10% discount on emergency extra services', 'Energy-Saving Tips & Consultation', 'Smart Home Energy Monitoring Integration', 'Personalized Energy Efficiency Audit', 'Phone Call & At-Home Support', 'Emergency Response Time: 4 hours', 'Full System Protection', 'Annual Component Replacement', 'VIP Technical Support'],
        'pricePerKW': 2600,
        'color': Colors.orange.shade100,
        'textColor': Colors.orange.shade700,
        'isRecommended': false,
        'isPremium': true,
      },
    ],
    'Commercial': [
      {
        'name': 'Business Care',
        'description': 'Professional maintenance for commercial installations',
        'features': [
          'Monthly Inspection', 
          'Commercial Cleaning', 
          'Dedicated Support Line', 
          'Performance Analytics',
          'Standard Response Time: 36 hours',
          'Quarterly Business Reviews'
        ],
        'pricePerKW': 800,
        'price': '₹20,000',
        'monthlyPrice': '₹2,000',
        'period': 'per year',
        'color': Colors.teal.shade100,
        'textColor': Colors.teal.shade800,
        'isRecommended': true,
        'isPremium': false,
      },
      {
        'name': 'Enterprise Care',
        'description': 'Comprehensive solution for business operations',
        'features': [
          'Bi-weekly Inspection', 
          'Advanced Cleaning', 
          'Priority Support', 
          'Real-time Monitoring', 
          'Repairs Included', 
          'Quarterly Reports',
          'Priority Response Time: 24 hours',
          'Enhanced System Analytics'
        ],
        'pricePerKW': 1200,
        'price': '₹30,000',
        'monthlyPrice': '₹3,000',
        'period': 'per year',
        'color': Colors.indigo.shade100,
        'textColor': Colors.indigo.shade700,
        'isRecommended': false,
        'isPremium': false,
      },
      {
        'name': 'Professional Plus',
        'description': 'Enhanced service for demanding businesses',
        'features': [
          'Weekly Inspection', 
          'Premium Cleaning', 
          '24/7 Support', 
          'Performance Optimization', 
          'Parts Coverage', 
          'Emergency Response',
          'Response Time: 12 hours',
          'Energy Efficiency Consulting',
          'Technical Training for Staff',
          'Unlimited Service Calls'
        ],
        'pricePerKW': 2000,
        'price': '₹50,000',
        'monthlyPrice': '₹5,000',
        'period': 'per year',
        'color': Colors.pink.shade100,
        'textColor': Colors.pink.shade700,
        'isRecommended': false,
        'isPremium': true,
      },
      {
        'name': 'Corporate Value',
        'description': 'Cost-effective for essential business maintenance',
        'features': [
          'Monthly Inspection', 
          'Standard Cleaning', 
          'Professional Support', 
          'Energy Monitoring', 
          'Quarterly Business Reviews',
          'Response Time: 24 hours',
          'Annual System Audit',
          'Discounted Emergency Repairs',
          'Preventive Maintenance Planning'
        ],
        'pricePerKW': 2500,
        'price': '₹60,000',
        'monthlyPrice': '₹6,000',
        'period': 'per year',
        'color': Colors.amber.shade100,
        'textColor': Colors.amber.shade800,
        'isRecommended': false,
        'isPremium': true,
      },
    ],
    'Industrial': [
      {
        'name': 'Industrial Care',
        'description': 'Heavy-duty maintenance for industrial installations',
        'features': [
          'Weekly Inspection', 
          'Industrial Cleaning', 
          'Dedicated Support Team', 
          'Advanced Analytics', 
          'Custom Reporting',
          'Response Time: 24 hours',
          'Fault Diagnosis System',
          'Annual Energy Audit'
        ],
        'pricePerKW': 800,
        'price': '₹80,000',
        'monthlyPrice': '₹8,000',
        'period': 'per year',
        'color': Colors.deepPurple.shade100,
        'textColor': Colors.deepPurple.shade800,
        'isRecommended': true,
        'isPremium': false,
      },
      {
        'name': 'Manufacturing Plus',
        'description': 'Specialized care for production facilities',
        'features': [
          'Bi-weekly Inspection', 
          'Heavy-duty Cleaning', 
          'Dedicated Account Manager', 
          'Efficiency Reports', 
          'Emergency Repairs', 
          '24/7 Monitoring',
          'Response Time: 12 hours',
          'Quarterly Production Impact Analysis',
          'Custom Alert System',
          'Staff Training Programs'
        ],
        'pricePerKW': 1200,
        'price': '₹120,000',
        'monthlyPrice': '₹12,000',
        'period': 'per year',
        'color': Colors.cyan.shade100,
        'textColor': Colors.cyan.shade800,
        'isRecommended': false,
        'isPremium': false,
      },
      {
        'name': 'Industrial Premium',
        'description': 'All-inclusive solution for critical operations',
        'features': [
          'On-demand Inspection', 
          'Premium Industrial Cleaning', 
          'Executive Support', 
          'Real-time Analytics', 
          'Full Parts Coverage', 
          'Immediate Response Team',
          'Response Time: 6 hours',
          'Energy Optimization Consulting',
          'Preventive Component Replacement',
          'Dedicated Technical Team',
          'Monthly Performance Reviews',
          'Custom Expansion Planning'
        ],
        'pricePerKW': 2000,
        'price': '₹200,000',
        'monthlyPrice': '₹20,000',
        'period': 'per year',
        'color': Colors.red.shade100,
        'textColor': Colors.red.shade800,
        'isRecommended': false,
        'isPremium': true,
      },
      {
        'name': 'Enterprise Elite',
        'description': 'Ultimate protection for large industrial systems',
        'features': [
          'Weekly Inspection', 
          'Custom Cleaning Protocol', 
          'Dedicated Team', 
          'Custom Analytics', 
          'Complete Coverage', 
          'Strategic Support',
          'Emergency Response Time: 4 hours',
          'Executive Level Account Management',
          'System Integration Services',
          'Unlimited Site Visits',
          'Annual Hardware Upgrades',
          'Customized Reporting Suite',
          'Comprehensive Warranty Extensions',
          'Sustainability Consultation'
        ],
        'pricePerKW': 2500,
        'price': '₹250,000',
        'monthlyPrice': '₹25,000',
        'period': 'per year',
        'color': Colors.lightGreen.shade100,
        'textColor': Colors.lightGreen.shade800,
        'isRecommended': false,
        'isPremium': true,
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
    _tabController = TabController(length: 3, vsync: this);
    
    // Initialize from passed parameters
    if (widget.systemCategory != null) {
      _selectedCategory = widget.systemCategory!;
      _tabController.index = _getCategoryTabIndex(widget.systemCategory!);
    }
    
    if (widget.systemSizeKW != null) {
      _systemSizeKW = widget.systemSizeKW!;
      _systemSizeController.text = _systemSizeKW.toString();
    }
    
    // Find the selected plan if initialSelectedPlan is provided
    if (widget.initialSelectedPlan != null) {
      // Search in all categories to find the selected plan
      for (final category in _subscriptionPlans.keys) {
        final planIndex = _subscriptionPlans[category]!
            .indexWhere((plan) => plan['name'] == widget.initialSelectedPlan);
        if (planIndex != -1) {
          _selectedPlan = _subscriptionPlans[category]![planIndex];
          _selectedPlanCategory = category; // Store the original category
          _selectedCategory = category;
          _tabController.index = _getCategoryTabIndex(category);
          break;
        }
      }
    }
    
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedCategory = _getCategoryFromTabIndex(_tabController.index);
        });
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _systemSizeController.dispose();
    super.dispose();
  }
  
  // Calculate price based on system size in KW
  double calculatePrice(Map<String, dynamic> plan, bool isAnnual, [String? overrideCategory]) {
    final double basePrice = plan['pricePerKW'] * _systemSizeKW;
    final String categoryToUse = overrideCategory ?? _selectedCategory;
    
    if (isAnnual) {
      // Apply category-specific discount for annual billing
      final double discountRate = _annualDiscountRates[categoryToUse]!;
      final double monthlyPrice = basePrice;
      final double annualPrice = monthlyPrice * 12;
      final double discountedPrice = annualPrice * (1 - discountRate);
      return discountedPrice;
    } else {
      // Monthly price without discount
      return basePrice;
    }
  }
  
  // Get discount percentage for a specific category
  int getCategoryDiscount([String? category]) {
    final String categoryToUse = category ?? _selectedCategory;
    return (_annualDiscountRates[categoryToUse]! * 100).round();
  }
  
  String _getCategoryFromTabIndex(int index) {
    switch (index) {
      case 0: return 'Residential';
      case 1: return 'Commercial';
      case 2: return 'Industrial';
      default: return 'Residential';
    }
  }
  
  int _getCategoryTabIndex(String category) {
    switch (category) {
      case 'Residential': return 0;
      case 'Commercial': return 1;
      case 'Industrial': return 2;
      default: return 0;
    }
  }
  
  void _navigateToPayment(BuildContext context, Map<String, dynamic> plan) {
    // Use the plan's original category if it's the selected plan
    final String categoryToUse = 
        (plan == _selectedPlan && _selectedPlanCategory != null) 
            ? _selectedPlanCategory! 
            : _selectedCategory;
    
    final price = calculatePrice(plan, _isAnnual, categoryToUse);
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
            {'label': 'Category', 'value': categoryToUse},
            {'label': 'System Size', 'value': '${_systemSizeKW.toStringAsFixed(1)} KW'},
            {'label': 'Billing Cycle', 'value': billingCycle},
            if (_isAnnual) {'label': 'Discount', 'value': '${getCategoryDiscount(categoryToUse)}%'},
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we're in mobile view
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // More compact header section
          _buildCompactHeader(),
          
          // Tab content - Make it expandable and scrollable
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryTabContent('Residential', isMobile),
                _buildCategoryTabContent('Commercial', isMobile),
                _buildCategoryTabContent('Industrial', isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // New compact header that combines all header elements
  Widget _buildCompactHeader() {
    return Column(
      children: [
        // Combined system size controls and view toggle in one row
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              // Billing cycle toggle with smaller text
              _buildCompactBillingToggle(),
              
              const Spacer(),
              
              // More compact system size input
              _buildCompactSystemSizeInput(),
              
              const SizedBox(width: 8),
              
              // View toggle as icon only
              IconButton(
                icon: Icon(_showComparison ? Icons.grid_view : Icons.compare_arrows, 
                  size: 20),
                onPressed: () {
                  setState(() {
                    _showComparison = !_showComparison;
                  });
                },
                tooltip: _showComparison ? 'Card View' : 'Comparison View',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
            ],
          ),
        ),
        
        // Category tabs with smaller height
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Residential'),
              Tab(text: 'Commercial'),
              Tab(text: 'Industrial'),
            ],
            labelStyle: const TextStyle(fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
  
  // More compact billing toggle
  Widget _buildCompactBillingToggle() {
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
            GestureDetector(
              onTap: () {
                setState(() {
                  _isAnnual = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _isAnnual ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Annual',
                  style: TextStyle(
                    color: _isAnnual ? Colors.white : Colors.black87,
                    fontWeight: _isAnnual ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isAnnual = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: !_isAnnual ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Monthly',
                  style: TextStyle(
                    color: !_isAnnual ? Colors.white : Colors.black87,
                    fontWeight: !_isAnnual ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Compact system size input
  Widget _buildCompactSystemSizeInput() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'System: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
        Container(
          width: 60,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _systemSizeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              border: InputBorder.none,
              suffixText: 'KW',
              suffixStyle: TextStyle(fontSize: 10),
            ),
            style: const TextStyle(fontSize: 12),
            onChanged: (value) {
              setState(() {
                _systemSizeKW = double.tryParse(value) ?? 5.0;
              });
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildCategoryTabContent(String category, bool isMobile) {
    final plans = _subscriptionPlans[category]!;
    
    // If showing comparison table
    if (_showComparison) {
      return _buildComparisonTable(plans);
    }
    
    // Else show plan cards (with SingleChildScrollView for scrolling)
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show selected plan at the top of its category tab if it belongs to this category
          if (_selectedPlan != null && (_selectedPlanCategory == category || 
             (_selectedPlanCategory == null && _selectedCategory == category)))
            _buildSelectedPlanWidget(context, _selectedPlan!),
            
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Choose a plan that suits your needs',
              style: TextStyle(fontSize: 14),
            ),
          ),
          
          // Plan cards in grid or list depending on screen size
          isMobile
              ? Column(
                  children: plans.map((plan) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                      child: _buildPlanCard(
                        context, 
                        plan, 
                        isHighlighted: _selectedPlan != null && _selectedPlan!['name'] == plan['name'],
                      ),
                    )
                  ).toList(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Don't scroll inside the grid
                    children: plans.map((plan) => 
                      _buildPlanCard(
                        context, 
                        plan, 
                        isHighlighted: _selectedPlan != null && _selectedPlan!['name'] == plan['name'],
                      )
                    ).toList(),
                  ),
                ),
          
          // Custom plan section and FAQ remain the same
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need a Custom Plan?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'We can create a tailored maintenance plan based on your system size, location, and specific requirements.',
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: OutlinedButton(
                        onPressed: () {
                          // Request custom plan
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Custom plan request feature coming soon')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Request Custom Plan'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildFaqSection(),
          ),
        ],
      ),
    );
  }
  
  // New widget for displaying the selected plan at the top
  Widget _buildSelectedPlanWidget(BuildContext context, Map<String, dynamic> plan) {
    // Always use the stored category for the selected plan
    final price = calculatePrice(plan, _isAnnual, _selectedPlanCategory);
    final discount = _isAnnual ? getCategoryDiscount(_selectedPlanCategory) : 0;
    
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: plan['textColor'],
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Plan header with color
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: plan['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: plan['textColor'],
                  radius: 16,
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Plan',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        plan['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: plan['textColor'],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: plan['textColor'],
                      ),
                    ),
                    Text(
                      _isAnnual ? '/year' : '/month',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Plan details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // System size and type info
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'System Size',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '${_systemSizeKW.toStringAsFixed(1)} KW',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Category',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            _selectedPlanCategory ?? _selectedCategory,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Key features - show ALL features
                const Text(
                  'Features:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ...((plan['features'] as List).map((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: plan['textColor'],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()),
                
                const SizedBox(height: 16),
                
                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _navigateToPayment(context, plan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plan['textColor'],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Subscribe to Selected Plan'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSystemSizeControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Billing cycle toggle
          _buildBillingToggle(),
          
          const Spacer(),
          
          // System size input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Size (KW)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _systemSizeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    border: InputBorder.none,
                    suffixText: 'KW',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _systemSizeKW = double.tryParse(value) ?? 5.0;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildBillingToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isAnnual = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isAnnual ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Annual',
                  style: TextStyle(
                    color: _isAnnual ? Colors.white : Colors.black87,
                    fontWeight: _isAnnual ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isAnnual = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: !_isAnnual ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Monthly',
                  style: TextStyle(
                    color: !_isAnnual ? Colors.white : Colors.black87,
                    fontWeight: !_isAnnual ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlanCard(
    BuildContext context, 
    Map<String, dynamic> plan, {
    bool isHighlighted = false,
  }) {
    final price = calculatePrice(plan, _isAnnual);
    final discount = _isAnnual ? getCategoryDiscount() : 0;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          elevation: isHighlighted || plan['isRecommended'] ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isHighlighted
                ? BorderSide(color: plan['textColor'], width: 2)
                : plan['isRecommended']
                    ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
                    : BorderSide.none,
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedPlan = plan;
                _selectedPlanCategory = _selectedCategory; // Store the current category
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan title and icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          plan['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: plan['isPremium']
                                ? Colors.purple
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      if (isHighlighted)
                        Icon(Icons.check_circle, color: plan['textColor'], size: 24)
                      else if (plan['isPremium'] == true)
                        const Icon(Icons.star, color: Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // System size and price
                  Text(
                    plan['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  
                  // Price based on system size
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: plan['textColor'],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isAnnual ? '/year' : '/month',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'For ${_systemSizeKW.toStringAsFixed(1)} KW system',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (_isAnnual && discount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      margin: const EdgeInsets.only(top: 4),
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
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  
                  // Features list
                  ...(plan['features'] as List).take(4).map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: plan['textColor'],
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
                  
                  if ((plan['features'] as List).length > 4)
                    TextButton(
                      onPressed: () {
                        // Show all features in a dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(plan['name']),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...(plan['features'] as List).map((feature) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: plan['textColor'],
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(feature),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        'See all ${(plan['features'] as List).length} features',
                        style: TextStyle(
                          fontSize: 12,
                          color: plan['textColor'],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Subscribe button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _navigateToPayment(context, plan),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: plan['textColor'],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Subscribe',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (plan['isRecommended'])
          Positioned(
            top: -10,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Recommended',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        if (isHighlighted)
          Positioned(
            top: -10,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Selected',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildComparisonTable(List<Map<String, dynamic>> plans) {
    // Extract all unique features across plans
    final Set<String> allFeatures = {};
    for (final plan in plans) {
      for (final feature in plan['features']) {
        allFeatures.add(feature);
      }
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan Comparison',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'For ${_systemSizeKW.toStringAsFixed(1)} KW system',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          
          // Scrollable comparison table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 24,
              horizontalMargin: 12,
              headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
              columns: [
                const DataColumn(label: Text('Features')),
                ...plans.map((plan) => DataColumn(
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(
                          plan['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${calculatePrice(plan, _isAnnual).toStringAsFixed(0)}',
                          style: TextStyle(
                            color: plan['textColor'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
              rows: [
                // Price row
                DataRow(
                  cells: [
                    const DataCell(Text('Monthly Option', 
                      style: TextStyle(fontWeight: FontWeight.bold))),
                    ...plans.map((plan) => DataCell(
                      Text('₹${(plan['pricePerKW'] * _systemSizeKW).toStringAsFixed(0)}'),
                    )),
                  ],
                ),
                
                // Feature rows
                ...allFeatures.map((feature) => DataRow(
                  cells: [
                    DataCell(Text(feature)),
                    ...plans.map((plan) => DataCell(
                      plan['features'].contains(feature)
                        ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                        : Icon(Icons.remove, color: Colors.grey, size: 20),
                    )),
                  ],
                )),
                
                // Button row
                DataRow(
                  cells: [
                    const DataCell(Text('')),
                    ...plans.map((plan) => DataCell(
                      ElevatedButton(
                        onPressed: () => _navigateToPayment(context, plan),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: plan['isPremium'] ? Colors.purple : Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Subscribe'),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFaqSection() {
    return ExpansionTile(
      title: const Text(
        'Frequently Asked Questions',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: const [
        ListTile(
          title: Text('How often should I clean my solar panels?'),
          subtitle: Text('Most systems benefit from cleaning 3-4 times per year, depending on your location and local environment.'),
        ),
        ListTile(
          title: Text('Can I upgrade my plan later?'),
          subtitle: Text('Yes, you can upgrade your subscription plan at any time. The price difference will be prorated for the remaining period.'),
        ),
        ListTile(
          title: Text('What happens if I need emergency service?'),
          subtitle: Text('Premium plan members get priority emergency service. Basic and Standard members can still request emergency service at standard rates.'),
        ),
        ListTile(
          title: Text('Is there a contract period?'),
          subtitle: Text('All plans have a minimum commitment of 3 months. Annual plans offer better rates but require upfront payment for the entire year.'),
        ),
        ListTile(
          title: Text('How do I schedule service visits?'),
          subtitle: Text('Service visits can be scheduled through the SolCare app under the Bookings tab. Premium members get priority scheduling.'),
        ),
      ],
    );
  }
}
