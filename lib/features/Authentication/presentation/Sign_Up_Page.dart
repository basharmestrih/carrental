import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:carrentalapp/features/Authentication/presentation/Activation_Page.dart';
import 'package:carrentalapp/features/Authentication/application/Firebase_Proider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFE7E5E5),
      appBar: AppBar(
        backgroundColor:  const Color(0xFF2C2B2A),
        title: const Text(
          'Create your account',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Start creating your account by adding your email and your password',
              style: GoogleFonts.oswald(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.black,),
            ),
            const SizedBox(height: 1),
            Center(child: Image.asset('assets/protection.png',height: 200,width: 200,semanticLabel: 'Airplane icon by Hasymi - Flaticon',)),
                        
                        
                       
                      
            const SizedBox(height: 25),
            // Email field
            Text('EMAIL',style: GoogleFonts.oswald(fontWeight: FontWeight.bold,color: Colors.black,),),
             TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.check,color: Colors.black,),
                label: Text('Add your email here',style: TextStyle(
                fontWeight: FontWeight.bold,
                color:Colors.black,
                ),)
                    ),
                  ),
            const SizedBox(height: 20),
            // Password field
            Text('PASSWORD',style: GoogleFonts.oswald(fontWeight: FontWeight.bold,color: Colors.black,),),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.check,color: Colors.black,),
                label: Text('Create your password',style: TextStyle(
                fontWeight: FontWeight.bold,
                color:Colors.black,
                ),)
                    ),
            ),
            const SizedBox(height: 20),
            // Confirm Password field
            Text('CONFIRM PASSWORD',style: GoogleFonts.oswald(fontWeight: FontWeight.bold,color: Colors.black,),),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.check,color: Colors.black,),
                label: Text('Confirm your password',style: TextStyle(
                fontWeight: FontWeight.bold,
                color:Colors.black,
                ),)
                    ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle cancel action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:const Color(0xFF2C2B2A),
                  ),
                  child: Text('Cancel',style: GoogleFonts.oswald(fontWeight: FontWeight.bold,color: Colors.white,),),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validate password confirmation
                    if (_passwordController.text == _confirmPasswordController.text) {
                      try {
                        // Sign up using AuthService
                        await Provider.of<AuthProviders>(context, listen: false)
                            .signUp(_emailController.text, _passwordController.text);

                        // Show a success message
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Verification link sent. Please check your email.'),
                        ));

                        // Navigate to the HomePage after successful sign-up
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyAccountPage(
                          userEmail: _emailController.text,
                          userPassword: _passwordController.text,
                        ),
                        ),
                      );
                      } catch (e) {
                        // Show an error message if sign-up fails
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Sign up failed: ${e.toString()}'),
                        ));
                      }
                    } else {
                      // Show error if passwords do not match
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Passwords do not match.'),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2B2A),
                  ),
                  child: Text(
                    'Proceed',
                    style: GoogleFonts.alatsi(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
