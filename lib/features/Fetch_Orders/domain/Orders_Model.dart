class OrdersModel {
  final String id;
  final String brandname;
  final String rentalcost;
  final String engine;
  final String imageUrl; // Corresponds to 'driverLicenseUrl' or other relevant image field
  final bool availability;
  final String fullName;
  final String location;
  final String age;
  final String date;

  OrdersModel({
    required this.id,
    required this.brandname,
    required this.rentalcost,
    required this.engine,
    required this.imageUrl,
    required this.availability,
    required this.fullName,
    required this.location,
    required this.age,
    required this.date,
  });

  // Converts a CarsModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'brand': brandname,
      'rentalCost': rentalcost,
      'fuelType': engine,
      'imageUrl': imageUrl,
      'availability': availability,
      'fullName': fullName,
      'location': location,
      'age': age,
      'date': date,
    };
  }

  // Creates a CarsModel object from a Map
  factory OrdersModel.fromMap(String id, Map<String, dynamic> map) {
    return OrdersModel(
      id: id, // Assign the id here
      brandname: map['car_brand'] ?? '',
      rentalcost: map['rental_cost'] ?? '',
      engine: map['engine'] ?? '',
      imageUrl: map['driverLicenseUrl'] ?? '', // Default to an empty string if null
      availability: map['availability'] ?? false,
      fullName: map['fullName'] ?? '',
      location: map['location'] ?? '',
      age: map['age'] ?? '',
      date: map['date'] ?? '',
    );
  }
}
