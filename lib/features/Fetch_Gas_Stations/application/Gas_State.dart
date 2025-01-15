// States for FuelPriceCubit
import 'package:carrentalapp/features/Fetch_Gas_Stations/domain/Gas_Model.dart';

abstract class FuelPriceState {}

class FuelPriceInitial extends FuelPriceState {}

class FuelPriceLoading extends FuelPriceState {}

class FuelPriceLoaded extends FuelPriceState {
  final List<FuelPrice> fuelPrice;

  FuelPriceLoaded(this.fuelPrice);
}

class FuelPriceError extends FuelPriceState {
  final String message;

  FuelPriceError(this.message);
}

class FuelPriceFiltered extends FuelPriceState {
  final List<FuelPrice> filteredFuelPrices;

  FuelPriceFiltered(this.filteredFuelPrices);
}