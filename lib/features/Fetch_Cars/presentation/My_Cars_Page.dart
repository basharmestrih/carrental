import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:carrentalapp/features/Fetch_Cars/presentation/All_Cars_Page.dart.dart';

class MyCarsPage extends StatefulWidget {
  @override
  _MyCarsPageState createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  Box<Map>? carBox;

  @override
  void initState() {
    super.initState();
    _loadCarDetails();
  }

  Future<void> _loadCarDetails() async {
    // Open the Hive box
    carBox = await Hive.openBox<Map>('favourite_database');

    // Refresh UI after loading the box
    setState(() {});
  }

  Future<void> _deleteCar(int index) async {
    await carBox?.deleteAt(index); // Delete the car at the given index
    setState(() {}); // Refresh UI after deletion
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: carBox == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: carBox!.length,
                itemBuilder: (context, index) {
                  final allCars = carBox!.values.toList();
                  final carDetails = allCars[index];
                  final brandname = carDetails['brandname'];
                  final engine = carDetails['engine'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CarCard(
                      brandname: brandname,
                      engine: engine,
                      onDelete: () async => await _deleteCar(index), screenHeight: screenHeight, screenWidth: screenWidth,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class CarCard extends StatelessWidget {
  final String brandname;
  final String engine;
  final double screenHeight;
  final double screenWidth;
  final Future<void> Function() onDelete;

  const CarCard({
    required this.brandname,
    required this.engine,
    required this.onDelete, required this.screenHeight, required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CarImage(),
            const SizedBox(height: 20),
            CarDetails(brandname: brandname, engine: engine),
            const Divider(height: 20, thickness: 4, color: Colors.black),
            CarActions(onDelete: onDelete, screenHeight: screenHeight, screenWidth: screenWidth,),
          ],
        ),
      ),
    );
  }
}

class CarImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.asset(
        'assets/unnamed-7.jpg', // Replace with your asset image path
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}

class CarDetails extends StatelessWidget {
  final String brandname;
  final String engine;

  const CarDetails({
    required this.brandname,
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Car Brand',
              style: GoogleFonts.chauPhilomeneOne(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              brandname,
              style: GoogleFonts.chauPhilomeneOne(
                fontSize: 20.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const Divider(height: 20, thickness: 4, color: Colors.black),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Engine Type',
              style: GoogleFonts.oswald(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              engine,
              style: GoogleFonts.oswald(
                fontSize: 20.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CarActions extends StatelessWidget {
  final Future<void> Function() onDelete;
  final double screenHeight;
  final double screenWidth;

  const CarActions({required this.onDelete, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
  width: 120,
  child: ElevatedButton(
    onPressed: onDelete,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    child:  Text(
      'Delete ',
     style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
                ),
    ),
  ),
),


        SizedBox(width:120,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Allcarspage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C2B2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child:  Text(
              'Check',
              style: GoogleFonts.chauPhilomeneOne(
                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
                ),
            ),
          ),
        ),
      ],
    );
  }
}
