import 'dart:convert';
import 'package:carrentalapp/features/Fetch_Gas_Stations/domain/Gas_Model.dart';
import 'package:http/http.dart' as http;

class FuelPriceService {
  Future<List<FuelPrice>> fetchFuelPrice() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      // Map each item in the JSON list to a FuelPrice object
      return jsonList.take(5).map((json) => FuelPrice.fromJson(json)).toList();

      
    } else {
      throw Exception('Failed to load fuel price data');
    }
  }
}
