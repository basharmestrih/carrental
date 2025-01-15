import 'package:carrentalapp/features/Fetch_Gas_Stations/presentation/Gas_Stations_Page.dart';
import 'package:carrentalapp/features/Fetch_Cars/presentation/All_Cars_Page.dart.dart';
import 'package:carrentalapp/features/Fetch_Cars/presentation/Home_Page.dart';
import 'package:carrentalapp/features/Fetch_Orders/application/Orders_Cubit.dart';
import 'package:carrentalapp/features/Fetch_Orders/application/Orders_State.dart';
import 'package:carrentalapp/features/Set_Rent/presentation/Set_Your_Rent_Page.dart';
import 'package:carrentalapp/features/Settings/presentation/Settings_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carrentalapp/features/Fetch_Orders/data/Orders_Repo.dart';
import 'package:carrentalapp/features/Fetch_Orders/data/Orders_Web_Sers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(OrdersRepository(OrdersWebServices()))..getAllOrdersFunctions(),
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersFetched) {
            return OrdersPage(orders: state.orders);
          } else {
            return const Center(child: Text('Error loading orders'));
          }
        },
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  final List orders;

  const OrdersPage({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: const OrdersAppBar(),
      ),
      //drawer: AppDrawer(onTapNavigate: _navigateToPage),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return OrderCard(car: orders[index]);
          },
        ),
      ),
    );
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


class OrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrdersAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, size: screenWidth * 0.06),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Text(
        'My Orders',
        style: GoogleFonts.oswald(
          fontSize: screenWidth * 0.07,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.grey[300],
      actions: [
        IconButton(
          icon: Icon(Icons.search, size: screenWidth * 0.06),
          onPressed: () {
            // Add search functionality
          },
        ),
        IconButton(
          icon: Icon(Icons.settings, size: screenWidth * 0.06),
          onPressed: () {
            // Add settings functionality
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class OrdersDrawer extends StatelessWidget {
  const OrdersDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      backgroundColor: const Color(0xFF2C2B2A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: screenHeight * 0.2,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF2C2B2A)),
              child: Text(
                'Menu',
                style: GoogleFonts.oswald(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, size: screenWidth * 0.06, color: Colors.grey),
            title: Text(
              'Home',
              style: GoogleFonts.oswald(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              // Navigate to home
            },
          ),
          // Add other menu items here
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final car;

  const OrderCard({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.005, screenWidth * 0.04, screenHeight * 0.02),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              child: Image.asset(
                'assets/peugeot-brand-logo-symbol-with-name-black-design-french-car-automobile-illustration-free-vector.jpg',
                width: screenWidth * 0.28,
                height: screenHeight * 0.15,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: screenWidth * 0.05),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRow(label: 'Car Brand', value: car.brandname),
                  Divider(thickness: 2, color: Colors.black),
                  InfoRow(label: 'Engine Type', value: car.engine),
                  Divider(thickness: 2, color: Colors.grey),
                  InfoRow(label: 'Rental Cost', value: '\$${car.rentalcost}/day'),
                  Divider(thickness: 2, color: Colors.grey),
                  StatusRow(),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Cancel order functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.02),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                       
                          style: GoogleFonts.chauPhilomeneOne(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: screenWidth * 0.035
                        ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Implement InfoRow and StatusRow similarly with responsive sizes



// Info Row Widget
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: screenWidth * 0.035, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: screenWidth * 0.035, // Responsive font size
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

// Status Row Widget
class StatusRow extends StatelessWidget {
  const StatusRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Status',
          style: GoogleFonts.oswald(
            fontSize: screenWidth * 0.035, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            Text(
              'availability',
              style: GoogleFonts.chauPhilomeneOne(
                fontSize: screenWidth * 0.035, // Responsive font size
                color: Colors.red,
              ),
            ),
            SizedBox(width: screenWidth * 0.01), // Responsive spacing
            Icon(
              Icons.check_circle,
              color: Colors.red,
              size: screenWidth * 0.05, // Responsive icon size
            ),
          ],
        ),
      ],
    );
  }
}
