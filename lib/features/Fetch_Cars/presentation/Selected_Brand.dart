import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carrentalapp/features/Fetch_Cars/application/Cars_Cubit.dart';
import 'package:carrentalapp/features/Fetch_Cars/domain/Cars_Model.dart';
import 'package:google_fonts/google_fonts.dart';

class CarsByBrandPage extends StatefulWidget {
  final String brandName;

  const CarsByBrandPage({super.key, required this.brandName});

  @override
  _CarsByBrandPageState createState() => _CarsByBrandPageState();
}

class _CarsByBrandPageState extends State<CarsByBrandPage> {
  @override
  void initState() {
    super.initState();
    context.read<CarsCubit>().filterCarsByBrand(widget.brandName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey[300],
      appBar: AppBar(
        title: Text('Cars by ${widget.brandName}'),
        backgroundColor: Colors.grey,
      ),
      body: BlocBuilder<CarsCubit, CarsState>(
        builder: (context, state) {
          if (state is CarsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CarsFetched) {
            final cars = state.cars;
            if (cars.isEmpty) {
              return const Center(child: Text('No cars available for this brand.'));
            } else {
              return ListView.builder(
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  final car = cars[index];
                  return buildCarCard(car); // Use the updated card design
                },
              );
            }
          } else if (state is CarsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }

  // Updated Card Design Method
  Widget buildCarCard(car) {
    return Container(
      height: 320,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
         border: Border(
        bottom: BorderSide(
          color: Colors.black, // Black color for bottom border
          width: 5, // Adjust thickness as needed
        ),
      ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            child: Image.asset(
              'assets/unnamed-7.jpg', // Use actual image URL or asset
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 1),
          buildCarDetailsRow('Car Brand', car.brandname, 'Engine', car.engine),
          buildCarDetailsRow('Rental Cost', '\$${car.rentalcost}', 'Capacity', '5 Seats'),
          buildAvailabilityRow(car.availability, car), // Pass the availability status here
        ],
      ),
    );
  }

  // Helper method to build a row for car details
  Widget buildCarDetailsRow(String label1, String value1, String label2, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(width: 5),
        Text(
          '$label1: $value1',
          style: GoogleFonts.oswald(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        Text(
          '$label2: $value2',
          style: GoogleFonts.oswald(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Helper method to build availability row
  Widget buildAvailabilityRow(bool isAvailable, car) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 5),
        Text(
          'Availability:',
          style: GoogleFonts.oswald(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 2),
        Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? Colors.green : Colors.red,
          size: 24.0,
        ),
        const Spacer(),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: isAvailable ? () => rentCar(car) : null, // Disable the button if not available
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 226, 7, 11),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            fixedSize: const Size(100, 30),
          ),
          child: const Text('Rent Now'),
        ),
      ],
    );
  }

  // Add your rentCar method here, for example:
  void rentCar(car) {
    // Handle the car rental logic here, e.g., navigate to a booking page
    print("Renting ${car.brandname}");
  }
}
