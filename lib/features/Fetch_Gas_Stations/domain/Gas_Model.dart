import 'package:flutter/src/material/data_table.dart';

class FuelPrice {
  final String userId;
  final String id;
  final String title;
  final String completed;

  FuelPrice({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  // Factory method to create a FuelPrice object from JSON with null-safety checks
  factory FuelPrice.fromJson(Map<String, dynamic> json) {
    return FuelPrice(
      userId: (json['userId'] != null) ? json['userId'].toString() : 'Unknown User',
      id: (json['id'] != null) ? json['id'].toString() : 'Unknown ID',
      title: json['title'] as String? ?? 'No Title',
      completed: (json['completed'] != null) ? json['completed'].toString() : 'Unknown',
    );
  }

  // Method to convert a FuelPrice object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

  map(DataRow Function(dynamic fuel) param0) {}
}
