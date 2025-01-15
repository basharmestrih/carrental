import 'package:carrentalapp/features/Fetch_Cars/domain/Cars_Model.dart';
import 'package:carrentalapp/features/Fetch_Cars/data/Cars_Web_Sers.dart';


class CarsRepository {
  final CarsWebServices carsWebServices;

  CarsRepository(this.carsWebServices);

  // Method to get all courses from Firestore
  Future<List<CarsModel>> getAllCars() async {
    // Fetch data from Firestore
    final carsData = await carsWebServices.fetchCars();

    // Directly return the fetched courses
    return carsData; // No need to map again
  }
}
