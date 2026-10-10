import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/wishlist_service.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  double _getPrice(String price) {
    final cleanedPrice = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleanedPrice) ?? 0.0;
  }

  void _addToCart(
    BuildContext context,
    Map<String, String> item,
  ) {
    final productName = item['productName'] ?? 'Fashion Product';
    final price = _getPrice(item['price'] ?? '0');

    final product = Product(
      id: 'yora_${productName.toLowerCase().replaceAll(' ', '_')}',
      name: productName,
      price: price,
      emoji: '👗',
      description: 'Stylish $productName from the YORA collection.',
    );

    context.read<CartProvider>().addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to cart 🛍️'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F7),
        elevation: 0,
        title: const Text(
          'My Wishlist ❤️',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            tooltip: 'View Cart',
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: WishlistService.instance,
        builder: (context, child) {
          final items = WishlistService.instance.items;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 85,
                    color: Colors.pinkAccent,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your wishlist is empty!',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your favourite products here ❤️',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('CONTINUE SHOPPING'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.57,
            ),
            itemBuilder: (context, index) {
              final item = items[index];

              final productName =
                  item['productName'] ?? 'Fashion Product';
              final price = item['price'] ?? '₹0';
              final oldPrice = item['oldPrice'] ?? '';
              final imagePath = item['imagePath'] ?? '';
              final discount = item['discount'] ?? '';
              final rating = item['rating'] ?? '';

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const ColoredBox(
                                color: Color(0xFFF5E8E8),
                                child: Center(
                                  child: Icon(
                                    Icons.checkroom,
                                    size: 55,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                              );
                            },
                          ),
                          if (discount.isNotEmpty)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  discount,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 19,
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  WishlistService.instance
                                      .removeFromWishlist(productName);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '$productName removed from wishlist',
                                      ),
                                      duration:
                                          const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(9, 9, 9, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  price,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.pinkAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              if (oldPrice.isNotEmpty)
                                Flexible(
                                  child: Text(
                                    oldPrice,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                      decoration:
                                          TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (rating.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  rating,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 9),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _addToCart(context, item),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 11,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              child: const Text(
                                'ADD TO CART',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}