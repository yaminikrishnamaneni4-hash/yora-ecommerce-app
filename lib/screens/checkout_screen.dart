
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../models/order_model.dart';
import '../services/order_history_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();

  String _paymentMethod = 'Cash on Delivery';
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    return '₹${price.toStringAsFixed(2)}';
  }

  // PLACE ORDER AND SAVE ORDER HISTORY
  Future<void> _placeOrder(CartProvider cart) async {
    if (_isPlacingOrder) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty!'),
        ),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    final orderId =
        'SE${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final customerName = _nameController.text.trim();
    final paymentMethod = _paymentMethod;

    // Create a snapshot of the products before clearing the cart.
    final order = OrderModel(
      orderId: orderId,
      customerName: customerName,
      paymentMethod: paymentMethod,
      total: cart.totalPrice,
      createdAt: DateTime.now(),
      status: 'Order Placed',
      items: cart.items.values.map((item) {
        return OrderLine(
          productName: item.product.name,
          unitPrice: item.product.price,
          quantity: item.quantity,
        );
      }).toList(),
    );

    try {
      // Save the order to local storage first.
      await OrderHistoryService.instance.saveOrder(order);

      if (!mounted) return;

      // Clear cart only after the order is saved.
      cart.clearCart();

      setState(() => _isPlacingOrder = false);

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: Color(0xFFE1F5E8),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 55,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Order Placed Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Thank you, $customerName!',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Order ID: $orderId',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Total: ${_formatPrice(order.total)}'),
                const SizedBox(height: 5),
                Text(
                  'Payment: $paymentMethod',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your order has been saved successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                  ),
                  icon: const Icon(Icons.receipt_long),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();

                    Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    );

                    Navigator.of(context).pushNamed('/orders');
                  },
                  label: const Text('VIEW MY ORDERS'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();

                    Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text('CONTINUE SHOPPING'),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isPlacingOrder = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to save your order. Please try again.',
          ),
        ),
      );
    }
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.pinkAccent),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Colors.pinkAccent,
          ),
          filled: true,
          fillColor: const Color(0xFFFFF8F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFEADDDD),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFFFF8F7),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 75,
                      color: Colors.pinkAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your cart is empty!',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add products before checkout.',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('GO BACK'),
                    ),
                  ],
                ),
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // DELIVERY DETAILS
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(
                          'Delivery Details',
                          Icons.location_on_outlined,
                        ),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person_outline,
                        ),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null ||
                                !RegExp(r'^[0-9]{10}$')
                                    .hasMatch(value.trim())) {
                              return 'Enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _addressController,
                          label: 'House No. / Street Address',
                          icon: Icons.home_outlined,
                          maxLines: 2,
                        ),
                        _buildTextField(
                          controller: _cityController,
                          label: 'City',
                          icon: Icons.location_city_outlined,
                        ),
                        _buildTextField(
                          controller: _pincodeController,
                          label: 'PIN Code',
                          icon: Icons.markunread_mailbox_outlined,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                !RegExp(r'^[0-9]{6}$')
                                    .hasMatch(value.trim())) {
                              return 'Enter a valid 6-digit PIN code';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // PAYMENT METHODS
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(
                          'Payment Method',
                          Icons.payment_outlined,
                        ),
                        RadioListTile<String>(
                          value: 'Cash on Delivery',
                          groupValue: _paymentMethod,
                          activeColor: Colors.pinkAccent,
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Cash on Delivery'),
                          subtitle: const Text(
                            'Pay when your order arrives',
                          ),
                          secondary: const Icon(
                            Icons.local_shipping_outlined,
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _paymentMethod = value;
                              });
                            }
                          },
                        ),
                        const Divider(),
                        RadioListTile<String>(
                          value: 'UPI (Demo)',
                          groupValue: _paymentMethod,
                          activeColor: Colors.pinkAccent,
                          contentPadding: EdgeInsets.zero,
                          title: const Text('UPI'),
                          subtitle: const Text(
                            'Demo option — no payment is processed',
                          ),
                          secondary: const Icon(
                            Icons.account_balance_wallet_outlined,
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _paymentMethod = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ORDER SUMMARY
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(
                          'Order Summary',
                          Icons.receipt_long_outlined,
                        ),
                        ...cart.items.values.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.product.name} × ${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatPrice(item.total),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const Divider(height: 24),
                        const Row(
                          children: [
                            Expanded(child: Text('Delivery')),
                            Text(
                              'FREE',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              _formatPrice(cart.totalPrice),
                              style: const TextStyle(
                                fontSize: 19,
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // PLACE ORDER BUTTON
                  SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _isPlacingOrder
                          ? null
                          : () => _placeOrder(cart),
                      icon: _isPlacingOrder
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.check_circle_outline,
                            ),
                      label: Text(
                        _isPlacingOrder
                            ? 'PLACING ORDER...'
                            : 'PLACE ORDER • ${_formatPrice(cart.totalPrice)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    '🔒 Demo checkout for your ShopEase app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
