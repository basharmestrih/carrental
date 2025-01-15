import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:carrentalapp/stripe_keys/key_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';


class SetYourRentPage extends StatefulWidget {
  const SetYourRentPage({super.key});

  @override
  State<SetYourRentPage> createState() => _SetYourRentPageState();
}

class _SetYourRentPageState extends State<SetYourRentPage> {
  int _currentStep = 0;
  Map<String, dynamic>? paymentIntent;
  final TextEditingController fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          //SizedBox(height: screenHeight * 0.001),
          Image.asset(
            'assets/rent-car.png',
            width: screenWidth * 0.555,
            height: screenHeight * 0.23,
            //fit: BoxFit.cover,
          ),
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
                onSurface: Colors.grey,
              ),
            ),
            child: Stepper(
              currentStep: _currentStep,
              //onStepTapped: (step) => setState(() => _currentStep = step),
              onStepContinue: _currentStep < 2
                  ? () => setState(() => _currentStep += 1)
                  : null,
              onStepCancel: _currentStep > 0
                  ? () => setState(() => _currentStep -= 1)
                  : null,
              controlsBuilder: (context, details) => StepperControls(
                details: details,
                isFinalStep: _currentStep == 2, 
              ),
              steps: [
                Step(
                  title:  Text('Personal',style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5),
                ),),
                  content: StepPersonalInfo(),
                  isActive: _currentStep >= 0,
                  state: _currentStep > 0
                      ? StepState.complete
                      : StepState.indexed,
                ),
                Step(
                  title:  Text('Date and Location',style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5),
                ),),
                  content: StepDateLocation(),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1
                      ? StepState.complete
                      : StepState.indexed,
                ),
                Step(
                  title:  Text('Complete',style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5),
                ),),
                  content: StepConfirmation(),
                  isActive: _currentStep >= 2,
                  state: _currentStep == 2
                      ? StepState.editing
                      : StepState.indexed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      // Retrieve carId from Hive
      var carBox = Hive.box('carBox');
      String? carId = carBox.get('carId');

      if (carId == null) {
        print("Error: Car ID is null.");
        return; // Exit if carId is not found
      }

      // Retrieve rental cost from Firestore
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('rental_orders')
          .doc(carId)
          .get();

      if (!docSnapshot.exists) {
        print("Error: Document does not exist.");
        return; // Exit if the document does not exist
      }

      // Get rental cost
      String? rentalCost = docSnapshot.get('rental_cost');

      if (rentalCost == null || rentalCost.isEmpty) {
        print("Error: Rental cost is null or empty.");
        return; // Exit if rental cost is not found or empty
      }

      // Retrieve currency from Hive (settings box)
      var settingsBox = Hive.box('seto');
      String favouriteCurrency = settingsBox.get('favoriteCurrency');

      // Convert rentalCost to integer amount (in smallest currency unit)
      String amount = (double.parse(rentalCost) * 100).toStringAsFixed(0);

      // Create payment intent
      paymentIntent = await createPaymentIntent(amount, favouriteCurrency);
      if (paymentIntent == null) {
        print("Error: Payment intent creation failed.");
        return; // Exit the function early if paymentIntent is null
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: true,
          merchantDisplayName: 'The Coder Brain',
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          allowsDelayedPaymentMethods: true,
        ),
      );

      await displayPaymentSheet();
    } catch (e) {
      print("Error in makePayment: ${e.toString()}");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'currency': currency,
        'amount': ((int.parse(amount)) * 100).toString(),
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $secret_key',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      print("Error in createPaymentIntent: ${e.toString()}");
      return null;
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then(
        (value) async {
          await Stripe.instance.confirmPaymentSheetPayment();
        },
      );
      paymentIntent = null;
    } on StripeException catch (e) {
      print("StripeException: ${e.toString()}");
    } catch (e) {
      print("Error in displayPaymentSheet: ${e.toString()}");
    }
  }
}

class StepperControls extends StatefulWidget {
  final ControlsDetails details;
  final bool isFinalStep;

  const StepperControls({
    Key? key,
    required this.details,
    this.isFinalStep = false,
  }) : super(key: key);

  @override
  _StepperControlsState createState() => _StepperControlsState();
}

class _StepperControlsState extends State<StepperControls> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final String selectedAge = ""; // Replace with actual age selection logic

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // If it's the final step, return an empty widget
    if (widget.isFinalStep) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.022),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () async {
              // Validation: Check if the full name exists and is true in Hive
              final userBox = Hive.box('user_nsme');

              if (userBox.get('isFullNameValid') != true || userBox.get('isAgeSelected') != true) {
                // Show a message if validation fails
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid full name'),
                    backgroundColor: Colors.red, // Set the background color to red
                  ),
                );
                return; // Stop execution if validation fails
              }

              // Call the continue function if validation passes
              widget.details.onStepContinue?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Button background color
            ),
            child: const Text(
              'Continue',
              style: TextStyle(color: Colors.white), // Button text color
            ),
          ),
          SizedBox(width: screenWidth * 0.022), // Add spacing between buttons
          OutlinedButton(
            onPressed: widget.details.onStepCancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}


class StepPersonalInfo extends StatefulWidget {
  @override
  _StepPersonalInfoState createState() => _StepPersonalInfoState();
}

