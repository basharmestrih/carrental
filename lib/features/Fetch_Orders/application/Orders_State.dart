// orders_state.dart
import 'package:equatable/equatable.dart';
import 'package:carrentalapp/features/Fetch_Orders/domain/Orders_Model.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersFetched extends OrdersState {
  final List<OrdersModel> orders;

  OrdersFetched(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);

  @override
  List<Object> get props => [message];
}
