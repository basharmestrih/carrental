import 'package:carrentalapp/main_app/Routing_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class VerifyAccountPage extends StatelessWidget {
  final String userEmail;
  final String userPassword;


  VerifyAccountPage({required this.userEmail , required this.userPassword});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; 

  // Method to send the verification email
  Future<void> sendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('Verification email sent to $userEmail');
      }
    } catch (e) {
      print('Failed to send verification email: $e');
    }
  }

  // Method to check email verification status
  Future<bool> isEmailVerified() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload(); // Reload user data to check the latest status
        return user.emailVerified;
      }
    } catch (e) {
      print('Error checking email verification: $e');
    }
    return false;
  }


Future<void> verifyAndAddUser() async {
  try {
    final user = _auth.currentUser;
    if (user != null && user.emailVerified) {
      // Add user to verified_users collection
      await _firestore.collection('verified_users').doc(user.uid).set({
        'email': userEmail,
        'password': userPassword, // Store password or hashed password if needed
        'verified': true,
      });

      print('User added to verified_users collection');

      // Enable the isLoggedIn value in Hive
      final preferencesBox = await Hive.openBox('preferences');
      await preferencesBox.put('isLoggedIn', true);

      print('isLoggedIn set to true in Hive');
    }
  } catch (e) {
    print('Error adding user to Firestore or Hive: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify your account',
          style: GoogleFonts.dancingScript(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Help action here
            },
          ),
        ],
      ),
      drawer: const Drawer(), // Placeholder for drawer menu
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Here we go ... last step before you start your tour in the app',
              style: GoogleFonts.dancingScript(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[300],
              child: Text(
                'We sent a verification link to your email. Click Proceed if you have activated your account.',
                style: GoogleFonts.dancingScript(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'If you did not get a verification link, click Resend email below.',
              style: GoogleFonts.dancingScript(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.dancingScript(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool isVerified = await isEmailVerified();
                    if (isVerified) {
                      // Navigate to the RoutingPage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoutingPage(),
                        ),
                      );
                      await verifyAndAddUser();
                    } else {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email not verified. Please verify your email first.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    'Proceed',
                    style: GoogleFonts.dancingScript(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendVerificationEmail();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text(
                'Resend email',
                style: GoogleFonts.dancingScript(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
