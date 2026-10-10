
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/wishlist_service.dart';
import 'product_details_screen.dart';
import 'wishlist_screen.dart';

class WomenScreen extends StatefulWidget {
  const WomenScreen({super.key});

  @override
  State<WomenScreen> createState() => _WomenScreenState();
}

class _WomenScreenState extends State<WomenScreen> {
  static const Color burgundy = Color(0xFF8E3047);
  static const Color softRose = Color(0xFFF8E1E7);

  final List<Map<String, String>> products = [
    {
      'name': 'Elegant Kurti',
      'price': '₹799',
      'oldPrice': '₹1,299',
      'image': 'assets/products/trending_kurti.jpg',
      'rating': '4.7',
    },
    {
      'name': 'Designer Saree',
      'price': '₹1,499',
      'oldPrice': '₹2,499',
      'image': 'assets/products/saree.jpg',
      'rating': '4.8',
    },
    {
      'name': 'Premium Handbag',
      'price': '₹899',
      'oldPrice': '₹1,499',
      'image': 'assets/products/handbag.jpg',
      'rating': '4.6',
    },
    {
      'name': 'Floral Dress',
      'price': '₹999',
      'oldPrice': '₹1,599',
      'image': 'assets/products/dress.jpg',
      'rating': '4.7',
    },
  ];

  final List<Map<String, String>> categories = [
    {'name': 'Sarees', 'image': 'assets/products/saree.jpg'},
    {'name': 'Kurtis', 'image': 'assets/products/trending_kurti.jpg'},
    {'name': 'Dresses', 'image': 'assets/products/dress.jpg'},
    {'name': 'Bags', 'image': 'assets/products/handbag.jpg'},
    {'name': 'Beauty', 'image': 'assets/products/dress.jpg'},
    {'name': 'Skincare', 'image': 'assets/products/handbag.jpg'},
  ];

  String selectedCategory = 'All';

  double _number(String value) {
    return double.parse(value.replaceAll(RegExp(r'[^0-9.]'), ''));
  }

  Product _toProduct(Map<String, String> item) {
    final name = item['name']!;
    return Product(
      id: 'yora_${name.toLowerCase().replaceAll(' ', '_')}',
      name: name,
      price: _number(item['price']!),
      emoji: '👗',
      description: 'Stylish $name from the YORA Women collection.',
    );
  }

  void _addToCart(Map<String, String> item) {
    context.read<CartProvider>().addToCart(_toProduct(item));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} added to cart 🛒'),
        backgroundColor: burgundy,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  void _toggleWishlist(Map<String, String> item) {
    WishlistService.instance.toggleWishlist(
      productName: item['name']!,
      price: item['price']!,
      oldPrice: item['oldPrice']!,
      imagePath: item['image']!,
      discount: '',
      rating: item['rating']!,
    );

    setState(() {});

    final saved = WishlistService.instance.isWishlisted(item['name']!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved
              ? '${item['name']} added to Wishlist ❤️'
              : '${item['name']} removed from Wishlist',
        ),
        backgroundColor: burgundy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openProduct(Map<String, String> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(
          productName: item['name']!,
          price: item['price']!,
          oldPrice: item['oldPrice']!,
          imagePath: item['image']!,
          discount: '',
          rating: item['rating']!,
        ),
      ),
    );
  }

  List<Map<String, String>> get visibleProducts {
    if (selectedCategory == 'All') return products;

    switch (selectedCategory) {
      case 'Sarees':
        return products.where((p) => p['name']!.contains('Saree')).toList();
      case 'Kurtis':
        return products.where((p) => p['name']!.contains('Kurti')).toList();
      case 'Dresses':
        return products.where((p) => p['name']!.contains('Dress')).toList();
      case 'Bags':
        return products.where((p) => p['name']!.contains('Handbag')).toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'YORA',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Wishlist',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WishlistScreen(),
                ),
              ).then((_) {
                if (mounted) setState(() {});
              });
            },
            icon: const Icon(Icons.favorite_border_rounded, color: burgundy),
          ),
          IconButton(
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_bag_outlined, color: burgundy),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WOMEN',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Elegance in every detail ✨',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Hero banner
            Container(
              height: 205,
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6D1F35), Color(0xFFB84D69)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -25,
                    bottom: -45,
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NEW WOMEN’S EDIT',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Own Your\nElegance.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Up to 50% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() => selectedCategory = 'All');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            'SHOP NOW',
                            style: TextStyle(
                              color: burgundy,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            const Text(
              'Explore Categories',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 15),

            SizedBox(
              height: 145,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((category) {
                  return _categoryCard(category);
                }).toList(),
              ),
            ),

            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Trending For You 🔥',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => selectedCategory = 'All'),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: burgundy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (selectedCategory != 'All') ...[
              const SizedBox(height: 3),
              Text(
                'Category: $selectedCategory',
                style: const TextStyle(color: burgundy, fontSize: 12),
              ),
            ],
            const SizedBox(height: 10),

            if (visibleProducts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('Products coming soon ✨'),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.60,
                ),
                itemBuilder: (context, index) {
                  final item = visibleProducts[index];
                  return _productCard(item);
                },
              ),

            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: softRose,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Icon(Icons.spa_rounded, color: burgundy, size: 48),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beauty & Skincare',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Glow starts with the right care.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(Map<String, String> category) {
    final title = category['name']!;
    final selected = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() => selectedCategory = title);
      },
      child: Container(
        width: 105,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: softRose,
                borderRadius: BorderRadius.circular(22),
                border: selected
                    ? Border.all(color: burgundy, width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  category['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported_outlined,
                    color: burgundy,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? burgundy : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productCard(Map<String, String> item) {
    final name = item['name']!;
    final wishlisted = WishlistService.instance.isWishlisted(name);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => _openProduct(item),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.asset(
                        item['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: softRose,
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: burgundy,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: burgundy,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'SALE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Add to Wishlist',
                      onPressed: () => _toggleWishlist(item),
                      icon: Icon(
                        wishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 20,
                        color: wishlisted ? Colors.red : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _openProduct(item),
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      item['price']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item['oldPrice']!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      item['rating']!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Add to Cart',
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      onPressed: () => _addToCart(item),
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 21,
                        color: burgundy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
