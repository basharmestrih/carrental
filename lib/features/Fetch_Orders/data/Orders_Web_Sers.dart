import 'package:carrentalapp/features/Fetch_Orders/domain/Orders_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersWebServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<OrdersModel>> fetchOrders() async {
    try {
      // Reference to the 'rental_orders' collection
      CollectionReference ordersCollection = _firestore.collection('rental_orders');
      
      // Fetch documents from the 'user_orders' collection
      QuerySnapshot querySnapshot = await ordersCollection.get();
      
      // Extract data from documents and convert to OrdersModel
      final orders = querySnapshot.docs.map((doc) {
        return OrdersModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList(); // Ensure to call .toList() to create a list from the map

      return orders;
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }
}
