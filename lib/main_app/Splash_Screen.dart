import 'package:carrentalapp/features/Authentication/presentation/Login_Page.dart';
import 'package:carrentalapp/Localization/generated/l10n.dart';
import 'package:carrentalapp/main_app/Routing_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to LoginPage after a delay
    _navigateToLoginPage();
  }

  void _navigateToLoginPage() async {
    // Open Hive box
    final preferencesBox = await Hive.openBox('preferences');
    final bool isLoggedIn = preferencesBox.get('isLoggedIn', defaultValue: false);

    // Navigate based on isLoggedIn value
    Future.delayed(const Duration(seconds: 4), () { // Reduced delay for quicker navigation
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RoutingPage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Show splash screen content
    return Scaffold(
      backgroundColor: const Color(0xFF2C2B2A), // Splash background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image displayed on the splash screen
            Image.asset(
              'assets/vehicle.png', // Path to your splash image
              width: screenWidth * 0.5, // Responsive width
              height: screenWidth * 0.5, // Responsive height
            ),
            SizedBox(height: screenHeight * 0.03), // Spacing
            // Display localized greeting
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                 'Rento Club',
                
                  style: GoogleFonts.permanentMarker(
                  textStyle: TextStyle(color: Colors.grey,fontSize: screenHeight * 0.05, letterSpacing: .5),
                ), // Responsive font size
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01), // Spacing
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
