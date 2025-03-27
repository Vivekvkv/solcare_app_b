import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickConsultationSection extends StatefulWidget {
  const QuickConsultationSection({super.key});

  @override
  State<QuickConsultationSection> createState() => _QuickConsultationSectionState();
}

class _QuickConsultationSectionState extends State<QuickConsultationSection> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  
  // Form submission state
  bool _isSubmitting = false;
  bool _showSuccess = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
  
  // Submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isSubmitting = false;
        _showSuccess = true;
      });
      
      // Reset form after success
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _messageController.clear();
      
      // Hide success message after some time
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showSuccess = false;
          });
        }
      });
    }
  }
  
  // Make a phone call
  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+918818880540'); // Replace with actual support number
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorSnackBar('Unable to make a call. Please try again later.');
      }
    } catch (e) {
      _showErrorSnackBar('Unable to make a call. Please try again later.');
    }
  }
  
  // Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Get a Free Solar Consultation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Section Description
          Text(
            'Have questions about your solar system? Get expert advice for free!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Phone Field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Basic numeric check
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address (Optional)',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      // Basic email validation
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Message Field
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Your Query',
                    prefixIcon: Icon(Icons.message),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                
                const SizedBox(height: 16),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Submit Request'),
                  ),
                ),
                
                if (_showSuccess)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Thank you! We\'ve received your request and will contact you soon.',
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Call Now Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Need Immediate Assistance?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _makePhoneCall,
                          icon: const Icon(Icons.call),
                          label: const Text('Call Now for Instant Support'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
