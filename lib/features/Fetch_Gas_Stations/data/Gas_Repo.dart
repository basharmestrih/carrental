import 'package:carrentalapp/features/Fetch_Gas_Stations/domain/Gas_Model.dart';
import 'package:carrentalapp/features/Fetch_Gas_Stations/data/Gas_Web_Sers.dart';

class FuelPriceRepository {
  final FuelPriceService service;

  FuelPriceRepository(this.service);

  Future<List<FuelPrice>> getFuelPrice() async {
    return await service.fetchFuelPrice();
  }
}
