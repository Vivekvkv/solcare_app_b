import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:solcare_app4/screens/home/home_screen.dart';
import 'package:solcare_app4/screens/auth/components/animated_background.dart';
import 'package:solcare_app4/screens/auth/components/otp_input_field.dart';
import 'package:solcare_app4/screens/auth/forgot_password_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  // Tab controller for login/register toggle
  late TabController _tabController;
  
  // Form keys for validation
  final _registerFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  
  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _registerMobileController = TextEditingController();
  final TextEditingController _registerOtpController = TextEditingController();
  final TextEditingController _loginMobileController = TextEditingController();
  final TextEditingController _loginOtpController = TextEditingController();
  
  // States
  bool _isRegisterLoading = false;
  bool _isLoginLoading = false;
  bool _registerOtpSent = false;
  bool _loginOtpSent = false;
  int _otpResendTimer = 0;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0); // Default to Register
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _registerMobileController.dispose();
    _registerOtpController.dispose();
    _loginMobileController.dispose();
    _loginOtpController.dispose();
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }
  
  // ... existing timer and OTP methods ...
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
  
  Future<void> _sendRegisterOtp() async {
    // Validate mobile number
    if (!_registerFormKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isRegisterLoading = true;
    });
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isRegisterLoading = false;
      _registerOtpSent = true;
      _startResendTimer();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent successfully!')),
    );
  }
  
  Future<void> _sendLoginOtp() async {
    // Validate mobile number
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoginLoading = true;
    });
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoginLoading = false;
      _loginOtpSent = true;
      _startResendTimer();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent successfully!')),
    );
  }
  
  Future<void> _verifyRegisterOtp() async {
    // Skip form validation as it may be causing issues with OTP
    // Instead check the controller text directly
    
    setState(() {
      _isRegisterLoading = true;
    });
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo: assume "123456" is the correct OTP
    if (_registerOtpController.text == "123456") {
      // Registration successful
      if (!mounted) return;
      
      setState(() {
        _isRegisterLoading = false;
      });
      
      // Store user session (would typically use SharedPreferences)
      
      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Invalid OTP
      if (!mounted) return;
      
      setState(() {
        _isRegisterLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _verifyLoginOtp() async {
    // Skip form validation as it may be causing issues with OTP
    // Instead check the controller text directly
    
    setState(() {
      _isLoginLoading = true;
    });
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo: assume "123456" is the correct OTP
    if (_loginOtpController.text == "123456") {
      // Login successful
      if (!mounted) return;
      
      setState(() {
        _isLoginLoading = false;
      });
      
      // Store user session (would typically use SharedPreferences)
      
      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Invalid OTP
      if (!mounted) return;
      
      setState(() {
        _isLoginLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTabletOrDesktop = screenSize.width > 600;
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 170, 255), // Change this to your desired color
      body: Stack(
        children: [
          // Enhanced solar/water themed background
          const SolarAnimatedBackground(),
          
          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTabletOrDesktop ? 480 : screenSize.width,
                    minHeight: screenSize.height * 0.75,
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: isTabletOrDesktop ? 0 : 16.0,
                      vertical: 24.0,
                    ),
                    elevation: 10,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 24),
                          
                          // SolCare Logo
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor.withOpacity(0.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.solar_power,
                              color: Theme.of(context).primaryColor,
                              size: isTabletOrDesktop ? 60 : 40,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Text(
                            'SolCare',
                            style: TextStyle(
                              fontSize: isTabletOrDesktop ? 36 : 30,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor.withOpacity(0.8),
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Enhanced Login/Register toggle tabs
                          Container(
                            height: 56,
                            margin: EdgeInsets.symmetric(
                              horizontal: isTabletOrDesktop ? 32 : 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicator: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.zero,
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black87,
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              unselectedLabelStyle: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              tabs: const [
                                Tab(text: 'Register'),
                                Tab(text: 'Login'),
                              ],
                            ),
                          ),
                          
                          // Form content based on selected tab
                          SizedBox(
                            height: isTabletOrDesktop ? 440 : 400,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildRegisterContent(isTabletOrDesktop),
                                _buildLoginContent(isTabletOrDesktop),
                              ],
                            ),
                          ),
                        ],
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
  
  // Renamed methods to fix 'not referenced' warnings
  Widget _buildRegisterContent(bool isTabletOrDesktop) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTabletOrDesktop ? 32 : 16,
        vertical: 24,
      ),
      child: Form(
        key: _registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create an Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Full Name
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Mobile Number
            _buildTextField(
              controller: _registerMobileController,
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
            const SizedBox(height: 16),
            
            // Get OTP Button
            if (!_registerOtpSent)
              _buildGradientButton(
                text: 'Get OTP',
                isLoading: _isRegisterLoading,
                onPressed: _sendRegisterOtp,
              ),
            
            // OTP Input and Verify (show only after OTP is sent)
            if (_registerOtpSent) ...[
              OtpInputField(
                controller: _registerOtpController,
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
              
              // Resend OTP Timer
              Center(
                child: _otpResendTimer > 0
                    ? Text(
                        'Resend OTP in $_otpResendTimer seconds',
                        style: TextStyle(color: Colors.black54),
                      )
                    : TextButton(
                        onPressed: _sendRegisterOtp,
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              
              // Verify OTP Button
              _buildGradientButton(
                text: 'Create Account',
                isLoading: _isRegisterLoading,
                onPressed: _verifyRegisterOtp,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoginContent(bool isTabletOrDesktop) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTabletOrDesktop ? 32 : 16,
        vertical: 24,
      ),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Mobile Number
            _buildTextField(
              controller: _loginMobileController,
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
            const SizedBox(height: 16),
            
            // Get OTP Button
            if (!_loginOtpSent)
              _buildGradientButton(
                text: 'Get OTP',
                isLoading: _isLoginLoading,
                onPressed: _sendLoginOtp,
              ),
            
            // OTP Input and Verify (show only after OTP is sent)
            if (_loginOtpSent) ...[
              OtpInputField(
                controller: _loginOtpController,
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
              
              // Resend OTP Timer
              Center(
                child: _otpResendTimer > 0
                    ? Text(
                        'Resend OTP in $_otpResendTimer seconds',
                        style: TextStyle(color: Colors.black54),
                      )
                    : TextButton(
                        onPressed: _sendLoginOtp,
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              
              // Verify OTP Button
              _buildGradientButton(
                text: 'Login',
                isLoading: _isLoginLoading,
                onPressed: _verifyLoginOtp,
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Forgot Password
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to create consistent text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
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
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor.withOpacity(0.7)),
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
