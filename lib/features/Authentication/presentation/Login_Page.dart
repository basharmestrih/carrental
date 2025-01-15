import 'package:carrentalapp/features/Authentication/presentation/Sign_Up_Page.dart';
import 'package:carrentalapp/features/Authentication/application/Firebase_Proider.dart';
import 'package:carrentalapp/Localization/generated/l10n.dart';
import 'package:carrentalapp/main_app/Routing_Page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Localization import
import 'package:carrentalapp/features/Set_Rent/presentation/MapTest.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
     double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF2C2B2A),
      body: SafeArea(
        child: Stack(
          children: [
            TopContainer(
              emailController: emailController,
              passwordController: passwordController,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            BottomContainer(
              emailController: emailController,
              passwordController: passwordController,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ],
        ),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final double screenWidth;
  final double screenHeight;

  const TopContainer({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.8,
      width: double.infinity,
      color: const Color(0xFF2C2B2A), // Black color
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.02),
          Image.asset(
            'assets/car.png',
            width: screenWidth * 0.7,
            height: screenHeight * 0.25,
          ),
           SizedBox(height: screenHeight * 0.03),
          Text(
            S.of(context).bestPlaceToRide, // Localized string
           style: GoogleFonts.permanentMarker(
                  textStyle: TextStyle(color: Colors.grey,fontSize: screenHeight * 0.035, letterSpacing: .5),
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.03),
          _buildTextField(
            controller: emailController,
            hintText: S.of(context).email, // Localized string
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: passwordController,
            hintText: S.of(context).password, // Localized string
            prefixIcon: Icons.lock_outline,
            isPassword: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF3C3B3A),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(prefixIcon, color: Colors.white.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding:  EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.07),
        ),
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
   final double screenWidth;
  final double screenHeight;

  const BottomContainer({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight * 0.25,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFE7E5E5), // White color
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(200),
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.only(top: screenHeight * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LoginButton(
                emailController: emailController,
                passwordController: passwordController,
                 screenWidth: screenWidth,
                  screenHeight: screenHeight,
              ),
               SizedBox(height: screenHeight * 0.005),
               SignUpButton(screenWidth: screenWidth,
               screenHeight: screenHeight,
               ),
              //SizedBox(height: screenHeight * 0.005),
              Padding(
                padding:  EdgeInsets.only(top: screenHeight * 0.00005),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    S.of(context).continueWith, // Localized string

                    style: GoogleFonts.bebasNeue(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.w600,),
                ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.001),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon:  Icon(Icons.facebook, color: Colors.blue),
                    iconSize: 40,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.email_outlined, color: Colors.red),
                    iconSize: 40.0,
                    onPressed: () async {
                      try {
                        final user = await context.read<AuthProviders>().signInWithGoogle();
                        if (user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(S.of(context).googleLoginSuccess)),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RoutingPage()),
                          );
                        }
                      } catch (e) {
                       
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final double screenWidth;
  final double screenHeight;

  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
     required this.screenWidth,
      required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await context.read<AuthProviders>().login(emailController.text, passwordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).loginSuccess)),
          );
        } catch (e) {
          
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2C2B2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.001),
      ),
      child: Text(
        S.of(context).loginbutton,
        style: GoogleFonts.anton(
                  textStyle: TextStyle(color: Colors.grey, letterSpacing: .5,),
                ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const SignUpButton({super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RoutingPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2C2B2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight* 0.001),
      ),
      child: Text(
        S.of(context).signUpEmail, // Localized string
        style: GoogleFonts.anton(
                  textStyle: TextStyle(color: Colors.grey, letterSpacing: .5,),
                ),
      ),
    );
  }
}
