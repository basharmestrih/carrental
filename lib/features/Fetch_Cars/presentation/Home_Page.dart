import 'dart:ui';
import 'package:carrentalapp/features/Fetch_Cars/application/Cars_Cubit.dart';
import 'package:carrentalapp/features/Fetch_Cars/data/Cars_Web_Sers.dart';
import 'package:carrentalapp/features/Fetch_Cars/presentation/All_Cars_Page.dart.dart';
import 'package:carrentalapp/features/Fetch_Cars/presentation/Selected_Brand.dart';
import 'package:carrentalapp/main_app/Routing_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carrentalapp/features/Fetch_Cars/domain/Cars_Model.dart';
import 'package:carrentalapp/features/Fetch_Cars/data/Cars_Repo.dart';
import 'package:hive/hive.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  return BlocProvider(
    create: (context) => CarsCubit(CarsRepository(CarsWebServices()))..filterCarsByAvailability(),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.001),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Pick your brand',
                style: GoogleFonts.chauPhilomeneOne(
                    fontSize: screenHeight * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarsByBrandPage(brandName: 'Tesla'),
                    ),
                  );
                },
                child: buildImageContainer(
                  'assets/Peugeot-508-Sport-Engineered-concept-front-side-view.jpg',
                  'TESLA',
                  screenHeight,
                  screenWidth
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarsByBrandPage(brandName: 'Nissan'),
                    ),
                  );
                },
                child: buildImageContainer(
                  'assets/Peugeot-508-Sport-Engineered-concept-front-side-view.jpg',
                  'NISSAN',
                  screenHeight,
                  screenWidth
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: buildImageContainer(
                  'assets/Peugeot-508-Sport-Engineered-concept-front-side-view.jpg',
                  'PEUGEOT',
                  screenHeight,
                  screenWidth
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.0036),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {},
                child: buildImageContainer(
                  'assets/Peugeot-508-Sport-Engineered-concept-front-side-view.jpg',
                  'FORD',
                  screenHeight,
                  screenWidth
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: buildImageContainer(
                  'assets/Peugeot-508-Sport-Engineered-concept-front-side-view.jpg',
                  'Toyota',
                  screenHeight,
                  screenWidth
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: buildImageContainer(
                  'assets/Peugeot-508-Sport-Engineered-concept-front-side-view.jpg',
                  'NISSAN',
                  screenHeight,
                  screenWidth
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.0126),
          Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Available Cars For Rent',
                  style: GoogleFonts.chauPhilomeneOne(
                      fontSize: screenHeight * 0.035, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(width: screenWidth * 0.1503),
              Text(
                'See All',
                style: GoogleFonts.chauPhilomeneOne(
                    fontSize: screenHeight * 0.0189, color: const Color.fromARGB(255, 7, 1, 1)),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.3087,
            child: BlocBuilder<CarsCubit, CarsState>(
              builder: (context, state) {
                if (state is CarsFetched) {
                  final cars = state.cars;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.cars.length,
                    itemBuilder: (context, index) {
                      final car = state.cars[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.0198),
                        child: FoodCard(car: car, screenHeight: screenHeight, screenWidth: screenWidth),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.0063),
          const CustomCard(imageUrl: 'assets/signature-with-a-pen.png', title: 'Set Your Rent', subtitle: 'It takes 1 minute only'),
        ],
      ),
    ),
  );
}

Widget buildImageContainer(String imagePath, String label, double screenHeight, double screenWidth) {
  return Container(
    width: screenWidth * 0.27,
    height: screenHeight * 0.108,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.grey[300],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: Text(
              label,
              style: GoogleFonts.chauPhilomeneOne(
                  fontSize: screenHeight * 0.027,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}
}


class FoodCard extends StatelessWidget {
  final CarsModel car;
  final double screenHeight;
  final double screenWidth;

  const FoodCard({
    super.key,
    required this.car,
    required this.screenHeight,
    required this.screenWidth,
  });

  Future<void> addToFavourites(String brandname, String engine) async {
    final box = await Hive.openBox<Map>('favourite_database');
    bool exists = false;
    for (var carDetails in box.values) {
      if (carDetails['brandname'] == brandname && carDetails['engine'] == engine) {
        exists = true;
        break;
      }
    }
    if (exists) {
      print('This car is already in the favourites: Brand - $brandname, Engine - $engine');
    } else {
      final carDetails = {
        'brandname': brandname,
        'engine': engine,
      };
      await box.add(carDetails);
      print('Added to favourites: Brand - $brandname, Engine - $engine');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: screenWidth * 0.81,
          height: screenHeight * 0.315,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage('assets/unnamed-7.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: screenHeight * 0.2349,
          left: screenWidth * 0.6498,
          right: screenWidth * 0.0072,
          top: screenHeight * 0.0036,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.0225),
            child: CircleAvatar(
              backgroundColor: Colors.yellowAccent,
              radius: screenWidth * 0.0504,
              child: IconButton(
                icon: const Icon(
                  Icons.bookmark,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  addToFavourites(car.brandname, car.engine);
                  print('Added to favourites: ${car.brandname}');
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: screenHeight * 0.0126,
          left: screenWidth * 0.0999,
          right: screenWidth * 0.0999,
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.0072),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.brandname,
                      style: TextStyle(
                        fontSize: screenHeight * 0.0225,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.0009),
                    Text(
                      'Engine: ${car.engine}',
                      style: TextStyle(fontSize: screenHeight * 0.0144),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  iconSize: screenHeight * 0.0369,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const CustomCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.0396),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16.0),
            ),
            height: screenHeight * 0.1485,
            width: double.infinity,
          ),
          Positioned(
            top: screenHeight * 0.0198,
            left: screenWidth * 0.0396,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                   style: GoogleFonts.chauPhilomeneOne(
                    fontSize: screenHeight * 0.0225,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                ),
                SizedBox(height: screenHeight * 0.0045),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenHeight * 0.0171,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: screenWidth * 0.0747,
            top: screenHeight * 0.0198,
            bottom: screenHeight * 0.0198,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: screenWidth * 0.2502,
                height: screenWidth * 0.2502,
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.0072,
            left: screenWidth * 0.0396,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoutingPage(),
                    settings: RouteSettings(arguments: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Join Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenHeight * 0.0171,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
