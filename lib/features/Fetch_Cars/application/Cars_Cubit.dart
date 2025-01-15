import 'package:bloc/bloc.dart';
import 'package:carrentalapp/features/Fetch_Cars/domain/Cars_Model.dart';
import 'package:carrentalapp/features/Fetch_Cars/data/Cars_Repo.dart';
import 'package:flutter/material.dart';

part 'Cars_State.dart';

class CarsCubit extends Cubit<CarsState> {
  final CarsRepository carsRepository;
   List<CarsModel> allCars = []; // Store all cars
   List<CarsModel> filteredCars = []; // Store filtered cars
  

  CarsCubit(this.carsRepository) : super(CarsInitial());

  // Fetch all cars from the repository
  Future<void> getAllCarsFunctions() async {
    allCars = (await carsRepository.getAllCars());
    filteredCars = allCars;
    emit(CarsFetched(filteredCars));
  }
  // car by true or false
   // Cubit function to filter cars by availability
   void filterCarsByAvailability() async {
    try {
      final cars = await carsRepository.getAllCars(); // Fetch the cars
      final availableCars = cars.where((car) => car.availability == true).toList(); // Filter cars by availability
      emit(CarsFetched(availableCars)); // Emit the filtered cars
    } catch (e) {
      emit(CarsError("Failed to load cars: $e"));
    }
  }

  void filterCarsBySpecifcBrand(String brandName) async {
  try {
    final cars = await carsRepository.getAllCars(); // Fetch the cars from the repository
    final filteredCars = cars.where((car) => car.brandname == brandName).toList(); // Filter cars by brandname
    emit(CarsFetched(filteredCars)); // Emit the filtered cars
  } catch (e) {
    emit(CarsError("Failed to load cars: $e")); // Emit error state if there's an issue
  }
}

  // Filter cars by brand
  void filterCarsByBrand(String brand) {
    if (brand.isEmpty) {
      filteredCars = allCars; // Reset to all cars if no brand is selected
    } else {
      filteredCars = allCars.where((car) => car.brandname == brand).toList();
    }
    emit(CarsFetched(filteredCars)); // Emit the filtered list
  }

    // Filter cars by price
  void filterCarsByPrice(bool greaterThan500) {
    if (greaterThan500) {
      filteredCars = allCars.where((car) => int.parse(car.rentalcost) > 500).toList();
    } else {
      filteredCars = allCars.where((car) => int.parse(car.rentalcost) <= 500).toList();
    }
    emit(CarsFetched(filteredCars)); // Emit the filtered list
  }
}


