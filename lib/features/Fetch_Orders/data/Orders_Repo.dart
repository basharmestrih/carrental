import 'package:carrentalapp/features/Fetch_Orders/domain/Orders_Model.dart';
import 'package:carrentalapp/features/Fetch_Orders/data/Orders_Web_Sers.dart';




class OrdersRepository {
  final OrdersWebServices ordersWebServices;

  OrdersRepository(this.ordersWebServices);

  // Method to get all orders from Firestore
  Future<List<OrdersModel>> getAllOrders() async {
    // Fetch data from Firestore
    final ordersData = await ordersWebServices.fetchOrders();

    // Directly return the fetched orders
    return ordersData; // No need to map again
  }
}
