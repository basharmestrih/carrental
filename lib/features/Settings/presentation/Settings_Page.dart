import 'package:carrentalapp/features/Fetch_Cars/presentation/Home_Page.dart';
import 'package:carrentalapp/main.dart';
import 'package:carrentalapp/main_app/Routing_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart'; // Import Hive


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _scaffoldColor; 
  late Box settingsBox;
  
  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  void _initializeSettings() async {
    settingsBox = await Hive.openBox<String>('colorssettings');
    _scaffoldColor = settingsBox.get('scaffoldColor', defaultValue: 'grey300')!;
    setState(() {});
  }

  void _toggleDarkMode(bool isDarkMode) {
    setState(() {
      _scaffoldColor = isDarkMode ? 'black' : 'grey300';
    });
    settingsBox.put('scaffoldColor', _scaffoldColor);
  }

  Color _getColorFromName(String colorName) {
    switch (colorName) {
      case 'black':
        return const Color.fromARGB(255, 237, 30, 7);
      case 'grey300':
        return Colors.grey[300]!;
      default:
        return Colors.grey[300]!;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _getColorFromName(_scaffoldColor),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.chauPhilomeneOne(fontSize: screenHeight * 0.041, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RoutingPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.056),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.027),
            const LanguageSection(),
            SizedBox(height: screenHeight * 0.014),
            const ProfileSection(),
            SizedBox(height: screenHeight * 0.014),
            const RentingDetailsSection(),
            SizedBox(height: screenHeight * 0.027),
            ThemeSection(
              scaffoldColor: _scaffoldColor,
              onToggleDarkMode: (bool isDarkMode) {
                _toggleDarkMode(isDarkMode);
              },
            ),
            SizedBox(height: screenHeight * 0.027),
            const NotificationsSection(),
            const UserExperienceSection(),
          ],
        ),
      ),
    );
  }
}

class SettingsTitle extends StatelessWidget {
  final String title;

  const SettingsTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Text(
      title,
      style: TextStyle(fontSize: screenHeight * 0.033, fontWeight: FontWeight.bold),
    );
  }
}

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  Future<void> _showLanguagePopup(BuildContext context) async {
    double screenHeight = MediaQuery.of(context).size.height;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choose App Language',
            style: GoogleFonts.chauPhilomeneOne(
              fontSize: screenHeight * 0.027,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 7, 157, 221),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English', style: GoogleFonts.alatsi(fontSize: screenHeight * 0.025)),
                onTap: () async {
                  final langBox = await Hive.openBox<String>('applanguage');
                  await langBox.put('language', 'en'); 
                  Navigator.of(context).pop();
                  _showRestartDialog(context);
                },
              ),
              ListTile(
                title: Text('French', style: GoogleFonts.alatsi(fontSize: screenHeight * 0.025)),
                onTap: () async {
                  final langBox = await Hive.openBox<String>('applanguage');
                  await langBox.put('language', 'fr'); 
                  _showRestartDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRestartDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restart App'),
          content: const Text(
              'App should be restarted to set the new language. Please restart the app to apply changes.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                runApp(MyApp());
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Language and Time zone:',
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: screenHeight * 0.033,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 7, 157, 221),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(
            'App Language',
            style: GoogleFonts.chauPhilomeneOne(
              fontSize: screenHeight * 0.025,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _showLanguagePopup(context),
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(
            'Time Zone',
            style: GoogleFonts.chauPhilomeneOne(
              fontSize: screenHeight * 0.025,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        Divider(thickness: screenHeight * 0.007, color: Colors.black),
      ],
    );
  }
}



class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile:',
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: screenHeight * 0.033,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 7, 157, 221),
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Phone'),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: screenHeight * 0.027),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text('Cancel', style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
                ),),
              ),
            ),
            SizedBox(width: screenWidth * 0.028),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text('Save Changes', style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
                ),),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.014),
        Divider(thickness: screenHeight * 0.007, color: Colors.black),
      ],
    );
  }
}

class RentingDetailsSection extends StatefulWidget {
  const RentingDetailsSection({super.key});

  @override
  _RentingDetailsSectionState createState() => _RentingDetailsSectionState();
}

class _RentingDetailsSectionState extends State<RentingDetailsSection> {
  List<bool> _isSelected = [true, false];
  String _favoriteCurrency = 'USD';
  String _selectedPaymentMethod = 'PayPal';
  final List<String> _paymentMethods = ['PayPal', 'Skrill', 'Cryptocurrency'];

