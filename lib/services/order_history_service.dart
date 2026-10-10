
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

class OrderHistoryService {
  OrderHistoryService._();

  static final OrderHistoryService instance =
      OrderHistoryService._();

  static const String _storageKey = 'shopease_order_history';

  Future<List<OrderModel>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null || savedData.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(savedData);

      final orders = decoded
          .map(
            (item) => OrderModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();

      orders.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

      return orders;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveOrder(OrderModel order) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = await getOrders();

    orders.insert(0, order);

    await prefs.setString(
      _storageKey,
      jsonEncode(orders.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> clearOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
