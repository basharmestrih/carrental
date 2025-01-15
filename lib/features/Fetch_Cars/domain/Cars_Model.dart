class CarsModel {
  final String id;
  final String brandname;
  final String rentalcost;
  final String engine;
  final String imageUrl;
  final bool availability;

  CarsModel({
    required this.id,
    required this.brandname,
    required this.rentalcost,
    required this.engine,
    required this.imageUrl,
    required this.availability,
  });

  // Converts a CarsModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'brand': brandname,
      'rentalCost': rentalcost,
      'fuelType': engine,
      'imageUrl': imageUrl,
      'availability': availability,
    };
  }

  // Creates a CarsModel object from a Map
  factory CarsModel.fromMap(String id, Map<String, dynamic> map) {
    return CarsModel(
      id: id, // Assign the id here
      brandname: map['brand'] ?? '',
      rentalcost: map['rentalCost'] ?? '',
      engine: map['fuelType'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      availability: map['availability'] ?? false,
    );
  }
}