  @override
  void initState() {
    super.initState();
    _loadFavoriteCurrency();
    _loadPaymentMethod();
  }

  void _loadFavoriteCurrency() {
    final box = Hive.box<String>('settings');
    String? storedCurrency = box.get('favoriteCurrency');
    if (storedCurrency != null) {
      _favoriteCurrency = storedCurrency;
      _isSelected = storedCurrency == 'Dollar' ? [true, false] : [false, true];
    }
  }

  void _loadPaymentMethod() {
    final box = Hive.box<String>('settings');
    String? storedMethod = box.get('paymentMethod');
    if (storedMethod != null) {
      _selectedPaymentMethod = storedMethod;
    }
  }

  void _toggleCurrency(int index) {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = i == index;
      }
      _favoriteCurrency = index == 0 ? 'USD' : 'EUR';
    });

    Hive.openBox('seto');
    final box = Hive.box('seto');
    box.put('favoriteCurrency', _favoriteCurrency);
    print(_favoriteCurrency);
  }

  void _selectPaymentMethod(String? newMethod) {
    if (newMethod != null) {
      setState(() {
        _selectedPaymentMethod = newMethod;
      });

      final box = Hive.box<String>('settings');
      box.put('paymentMethod', _selectedPaymentMethod);
    }
  }

  void _showPaymentMethodBottomSheet() {
    double screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(screenHeight * 0.022),
          height: screenHeight * 0.343,
          child: Column(
            children: [
              Text(
                'Select Payment Method',
                style: TextStyle(fontSize: screenHeight * 0.027, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.014),
              Expanded(
                child: ListView.builder(
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_paymentMethods[index], style: TextStyle(fontSize: screenHeight * 0.022)),
                      onTap: () {
                        _selectPaymentMethod(_paymentMethods[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Renting Details:',
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: screenHeight * 0.033,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 7, 157, 221),
          ),
        ),
        SizedBox(height: screenHeight * 0.014),
        Text(
          'Favourite currency: ',
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: screenHeight * 0.025,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ToggleButtons(
                isSelected: _isSelected,
                borderRadius: BorderRadius.circular(8.0),
                selectedColor: Colors.black,
                fillColor: Colors.red,
                color: Colors.black,
                onPressed: _toggleCurrency,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.044),
                    child: Text('Dollar', style: TextStyle(fontSize: screenHeight * 0.02)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.044),
                    child: Text('Euro', style: TextStyle(fontSize: screenHeight * 0.02)),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.027),
        ListTile(
          leading: const Icon(Icons.payment),
          title: Text('Set your payment method', style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5),
                ),),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _showPaymentMethodBottomSheet,
          ),
        ),
        Text(
          'Selected payment method: $_selectedPaymentMethod',
          style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: screenHeight * 0.022),
                ),
        ),
      ],
    );
  }
}


class ThemeSection extends StatelessWidget {
  final String scaffoldColor;
  final ValueChanged<bool> onToggleDarkMode;

  const ThemeSection({
    super.key,
    required this.scaffoldColor,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 5, color: Colors.black),
        const SizedBox(height: 10),
        Text(
          'App Theme',
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 7, 157, 221),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enable dark mode',
              style: GoogleFonts.chauPhilomeneOne(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 5),
            Switch(
              value: scaffoldColor == 'black',
              onChanged: onToggleDarkMode,
            ),
          ],
        ),
      ],
    );
  }
}


class NotificationsSection extends StatefulWidget {
  const NotificationsSection({super.key});

  @override
  _NotificationsSectionState createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<NotificationsSection> {
  bool isSubscribed = false; // Initial switch value (off)
  int userId = 1; // Example user ID, you can replace this with actual logic to get user ID

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 5, color: Colors.black),
        const SizedBox(height: 10),
         Text(
          'Gas Prices Service',
         style: GoogleFonts.chauPhilomeneOne(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 7, 157, 221),
      ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text('Subscribe Gas Prices Service',style: GoogleFonts.chauPhilomeneOne(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),),
            const SizedBox(width: 5),
            Switch(
              value: isSubscribed,
              onChanged: (value) async {
                setState(() {
                  isSubscribed = value; // Update local state
                });

                if (value) {
                  // Create a new document in Firestore with a unique name
                  await FirebaseFirestore.instance
                      .collection('notification_service_customers')
                      .doc('user$userId') // Create document name like user1, user2, etc.
                      .set({
                    'sub_id': 'e587we3', // Set the sub_id field
                  });

                  // Increment userId for the next subscription (example logic)
                  userId++;
                } else {
                  // Optional: Add logic to unsubscribe (if needed)
                  // For example, you might want to delete the document
                  await FirebaseFirestore.instance
                      .collection('notification_service_customers')
                      .doc('user$userId')
                      .delete();
                }
              },
            ),
          ],
        ),
        //const Divider(thickness: 5, color: Colors.black),
      ],
      
    );
    
  }
}




