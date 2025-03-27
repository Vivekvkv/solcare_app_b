import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/cart_provider.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';
import 'package:solcare_app4/screens/cart/components/index.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _systemSizeController = TextEditingController(text: '5.0');
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      _systemSizeController.text = cartProvider.systemSizeKW.toString();
    });
  }
  
  @override
  void dispose() {
    _systemSizeController.dispose();
    super.dispose();
  }
  
  // Validate and update system size
  void _updateSystemSize(BuildContext context, String value) {
    if (value.isEmpty) return;
    
    try {
      final double systemSize = double.parse(value);
      if (systemSize > 0) {
        Provider.of<CartProvider>(context, listen: false).setSystemSize(systemSize);
      } else {
        // Show error for negative values
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('System size must be greater than 0')),
        );
        _systemSizeController.text = Provider.of<CartProvider>(context, listen: false).systemSizeKW.toString();
      }
    } catch (e) {
      // Show error for invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      _systemSizeController.text = Provider.of<CartProvider>(context, listen: false).systemSizeKW.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final totalAmount = cartProvider.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Cart'),
                    content: const Text('Are you sure you want to remove all items from your cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          
                        ),
                        onPressed: () {
                          cartProvider.clear();
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cart cleared'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Text('Yes, Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? const EmptyCart()
          : SafeArea(
              child: Column(
                children: [
                  // Title for services section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Services',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${cartItems.length} items',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Cart items list 
                  Expanded(
                    child: CartItemsList(
                      cartItems: cartItems,
                      getAdjustedPrice: cartProvider.getAdjustedPrice,
                    ),
                  ),
                  
                  // Fixed bottom section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // System Size Input - moved below cart items and made more compact
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Your Solar System Size',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Price varies by size',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _systemSizeController,
                                      decoration: InputDecoration(
                                        labelText: 'System Size (kW)',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                        suffixText: 'kW',
                                        isDense: true,
                                      ),
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                      ],
                                      onChanged: (value) {
                                        // Update immediately on change for better UX
                                        _updateSystemSize(context, value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Summary card
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CartSummary(
                            totalAmount: totalAmount,
                            itemCount: cartItems.length,
                            rewardPoints: (totalAmount * 0.1).toInt(),
                          ),
                        ),
                        
                        // Proceed button (inside the Column, not as bottomNavigationBar)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BookingScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      // Remove the bottomNavigationBar to prevent overflow issues
    );
  }
}
