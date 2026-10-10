
class OrderLine {
  final String productName;
  final double unitPrice;
  final int quantity;

  const OrderLine({
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  double get total => unitPrice * quantity;

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      productName: json['productName'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );
  }
}

class OrderModel {
  final String orderId;
  final String customerName;
  final String paymentMethod;
  final double total;
  final DateTime createdAt;
  final String status;
  final List<OrderLine> items;

  const OrderModel({
    required this.orderId,
    required this.customerName,
    required this.paymentMethod,
    required this.total,
    required this.createdAt,
    required this.status,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'customerName': customerName,
        'paymentMethod': paymentMethod,
        'total': total,
        'createdAt': createdAt.toIso8601String(),
        'status': status,
        'items': items.map((item) => item.toJson()).toList(),
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] as String,
      customerName: json['customerName'] as String,
      paymentMethod: json['paymentMethod'] as String,
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
      items: (json['items'] as List)
          .map(
            (item) => OrderLine.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}
