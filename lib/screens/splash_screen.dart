import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:solcare_app4/screens/main_screen.dart';

import '../providers/auth_provider.dart';
import 'auth/auth_screen.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  //add by vivek

  Future<void> _initData() async{

    AuthProvider provider = context.read<AuthProvider>();
    await provider.init();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
        builder: (BuildContext context) {
      // return provider.token == null ? const AuthScreen() : const HomeScreen();
      return const AuthScreen();
        },
    ),
    );
  }




  // @override
  // void initState() {
  //   super.initState();
  //   //  Navigate to main screen after 3 seconds
  //   Future.delayed(const Duration(seconds: 3), () {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => const MainScreen(),
  //       ),
  //     );
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.solar_power,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'SolCare',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              'Simplifying Solar Care',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 48),
            
            // Loading Spinner
            SpinKitPulse(
              color: Theme.of(context).colorScheme.primary,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
