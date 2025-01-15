// auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProviders with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Initialize Google Sign-In

  User? get currentUser => _auth.currentUser;

  // Sign up method
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } catch (e) {
      throw Exception('Sign up failed: $e'); // Better error handling
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // Sign-in aborted by user
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      notifyListeners(); // Notify listeners after sign in
      return user;
    } catch (e) {
      print('Google sign-in failed: $e'); // Improved error message
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // Authenticate the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optionally, fetch the FCM token here
      // final String fcmToken = await FirebaseMessaging.instance.getToken();
      // print('FCM Token: $fcmToken');

      print('Login successful and FCM token fetched');
    } catch (e) {
      print('Login failed: $e'); // Improved error message
      throw Exception('Login failed: $e'); // Throw exception for better handling
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
