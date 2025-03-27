import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:solcare_app4/screens/auth/components/animated_background.dart';
import 'package:solcare_app4/screens/auth/components/otp_input_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _otpSent = false;
  bool _otpVerified = false;
  int _otpResendTimer = 0;
  Timer? _timer;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }
  
  void _startResendTimer() {
    _otpResendTimer = 30; // 30 seconds countdown
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_otpResendTimer > 0) {
          _otpResendTimer--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }
  
  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
      _otpSent = true;
      _startResendTimer();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent successfully!')),
    );
  }
  
  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo: assume "123456" is the correct OTP
    if (_otpController.text == "123456") {
      setState(() {
        _isLoading = false;
        _otpVerified = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate back to login screen
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 600;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background
          const SolarAnimatedBackground(),
          
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isLargeScreen ? 480 : screenSize.width,
                    minHeight: screenSize.height * 0.75,
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: isLargeScreen ? 0 : 16.0,
                      vertical: 24.0,
                    ),
                    elevation: 10,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white.withOpacity(0.15),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 24),
                            
                            const Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            Text(
                              'Enter your mobile number to receive an OTP for password reset',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Mobile Number (step 1)
                            if (!_otpVerified) ...[
                              _buildTextField(
                                controller: _mobileController,
                                enabled: !_otpSent || _otpResendTimer == 0,
                                label: 'Mobile Number',
                                prefixIcon: Icons.phone_android,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your mobile number';
                                  }
                                  if (value.length != 10) {
                                    return 'Mobile number must be 10 digits';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Get OTP Button (step 1)
                              if (!_otpSent)
                                _buildGradientButton(
                                  text: 'Get OTP',
                                  isLoading: _isLoading,
                                  onPressed: _sendOtp,
                                ),
                              
                              // OTP Verification (step 2)
                              if (_otpSent) ...[
                                const SizedBox(height: 16),
                                
                                OtpInputField(
                                  controller: _otpController,
                                  label: 'Enter OTP',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the OTP';
                                    }
                                    if (value.length != 6) {
                                      return 'OTP must be 6 digits';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Resend OTP Timer/Button
                                Center(
                                  child: _otpResendTimer > 0
                                      ? Text(
                                          'Resend OTP in $_otpResendTimer seconds',
                                          style: TextStyle(color: Colors.white.withOpacity(0.8)),
                                        )
                                      : TextButton(
                                          onPressed: _sendOtp,
                                          child: Text(
                                            'Resend OTP',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Verify OTP Button
                                _buildGradientButton(
                                  text: 'Verify OTP',
                                  isLoading: _isLoading,
                                  onPressed: _verifyOtp,
                                ),
                              ],
                            ],
                            
                            // New Password (step 3)
                            if (_otpVerified) ...[
                              _buildTextField(
                                controller: _newPasswordController,
                                label: 'New Password',
                                prefixIcon: Icons.lock,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a new password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 24),
                              
                              _buildTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                obscureText: _obscureConfirmPassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _newPasswordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // Reset Password Button
                              _buildGradientButton(
                                text: 'Reset Password',
                                isLoading: _isLoading,
                                onPressed: _resetPassword,
                              ),
                            ],
                            
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to create consistent text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool obscureText = false,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor.withOpacity(0.7)),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
  
  // Helper method for gradient buttons
  Widget _buildGradientButton({
    required String text,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withBlue(
                  (Theme.of(context).primaryColor.blue * 0.8).toInt(),
                ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
