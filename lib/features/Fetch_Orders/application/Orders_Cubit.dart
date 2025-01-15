import 'package:bloc/bloc.dart';
import 'package:carrentalapp/features/Fetch_Orders/application/Orders_State.dart';
import 'package:carrentalapp/features/Fetch_Orders/domain/Orders_Model.dart';
import 'package:carrentalapp/features/Fetch_Orders/data/Orders_Repo.dart';
import 'package:carrentalapp/features/Fetch_Cars/domain/Cars_Model.dart';
import 'package:carrentalapp/features/Fetch_Cars/data/Cars_Repo.dart';
import 'package:flutter/material.dart';





class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository ordersRepository;
  List<OrdersModel> allOrders = []; // Store all orders
  List<OrdersModel> filteredOrders = []; // Store filtered orders

  OrdersCubit(this.ordersRepository) : super(OrdersInitial());

  // Fetch all orders from the repository
  Future<void> getAllOrdersFunctions() async {
    allOrders = (await ordersRepository.getAllOrders());
    filteredOrders = allOrders;
    emit(OrdersFetched(filteredOrders));
  }
}

