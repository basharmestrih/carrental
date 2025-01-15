import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

// Import other pages
import 'package:carrentalapp/features/Authentication/presentation/Login_Page.dart';
import 'package:carrentalapp/features/Fetch_Orders/presentation/My_Orders.dart';
import 'package:carrentalapp/features/Fetch_Cars/presentation/All_Cars_Page.dart.dart';
import 'package:carrentalapp/features/Fetch_Gas_Stations/presentation/Gas_Stations_Page.dart';
import 'package:carrentalapp/features/Fetch_Cars/presentation/Home_Page.dart';
import 'package:carrentalapp/features/Fetch_Cars/presentation/My_Cars_Page.dart';
import 'package:carrentalapp/features/Set_Rent/presentation/Set_Your_Rent_Page.dart';
import 'package:carrentalapp/features/Settings/presentation/Settings_Page.dart';

class RoutingPage extends StatefulWidget {
  @override
  _RoutingPageState createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  int _currentIndex = 0;
  late String _scaffoldColor;
  late Box settingsBox;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeSettings();

    // Check for index passed through arguments from another page
   final arguments = ModalRoute.of(context)?.settings.arguments;
if (arguments is int) {
  _currentIndex = arguments; // Update the index only if an integer is passed
}

  }
  //updaste theme
  void _initializeSettings() async {
    settingsBox = await Hive.openBox<String>('colorssettings');
    _scaffoldColor = settingsBox.get('scaffoldColor', defaultValue: 'grey300')!;
    setState(() {});
  }

  // Define the list of pages
  final List<Widget> _pages = [
    const HomePage(),
    const Allcarspage(),
    const GasStationsPage(),
     SetYourRentPage(),
    MyCarsPage(),
  ];

  // Define the list of titles
  final List<String> _titles = [
    'Home',
    'All Cars',
    'Gas Stations',
    'Set Your Rent',
    'My Cars',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getColorFromName(_scaffoldColor),
      appBar: _buildAppBar(),
      drawer: AppDrawer(onTapNavigate: _navigateToPage),
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
  leading: Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.menu), // Left icon
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Opens the drawer
        },
      );
    },
  ),
  title: Text(
    _titles[_currentIndex], // Update the AppBar title dynamically
    style: GoogleFonts.chauPhilomeneOne(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  backgroundColor: Colors.grey[300],
  actions: [
    IconButton(
      icon: const Icon(Icons.search), // Right icon
      onPressed: () {
        // Add functionality for right icon here
      },
    ),
    IconButton(
      icon: const Icon(Icons.settings), // Right icon
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
      },
    ),
    IconButton(
      icon: const Icon(Icons.home), // Right icon
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
    ),
  ],
);
  }

  CurvedNavigationBar _buildBottomNavigationBar() {
    return CurvedNavigationBar(
      index: _currentIndex,
      height: 60.0,
      items: const <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.car_crash, size: 30, color: Colors.white),
        Icon(Icons.gas_meter, size: 30, color: Colors.white),
        Icon(Icons.create, size: 30, color: Colors.white),
        Icon(Icons.favorite, size: 30, color: Colors.white),
      ],
      color: const Color(0xFF2C2B2A),
      buttonBackgroundColor: const Color(0xFF2C2B2A),
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
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
}

class AppDrawer extends StatelessWidget {
  final Function(Widget) onTapNavigate;

  const AppDrawer({required this.onTapNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2C2B2A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF2C2B2A),
            ),
            child: Text(
              'Menu',
              style: GoogleFonts.chauPhilomeneOne(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          _buildDrawerTile(
            context,
            icon: Icons.home,
            label: 'Home',
            page: const HomePage(),
          ),
          _buildDrawerTile(
            context,
            icon: Icons.car_rental,
            label: 'All Cars',
            page: const Allcarspage(),
          ),
          _buildDrawerTile(
            context,
            icon: Icons.face,
            label: 'Gas Stations',
            page: const GasStationsPage(),
          ),
          _buildDrawerTile(
            context,
            icon: Icons.edit,
            label: 'Set Your Rent',
            page:  SetYourRentPage(),
          ),
          _buildDrawerTile(
            context,
            icon: Icons.favorite,
            label: 'My Orders',
            page: MyOrders(),
          ),
          _buildDrawerTile(
            context,
            icon: Icons.settings,
            label: 'Settings',
            page: const SettingsPage(),
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerTile(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Widget page,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        label,
        style: GoogleFonts.oswald(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      onTap: () => onTapNavigate(page),
    );
  }
}
