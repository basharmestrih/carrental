import 'package:carrentalapp/features/Fetch_Gas_Stations/presentation/Gas_Stations_Page.dart';
import 'package:carrentalapp/features/Fetch_Cars/application/Cars_Cubit.dart';
import 'package:carrentalapp/features/Fetch_Cars/data/Cars_Repo.dart';
import 'package:carrentalapp/features/Fetch_Cars/data/Cars_Web_Sers.dart';
import 'package:carrentalapp/features/Fetch_Cars/presentation/Home_Page.dart';
import 'package:carrentalapp/main_app/Routing_Page.dart';
import 'package:carrentalapp/features/Set_Rent/presentation/Set_Your_Rent_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class Allcarspage extends StatefulWidget {
  const Allcarspage({super.key});

  @override
  _AllcarspageState createState() => _AllcarspageState();
}

class _AllcarspageState extends State<Allcarspage> {
  String selectedBrand = '';
  String selectedPrice = '';
  final int _currentIndex = 3;
  
  final List<Widget> _pages = [
    const HomePage(),
    const Allcarspage(),
    const GasStationsPage(),
    SetYourRentPage(),
  ];
//functions
// Helper method to handle car rental and write to Firestore
Future<void> rentCar(car, dynamic context) async {
  final orderData = {
    'car_brand': car.brandname,
    'engine': car.engine,
    'rental_cost': car.rentalcost,
    'availability': car.availability,
    'order_time': Timestamp.now(),
  };

  // Save rental order to Firestore
  DocumentReference docRef = await FirebaseFirestore.instance.collection('rental_orders').add(orderData);
  // Get the document ID
  String documentId = docRef.id;

  // Update the car availability to false
  await FirebaseFirestore.instance.collection('cars_database').doc(car.id).update({
    'availability': false,
  });

  // Save car.id to Hive
  var box = Hive.box('carBox');
  box.put('carId', documentId);  // Save car ID to Hive

  // Show dialog to confirm the order and handle the next steps
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Order Placed'),
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Your car rental order was placed successfully. Please fill the next form.'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate only when "Go" button is clicked
              Navigator.pop(context);  // Close the dialog
              navigateToRoutingPage(context, 3);  // Navigate after closing dialog
            },
            child: const Text('Go'),
          ),
        ],
      );
    },
  );
}


