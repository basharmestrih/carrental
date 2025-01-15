import 'package:carrentalapp/features/Fetch_Gas_Stations/application/Gas_State.dart';
import 'package:carrentalapp/features/Fetch_Gas_Stations/domain/Gas_Model.dart';
import 'package:carrentalapp/features/Fetch_Gas_Stations/data/Gas_Repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FuelPriceCubit extends Cubit<FuelPriceState> {
  final FuelPriceRepository repository;

  List<FuelPrice> _allFuelPrices = []; // Keep all data here for filtering purposes

  FuelPriceCubit(this.repository) : super(FuelPriceLoading());

  Future<void> fetchFuelPrice(String completedStatus) async {
    try {
      final fuelPrices = await repository.getFuelPrice();
      _allFuelPrices = fuelPrices; // Store the full data list
      final filteredData = _allFuelPrices.where((fuel) => fuel.completed == completedStatus).toList();
      emit(FuelPriceLoaded(filteredData));
    } catch (e) {
      emit(FuelPriceError('Failed to fetch data'));
    }
  }

  Future<void> filterByCompletedStatus(String completedStatus) async {
    // Filter based on the string value "true" or "false"
    try {
    final filteredData = _allFuelPrices.where((fuel) => fuel.completed == completedStatus).toList();
    emit(FuelPriceFiltered(filteredData));
    } catch (e) {
      emit(FuelPriceError('Failed to fetch data'));
    }
  }
}