class _StepPersonalInfoState extends State<StepPersonalInfo> {
  final TextEditingController fullNameController = TextEditingController();
  String? selectedAge;

  @override
  void initState() {
    super.initState();

    // Listener for full name validation
    fullNameController.addListener(() {
      final fullName = fullNameController.text.trim();
      if (fullName.isNotEmpty) {
        // Save `true` if full name is valid
        Hive.box('user_nsme').put('isFullNameValid', true);
        print('Full name is valid and saved to Hive');
      } else {
        // Save `false` if full name is cleared
        Hive.box('user_nsme').put('isFullNameValid', false);
        print('Full name is invalid and saved to Hive');
      }
    });

    // Load the selected age from Hive
    selectedAge = Hive.box('user_nsme').get('selectedAge', defaultValue: null);

    // Set the age selected status based on the saved value in Hive
    if (selectedAge != null && selectedAge!.isNotEmpty) {
      Hive.box('user_nsme').put('isAgeSelected', true);
      print('Age is selected and saved to Hive');
    } else {
      Hive.box('user_nsme').put('isAgeSelected', false);
      print('No age selected and saved as invalid to Hive');
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // Full Name Input Field
        TextField(
          controller: fullNameController,
          decoration: const InputDecoration(labelText: 'Full Name'),
        ),
        SizedBox(height: screenHeight * 0.0137),

        // Age Dropdown
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Age'),
          value: selectedAge,
          items: List.generate(100, (index) {
            final age = (index + 1).toString();
            return DropdownMenuItem(value: age, child: Text(age));
          }),
          onChanged: (value) {
            setState(() {
              selectedAge = value;

              // Save the selected age in Hive
              if (selectedAge != null && selectedAge!.isNotEmpty) {
                Hive.box('user_nsme').put('selectedAge', selectedAge);
                Hive.box('user_nsme').put('isAgeSelected', true); // Mark age as selected
                print('Age selected: $selectedAge');
              } else {
                Hive.box('user_nsme').put('isAgeSelected', false); // Mark age as not selected
                print('No age selected');
              }
            });
          },
        ),

        SizedBox(height: screenHeight * 0.0137),
        
        // Upload Driver License Button
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text(
              'Upload Driver License',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class StepDateLocation extends StatefulWidget {
  const StepDateLocation({Key? key}) : super(key: key);

  @override
  _StepDateLocationState createState() => _StepDateLocationState();
}

class _StepDateLocationState extends State<StepDateLocation> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  // Function to show OpenStreetMapSearchAndPick in BottomSheet
  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalContext) {
        return OpenStreetMapSearchAndPick(
          buttonTextStyle: const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
          buttonColor: Colors.blue,
          buttonText: 'Set Desired Location',
          onPicked: (pickedData) {
            // Update the location text field with the picked address
            setState(() {
              _locationController.text = pickedData.addressName ?? 'Unknown Location';
            });

            // Close the modal sheet after location selection
            Navigator.of(modalContext).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // Date Picker Field
        TextField(
          controller: _dateController,
          decoration: const InputDecoration(labelText: 'Pick Your Desired Date'),
          readOnly: true,
          onTap: () async {
            // Show date picker
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2024),
              lastDate: DateTime(2101),
            );

            if (selectedDate != null) {
              // Update the text field with the selected date
              setState(() {
                _dateController.text = "${selectedDate.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
              });
            }
          },
        ),
        SizedBox(height: screenHeight * 0.0137),

        // Location Picker Field
        TextField(
          controller: _locationController,
          decoration: const InputDecoration(labelText: 'Location'),
          readOnly: true, // Make the field read-only
          onTap: _showLocationPicker, // Show the map when tapped
        ),
      ],
    );
  }
}

class StepConfirmation extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final String selectedAge = ""; // Replace with actual age selection logic
  final String fileUrl = ""; // Replace with uploaded driver license file URL

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        const Text(
          'Done! Please just finish checkout to get your rent car ready',
          style: TextStyle(
            color: Colors.black, // Set the text color to black
            fontWeight: FontWeight.bold, // Set the text to bold
            fontSize: 18, // Adjust font size if needed
          ),
        ),
        SizedBox(height: screenHeight * 0.0137),
        ElevatedButton(
          onPressed: () async {
            // Retrieve carId from Hive
            var box = Hive.box('carBox');
            String? carId = box.get('carId');

            if (carId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: Car ID is missing.')),
              );
              return;
            }

            // Gather input data
            final updatedData = {
              'fullName': fullNameController.text,
              'age': selectedAge,
              'date': dateController.text,
              'location': locationController.text,
              'driverLicenseUrl': fileUrl, // Assuming fileUrl is set after uploading
            };

            try {
              // Update Firestore document
              await FirebaseFirestore.instance
                  .collection('rental_orders')
                  .doc(carId) // Use carId as document ID
                  .update(updatedData);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Details updated successfully!')),
              );

              // Call makePayment function
              _SetYourRentPageState? parentState =
                  context.findAncestorStateOfType<_SetYourRentPageState>();
              if (parentState != null) {
                await parentState.makePayment();

                // Show the confirmation popup after payment
                _showConfirmationDialog(context);
              } else {
                throw Exception("Parent state not found!");
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error updating document: $e')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Set button background color to black
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(color: Colors.white), // Button text color to white
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: const Text(
            'Your checkout has been done and your order is available till Monday 2 AM.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}