void navigateToRoutingPage(BuildContext context, int currentIndex) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RoutingPage(),
      settings: RouteSettings(
        arguments: currentIndex, // Pass the currentIndex here
      ),
    ),
  );
}

  void applyPriceFilter(BuildContext context, String priceFilter) {
    // ... (unchanged)
  }





  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => CarsCubit(CarsRepository(CarsWebServices()))..getAllCarsFunctions(),
      child: BlocBuilder<CarsCubit, CarsState>(
        builder: (context, state) {
          if (state is CarsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CarsFetched) {
            final cars = state.cars;
            return Column(
              children: [
                // Car brand chips
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.014, vertical: screenHeight * 0.007),
                  child: Wrap(
                    spacing: screenWidth * 0.028,
                    runSpacing: screenHeight * 0.005,
                    children: [
                      buildChoiceChip(context, 'Toyota', isPrice: false),
                      buildChoiceChip(context, 'Ford', isPrice: false),
                      buildChoiceChip(context, 'Nissan', isPrice: false),
                      buildChoiceChip(context, 'Tesla', isPrice: false),
                    ],
                  ),
                ),
                // Price chips
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.014, vertical: screenHeight * 0.007),
                  child: Wrap(
                    spacing: screenWidth * 0.028,
                    runSpacing: screenHeight * 0.005,
                    children: [
                      buildChoiceChip(context, '> 500 euro', isPrice: true),
                      buildChoiceChip(context, '< 500 euro', isPrice: true),
                      buildChoiceChip(context, 'All prices', isPrice: true),
                    ],
                  ),
                ),
                // Car list
                Expanded(
                  child: ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return buildCarCard(car, screenWidth, screenHeight);
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Error loading cars'));
          }
        },
      ),
    );
  }

  Widget buildChoiceChip(BuildContext context, String label, {required bool isPrice}) {
    final isSelected = isPrice ? selectedPrice == label : selectedBrand == label;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (isPrice) {
            selectedPrice = selected ? label : '';
            applyPriceFilter(context, selectedPrice);
          } else {
            selectedBrand = selected ? label : '';
            BlocProvider.of<CarsCubit>(context).filterCarsByBrand(selectedBrand);
          }
        });
      },
    );
  }



  Widget buildCarCard(car, double screenWidth, double screenHeight) {
    return Container(
      height: screenHeight * 0.4,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.014, horizontal: screenWidth * 0.028),
      decoration: BoxDecoration(
        color:const Color(0xFF2C2B2A),
        borderRadius: BorderRadius.circular(screenWidth * 0.069),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(screenWidth * 0.069)),
            child: Image.asset(
              'assets/unnamed-7.jpg',
              height: screenHeight * 0.275,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: screenHeight * 0.001),
          buildCarDetailsRow('Car Brand', car.brandname, 'Engine', car.engine, screenWidth),
          buildCarDetailsRow('Rental Cost', car.rentalcost, 'Capacity', '5 Seats', screenWidth),
          buildAvailabilityRow(car.availability, car, screenWidth, screenHeight),
        ],
      ),
    );
  }

  Widget buildCarDetailsRow(String label1, String value1, String label2, String value2, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(width: screenWidth * 0.014),
        Text(
          '$label1: $value1',
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          '$label2: $value2',
          style: GoogleFonts.oswald(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildAvailabilityRow(bool isAvailable, car, double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: screenWidth * 0.014),
        Text(
          'Availability:',
          style: GoogleFonts.chauPhilomeneOne(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(width: screenWidth * 0.006),
        Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? Colors.green : Colors.red,
          size: screenWidth * 0.067,
        ),
        const Spacer(),
        SizedBox(width: screenWidth * 0.028),
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(screenWidth * 0.056)),
              ),
              builder: (_) => const CustomBottomSheet(),
            );
          },
          child: Text('See more', style: TextStyle(fontSize: screenWidth * 0.035)),
        ),
        ElevatedButton(
          onPressed: isAvailable ? () => rentCar(car,context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isAvailable ?  const Color.fromARGB(255, 0, 111, 239) : const Color.fromARGB(255, 243, 6, 6),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.028, vertical: screenHeight * 0.007),
            fixedSize: Size(screenWidth * 0.278, screenHeight * 0.041),
          ),
          child: Text('Rent Now', style: TextStyle(fontSize: screenWidth * 0.035,color:Colors.black)),
        ),
      ],
    );
  }
}





class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.96, // Adjust the height based on screen size
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.044),
        child: Column(
          children: [
            // Photo
            Container(
              width: screenWidth * 1.25,
              height: screenHeight * 0.41,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.033),
                image: DecorationImage(
                  image: AssetImage('assets/unnamed-7.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.022),
            // Row with 4 words
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Toyota corolla",
                  style: GoogleFonts.oswald(
                    fontSize: screenWidth * 0.069,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 7, 157, 221),
                  ),
                ),
                Text(
                  "2000CC",
                  style: GoogleFonts.oswald(
                    fontSize: screenWidth * 0.069,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 7, 157, 221),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "2 litre per hour",
                  style: GoogleFonts.oswald(
                    fontSize: screenWidth * 0.069,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 7, 157, 221),
                  ),
                ),
                Text(
                  "AI assistant",
                  style: GoogleFonts.oswald(
                    fontSize: screenWidth * 0.055, // Adjusted from 2.0 to make it visible
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 7, 157, 221),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.034),
            // Square for long text
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(screenWidth * 0.033),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.022),
                  child: SingleChildScrollView(
                    child: Text(
                      "1. Reliability and Durability: The Toyota Corolla is globally recognized for its reliability, offering a long lifespan with minimal maintenance.\n\n"
                      "2. Fuel Efficiency: Known for excellent fuel economy, the Corolla is ideal for daily commutes and long-distance drives, making it a cost-effective option.\n\n"
                      "3. Safety Features: The Toyota Corolla includes advanced safety features such as Toyota Safety Sense with adaptive cruise control, lane departure alerts, and pre-collision systems.\n\n",
                      style: GoogleFonts.oswald(
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C2B2A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
