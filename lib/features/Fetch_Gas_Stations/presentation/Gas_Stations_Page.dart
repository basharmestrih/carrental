import 'dart:convert';
import 'dart:math';
import 'package:carrentalapp/features/Fetch_Gas_Stations/application/Gas_Cubit.dart';
import 'package:carrentalapp/features/Fetch_Gas_Stations/application/Gas_State.dart';
import 'package:carrentalapp/features/Fetch_Gas_Stations/domain/Gas_Model.dart';
import 'package:carrentalapp/features/Fetch_Gas_Stations/data/Gas_Repo.dart';
import 'package:carrentalapp/features/Fetch_Gas_Stations/data/Gas_Web_Sers.dart';
import 'package:carrentalapp/features/Settings/presentation/Settings_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http; // For sending HTTP requests



class GasStationsPage extends StatefulWidget {
  const GasStationsPage({super.key});

  @override
  State<GasStationsPage> createState() => _GasStationsPageState();
}

class _GasStationsPageState extends State<GasStationsPage> {
  late String fetchValue;

  @override
  void initState() {
    super.initState();
    // Initialize fetchValue based on Hive preferences
    final box = Hive.box('userPreferences');
    final singaporeSelected = box.get('singaporeSelected');
    final uaeSelected = box.get('uaeSelected');

    if (singaporeSelected) {
      fetchValue = "true";
    } else if (uaeSelected) {
      fetchValue = "false";
    } else {
      fetchValue = "false"; // Default case
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return BlocProvider(
      create: (context) =>
          FuelPriceCubit(FuelPriceRepository(FuelPriceService()))..fetchFuelPrice(fetchValue),
      child: GasStationsContent(screenWidth: screenWidth, screenHeight: screenHeight),
    );
  }
}

class GasStationsContent extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const GasStationsContent({super.key, required this.screenWidth, required this.screenHeight});

  @override
  _GasStationsContentState createState() => _GasStationsContentState();
}

class _GasStationsContentState extends State<GasStationsContent> {
  bool isDieselSelected = false;
  bool isCompletedSelected = false;
  bool isNotCompletedSelected = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: widget.screenHeight * 0.127, // Adjust position as needed
          child: Container(
            width: widget.screenWidth * 1.25, // Adjust the size as per your requirements
            height: widget.screenHeight * 1.1,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/sven-brandsma-HyhFd9xT82k-unsplash.jpg'), // Replace with your asset path
                //fit: BoxFit.cover, // Adjust how the image is displayed within the container
              ),
              borderRadius: BorderRadius.circular(12), // Optional: to add rounded corners
            ),
          ),
        ),

        Positioned(
          right: 0,
          top: widget.screenHeight * 0.3,
          bottom: 0,
          child: ClipPath(
            clipper: HalfCircleClipper(),
            child: Container(
              width: widget.screenWidth * 1.25,
              color: const Color(0xFF2C2B2A),
              child: Stack(
                children: [
                  Positioned(
                    top: widget.screenHeight * 0.07, 
                    left: widget.screenWidth * 0.347,
                    child: const GasStationsHeader(),
                  ),
                  Positioned(
                    top: widget.screenHeight * 0.12, 
                    left: widget.screenWidth * 0.28,
                    child: const GasStationsHeader2(),
                  ),
        
                  
                  Positioned(
                    top: widget.screenHeight * 0.160,
                    left: 0,
                    right: 0,
                    bottom: widget.screenHeight * 0.025, // Adjusted to leave space for the button
                    child: BlocBuilder<FuelPriceCubit, FuelPriceState>(
                      builder: (context, state) {
                        if (state is FuelPriceLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is FuelPriceLoaded) {
                          return DataTableWidget(fuelData: state.fuelPrice);
                        } else if (state is FuelPriceFiltered) {
                          return DataTableWidget(fuelData: state.filteredFuelPrices);
                        } else if (state is FuelPriceError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return const Center(child: Text('Select a fuel type'));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GasStationsHeader extends StatelessWidget {
  const GasStationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Gas Stations Dealers',
      style: GoogleFonts.chauPhilomeneOne(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }
}

class GasStationsHeader2 extends StatelessWidget {
  const GasStationsHeader2({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'To change location of gas stations go to ',
            style: GoogleFonts.chauPhilomeneOne(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          TextSpan(
            text: 'Settings',
            style: GoogleFonts.oswald(
              
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              decoration: TextDecoration.underline, 
            ),
            recognizer: TapGestureRecognizer()..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}




class DataTableWidget extends StatelessWidget {
  final List<FuelPrice> fuelData;

  const DataTableWidget({Key? key, required this.fuelData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2B2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns:  [
            DataColumn(label: Text('User ID', style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.grey,),
                ),)),
            DataColumn(label: Text('ID', style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.grey,),
                ),)),
            DataColumn(label: Text('Title',style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.grey,),
                ),)),
          ],
          rows: fuelData.map((fuel) {
            return DataRow(cells: [
              DataCell(Text(fuel.userId.toString(), style: const TextStyle(color: Colors.white))),
              DataCell(Text(fuel.id.toString(), style: const TextStyle(color: Colors.white))),
              DataCell(Text(fuel.title, style: const TextStyle(color: Colors.white))),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}


class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Start at the top-left corner
    path.moveTo(0, 0);

    // Draw an arc for the top edge (AB)
    path.quadraticBezierTo(
      size.width * 0.55, // Control point (center of the width, controls curve)
      size.height * 0.2, // Control point (adjust this for the curve height)
      size.width, // End point X (top-right corner)
      size.height * 0.0275, // Adjusted for your screen's height
    );

    // Straight line to the bottom-right corner (BC)
    path.lineTo(size.width, size.height);

    // Straight line to the bottom-left corner (CD)
    path.lineTo(0, size.height);

    // Close the path by returning to the start point (DA)
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}




