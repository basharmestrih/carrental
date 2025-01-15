import 'package:carrentalapp/features/Fetch_Cars/domain/Cars_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarsWebServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CarsModel>> fetchCars() async {
    try {
      // Reference to the 'tickets' collection
      CollectionReference carsCollection = _firestore.collection('cars_database');
      
      // Fetch documents from the 'tickets' collection
      QuerySnapshot querySnapshot = await carsCollection.get();
      
      // Extract data from documents and convert to Ticket model
      final cars = querySnapshot.docs.map((doc) {
      return CarsModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList(); // Ensure to call .toList() to create a list from the map

      
      return cars;
    } catch (e) {
      throw Exception('Failed to load tickets: $e');
    }
  }
}