class UserExperienceSection extends StatefulWidget {
  const UserExperienceSection({super.key});

  @override
  _UserExperienceSectionState createState() => _UserExperienceSectionState();
}

class _UserExperienceSectionState extends State<UserExperienceSection> {
  late Box preferencesBox;
  bool isSingaporeSelected = false;
  bool isUAESelected = false;
  bool isLoading = true;

  // Maintain a map for selected brands
  Map<String, bool> selectedBrands = {
    'Brand 1': false,
    'Brand 2': false,
    'Brand 3': false,
    'Brand 4': false,
    'Brand 5': false,
    'Brand 6': false,

  };

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  void _initializePreferences() async {
    preferencesBox = await Hive.openBox('userPreferences');
    setState(() {
      isSingaporeSelected = preferencesBox.get('singaporeSelected', defaultValue: false) as bool;
      isUAESelected = preferencesBox.get('uaeSelected', defaultValue: false) as bool;

      // Load brand selections or set defaults
      selectedBrands = preferencesBox.get('selectedBrands', defaultValue: selectedBrands)
          as Map<String, bool>;
      isLoading = false;
    });
  }

  void _updateSelection(String location, bool value) {
    setState(() {
      if (location == 'Singapore') {
        isSingaporeSelected = value;
        preferencesBox.put('singaporeSelected', value);
      } else if (location == 'UAE') {
        isUAESelected = value;
        preferencesBox.put('uaeSelected', value);
      }
    });
  }

  void _updateBrandSelection(String brand, bool value) {
    setState(() {
      selectedBrands[brand] = value;
      preferencesBox.put('selectedBrands', selectedBrands); // Save updated brands to Hive
    });
  }

  @override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(thickness: screenHeight * 0.007, color: Colors.black),
        SizedBox(height: screenHeight * 0.014),
        Text(
          'Customize Your Experience',
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: screenHeight * 0.033,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 7, 157, 221),
          ),
        ),
        SizedBox(height: screenHeight * 0.007),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Desired gas station location',
              style: GoogleFonts.chauPhilomeneOne(
                fontSize: screenHeight * 0.025,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.014),
        // First Row: Singapore
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Singapore',
              style: GoogleFonts.chauPhilomeneOne(
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Checkbox(
              value: isSingaporeSelected,
              onChanged: (bool? value) {
                _updateSelection('Singapore', value ?? false);
              },
              activeColor: const Color.fromARGB(255, 7, 157, 221),
            ),
          ],
        ),
        // Second Row: UAE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'UAE',
              style: GoogleFonts.chauPhilomeneOne(
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Checkbox(
              value: isUAESelected,
              onChanged: (bool? value) {
                _updateSelection('UAE', value ?? false);
              },
              activeColor: const Color.fromARGB(255, 7, 157, 221),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.027),
        // Title: Your Favourite Brands
        Text(
          'Your Favourite Brands',
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: screenHeight * 0.025,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: screenHeight * 0.014),
        // Brands (6 per row)
        Column(
          children: [
            _buildBrandRow(['Brand 1', 'Brand 2', 'Brand 3']),
            _buildBrandRow(['Brand 4', 'Brand 5', 'Brand 6']),
          ],
        ),
      ],
    ),
  );
}

// Helper method to build a row of brands with checkboxes
Widget _buildBrandRow(List<String> brands) {
  double screenHeight = MediaQuery.of(context).size.height;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: brands.map((brand) {
        return Expanded(
          child: Row(
            children: [
              Checkbox(
                value: selectedBrands[brand] ?? false,
                onChanged: (bool? value) {
                  _updateBrandSelection(brand, value ?? false);
                },
              ),
              Expanded(
                child: Text(
                  brand,
                  style: GoogleFonts.chauPhilomeneOne(
                    fontSize: screenHeight * 0.018,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
}