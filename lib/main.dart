import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:google_fonts/google_fonts.dart';
import 'package:solcare_app4/providers/auth_provider.dart';
import 'package:solcare_app4/screens/splash_screen.dart';
import 'package:solcare_app4/providers/service_provider.dart';
import 'package:solcare_app4/providers/booking_provider.dart';
import 'package:solcare_app4/providers/cart_provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/providers/theme_provider.dart';
import 'package:solcare_app4/providers/reel_provider.dart';
import 'package:flutter/services.dart';
import 'package:solcare_app4/screens/main_screen.dart'; // Import for navigatorKey
import 'package:solcare_app4/screens/auth/auth_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const riverpod.ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ReelProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey, // Now properly imported
            title: 'SolCare',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getTheme().copyWith(
              textTheme: GoogleFonts.poppinsTextTheme(
                themeProvider.getTheme().textTheme,
              ),
            ),
            home: const AuthScreen(),
          //  home: const AuthScreen(),
          );
        },
      ),
    );
  }
}
