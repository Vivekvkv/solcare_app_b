import 'package:flutter/material.dart';
import 'dart:async';

class PaymentScreen extends StatefulWidget {
  final String title;
  final double amount;
  final String description;
  final Function(String) onSuccess;
  final List<Map<String, String>> itemDetails;

  const PaymentScreen({
    Key? key,
    required this.title,
    required this.amount,
    required this.description,
    required this.onSuccess,
    required this.itemDetails,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  String _selectedPaymentMethod = 'card';
  bool _isProcessing = false;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      // Simulate payment processing
      Timer(const Duration(seconds: 3), () {
        setState(() {
          _isProcessing = false;
          _currentStep = 2; // Move to confirmation step
        });
        
        // Generate a transaction ID
        final String transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
        
        // Call success callback with transaction ID
        widget.onSuccess(transactionId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Checkout'),
        elevation: 0,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        controlsBuilder: (context, details) {
          return const SizedBox.shrink(); // Remove default controls
        },
        steps: [
          // Step 1: Order Summary
          Step(
            title: const Text('Summary'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: _buildOrderSummary(),
          ),
          
          // Step 2: Payment Information
          Step(
            title: const Text('Payment'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: _buildPaymentForm(),
          ),
          
          // Step 3: Confirmation
          Step(
            title: const Text('Confirm'),
            isActive: _currentStep >= 2,
            content: _buildConfirmation(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order details
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
        
        // Item details table
        ...widget.itemDetails.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['label']!,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                item['value']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )),
        
        const Divider(height: 32),
        
        // Total amount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '₹${widget.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Continue button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 1;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Continue to Payment'),
          ),
        ),
        
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment method selector
          const Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Payment method tabs
          Row(
            children: [
              _buildPaymentMethodTab('Credit/Debit Card', 'card', Icons.credit_card),
              const SizedBox(width: 12),
              _buildPaymentMethodTab('UPI', 'upi', Icons.account_balance),
              const SizedBox(width: 12),
              _buildPaymentMethodTab('Net Banking', 'netbanking', Icons.account_balance_wallet),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Payment method specific forms
          _selectedPaymentMethod == 'card'
              ? _buildCardPaymentForm()
              : _selectedPaymentMethod == 'upi'
                  ? _buildUpiPaymentForm()
                  : _buildNetBankingForm(),
          
          const SizedBox(height: 32),
          
          // Payment security info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.security, color: Colors.grey[600]),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Your payment information is secure. We use industry-standard security protocols.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Pay button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isProcessing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Processing...'),
                      ],
                    )
                  : Text('Pay ₹${widget.amount.toStringAsFixed(2)}'),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Back button
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _currentStep = 0;
                });
              },
              child: const Text('Back to Order Summary'),
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTab(String title, String value, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card number
        TextFormField(
          controller: _cardNumberController,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            hintText: '1234 5678 9012 3456',
            prefixIcon: Icon(Icons.credit_card),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Cardholder name
        TextFormField(
          controller: _cardNameController,
          decoration: const InputDecoration(
            labelText: 'Cardholder Name',
            hintText: 'John Doe',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter cardholder name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Expiry and CVV in one row
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _cardExpiryController,
                decoration: const InputDecoration(
                  labelText: 'Expiry (MM/YY)',
                  hintText: '12/25',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cardCvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: '123',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUpiPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _upiIdController,
          decoration: const InputDecoration(
            labelText: 'UPI ID',
            hintText: 'yourname@upi',
            prefixIcon: Icon(Icons.account_balance),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter UPI ID';
            }
            if (!value.contains('@')) {
              return 'Enter a valid UPI ID';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // UPI apps grid
        const Text(
          'Select a UPI App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildUpiAppTile('Google Pay', 'assets/icons/gpay.png'),
            _buildUpiAppTile('PhonePe', 'assets/icons/phonepe.png'),
            _buildUpiAppTile('Paytm', 'assets/icons/paytm.png'),
            _buildUpiAppTile('BHIM', 'assets/icons/bhim.png'),
          ],
        ),
      ],
    );
  }
  
  Widget _buildUpiAppTile(String name, String assetPath) {
    // For the example, use a placeholder icon since we don't have assets
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.payment, size: 32, color: Colors.blue.shade700),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNetBankingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your Bank',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Common banks
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildBankTile('State Bank of India'),
            _buildBankTile('HDFC Bank'),
            _buildBankTile('ICICI Bank'),
            _buildBankTile('Axis Bank'),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Other banks dropdown
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Other Banks',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Select Bank'),
          items: ['Punjab National Bank', 'Bank of Baroda', 'Canara Bank']
              .map((bank) => DropdownMenuItem(
                    value: bank,
                    child: Text(bank),
                  ))
              .toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }
  
  Widget _buildBankTile(String bankName) {
    return ListTile(
      leading: const Icon(Icons.account_balance),
      title: Text(bankName),
      trailing: Radio<String>(
        value: bankName,
        groupValue: '',
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildConfirmation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 80,
        ),
        const SizedBox(height: 24),
        const Text(
          'Payment Successful!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Thank you for subscribing to ${widget.title.replaceAll('Subscribe to ', '')}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Back to Subscription Details'),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            // Navigate to home and clear stack
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text('Go to Home'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
