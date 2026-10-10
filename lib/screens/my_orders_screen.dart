
import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_history_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  static const Color maroon = Color(0xFF8B1E3F);
  static const Color background = Color(0xFFF8F8F8);

  late Future<List<OrderModel>> _ordersFuture;

  // Demo tracking stages: 0, 1, 2, 3
  final Map<String, int> _trackingStages = {};

  final List<String> _stages = const [
    'Order Placed',
    'Shipped',
    'Out for Delivery',
    'Delivered',
  ];

  final List<IconData> _stageIcons = const [
    Icons.receipt_long_rounded,
    Icons.local_shipping_rounded,
    Icons.delivery_dining_rounded,
    Icons.inventory_2_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    _ordersFuture = OrderHistoryService.instance.getOrders();
  }

  Future<void> _refreshOrders() async {
    setState(_loadOrders);
    await _ordersFuture;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  int _initialStage(String status) {
    final value = status.toLowerCase();

    if (value.contains('delivered')) return 3;
    if (value.contains('out for delivery')) return 2;
    if (value.contains('shipped')) return 1;

    return 0;
  }

  int _currentStage(OrderModel order) {
    return _trackingStages.putIfAbsent(
      order.orderId,
      () => _initialStage(order.status),
    );
  }

  String _currentStatus(OrderModel order) {
    return _stages[_currentStage(order)];
  }

  void _showTracking(OrderModel order) {
    _trackingStages.putIfAbsent(
      order.orderId,
      () => _initialStage(order.status),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final currentStage = _currentStage(order);
            final isDelivered = currentStage == _stages.length - 1;

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
              contentPadding: const EdgeInsets.fromLTRB(22, 10, 22, 8),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: const Row(
                children: [
                  Icon(Icons.local_shipping_rounded, color: maroon),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Track Your Order',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order ID',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.orderId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),

                    ...List.generate(_stages.length, (index) {
                      final isCompleted = index <= currentStage;
                      final isCurrent = index == currentStage;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 38,
                              child: Column(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? maroon
                                          : const Color(0xFFEAEAEA),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isCompleted
                                          ? Icons.check_rounded
                                          : _stageIcons[index],
                                      color: isCompleted
                                          ? Colors.white
                                          : Colors.grey,
                                      size: 19,
                                    ),
                                  ),
                                  if (index != _stages.length - 1)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        constraints:
                                            const BoxConstraints(
                                          minHeight: 32,
                                        ),
                                        color: index < currentStage
                                            ? maroon
                                            : const Color(0xFFE0E0E0),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 4,
                                  bottom: 24,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _stages[index],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isCurrent
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                        color: isCompleted
                                            ? maroon
                                            : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isCurrent
                                          ? 'Current demo status'
                                          : isCompleted
                                              ? 'Step completed'
                                              : 'Waiting for previous step',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7E7EC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isDelivered
                            ? 'Your demo order has reached the final stage!'
                            : 'Current status: ${_stages[currentStage]}',
                        style: const TextStyle(
                          color: maroon,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Demo only: status changes are not saved to order '
                      'history and do not represent real courier updates.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'CLOSE',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                if (!isDelivered)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _trackingStages[order.orderId] =
                            currentStage + 1;
                      });

                      setDialogState(() {});

                      ScaffoldMessenger.of(this.context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              'Demo status: ${_stages[currentStage + 1]}',
                            ),
                            backgroundColor: maroon,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: maroon,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('NEXT STATUS'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _refreshOrders,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh orders',
          ),
        ],
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: maroon),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  const Text('Unable to load orders.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refreshOrders,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: maroon,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('TRY AGAIN'),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 85,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'No Orders Yet!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your placed orders will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: maroon,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('CONTINUE SHOPPING'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshOrders,
            color: maroon,
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final status = _currentStatus(order);
                final delivered = _currentStage(order) == 3;

                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xFFF5E5EB),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: maroon,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Order ID',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    order.orderId,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Placed on ${_formatDate(order.createdAt)}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              delivered
                                  ? Icons.check_circle
                                  : Icons.local_shipping_outlined,
                              color: delivered ? Colors.green : maroon,
                            ),
                          ],
                        ),

                        const Divider(height: 28),

                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.checkroom_rounded,
                                  color: maroon,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text('x${item.quantity}'),
                                const SizedBox(width: 14),
                                Text(
                                  '₹${item.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Divider(height: 24),

                        _detailRow('Customer', order.customerName),
                        const SizedBox(height: 10),
                        _detailRow('Payment', order.paymentMethod),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7E7EC),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: maroon,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Order Total',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${order.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: maroon,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: () => _showTracking(order),
                            icon: const Icon(
                              Icons.local_shipping_rounded,
                              size: 20,
                            ),
                            label: const Text(
                              'TRACK ORDER',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: maroon,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
