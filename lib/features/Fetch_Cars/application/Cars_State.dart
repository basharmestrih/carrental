part of 'Cars_Cubit.dart';


@immutable
abstract class CarsState {}

class CarsInitial extends CarsState {} // Initial state when no data is loaded

class CarsFetched extends CarsState {
  final List<CarsModel> cars; // List of fetched courses

  CarsFetched(this.cars); // Constructor to initialize the list

}
class CarsError extends CarsState {
  final String message;

  CarsError(this.message);
}


