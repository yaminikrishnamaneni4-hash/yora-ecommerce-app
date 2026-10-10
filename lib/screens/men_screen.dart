
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/wishlist_service.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';

class MenScreen extends StatelessWidget {
  const MenScreen({super.key});

  static const Color navy = Color(0xFF102A43);
  static const Color darkNavy = Color(0xFF071A2B);
  static const Color blue = Color(0xFF15558C);
  static const Color lightBlue = Color(0xFFE6F0F8);
  static const Color background = Color(0xFFF7F9FC);
  static const Color textColor = Color(0xFF17202A);
  static const Color subText = Color(0xFF68737D);

  static const List<Map<String, String>> categories = [
    {
      'title': 'T-Shirts',
      'subtitle': 'Casual & trendy',
      'image': 'assets/men/tshirts.jpg',
    },
    {
      'title': 'Shoes',
      'subtitle': 'Step up your style',
      'image': 'assets/men/shoes.jpg',
    },
    {
      'title': 'Watches',
      'subtitle': 'Classic timepieces',
      'image': 'assets/men/watch.jpg',
    },
    {
      'title': 'Accessories',
      'subtitle': 'Complete your look',
      'image': 'assets/men/accesories.jpg',
    },
  ];

  static const List<Map<String, String>> products = [
    {
      'name': 'Premium T-Shirt',
      'price': '₹599',
      'oldPrice': '₹999',
      'rating': '4.7',
      'discount': '40% OFF',
      'image': 'assets/men/tshirts.jpg',
      'emoji': '👕',
    },
    {
      'name': 'Classic Sneakers',
      'price': '₹1,299',
      'oldPrice': '₹2,199',
      'rating': '4.8',
      'discount': '41% OFF',
      'image': 'assets/men/shoes.jpg',
      'emoji': '👟',
    },
    {
      'name': 'Classic Watch',
      'price': '₹1,599',
      'oldPrice': '₹2,999',
      'rating': '4.7',
      'discount': '47% OFF',
      'image': 'assets/men/watch.jpg',
      'emoji': '⌚',
    },
    {
      'name': 'Fashion Accessories',
      'price': '₹499',
      'oldPrice': '₹799',
      'rating': '4.6',
      'discount': '38% OFF',
      'image': 'assets/men/accesories.jpg',
      'emoji': '🕶️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildAppBar(context, isMobile),
                ),
                SliverToBoxAdapter(
                  child: _buildHeroBanner(isMobile),
                ),
                SliverToBoxAdapter(
                  child: _sectionHeading(
                    "Men's Categories",
                    'Everything you need to define your style',
                    isMobile,
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 18 : 36,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildCategory(categories[index]),
                      childCount: categories.length,
                    ),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 2 : 4,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: isMobile ? 0.82 : 0.95,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _sectionHeading(
                    'Trending for Men',
                    "Top styles you'll love",
                    isMobile,
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 18 : 36,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildProduct(
                        context,
                        products[index],
                      ),
                      childCount: products.length,
                    ),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 2 : 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isMobile ? 0.62 : 0.72,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 18 : 36),
                    child: _buildGroomingBanner(),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 30),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sectionHeading(
    String title,
    String subtitle,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 18 : 36,
        28,
        isMobile ? 18 : 36,
        18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: subText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 28,
        vertical: 10,
      ),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: textColor,
            ),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YORA',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    color: textColor,
                  ),
                ),
                Text(
                  'MEN',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: navy,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.shopping_bag_outlined,
            color: navy,
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(bool isMobile) {
    return Container(
      height: isMobile ? 220 : 280,
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 36,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: darkNavy,
        borderRadius: BorderRadius.circular(26),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: isMobile ? 150 : 270,
            child: Image.asset(
              'assets/men/tshirts.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: navy,
                  child: const Icon(
                    Icons.checkroom_rounded,
                    color: Colors.white38,
                    size: 90,
                  ),
                );
              },
            ),
          ),
          Container(
            width: isMobile ? 270 : 440,
            padding: EdgeInsets.all(isMobile ? 20 : 35),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  darkNavy,
                  darkNavy.withOpacity(0.92),
                  Colors.transparent,
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "MEN'S EDIT",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Own Your Style.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 24 : 35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Premium fashion for every occasion.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'UP TO 50% OFF',
                      style: TextStyle(
                        color: darkNavy,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              item['image']!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: lightBlue,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: blue,
                    size: 38,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
            child: Column(
              children: [
                Text(
                  item['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: subText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduct(
    BuildContext context,
    Map<String, String> item,
  ) {
    final wishlist = WishlistService.instance;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    item['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: lightBlue,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 42,
                          color: blue,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: navy,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      item['discount']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // Wishlist heart
                Positioned(
                  top: 5,
                  right: 5,
                  child: AnimatedBuilder(
                    animation: wishlist,
                    builder: (context, child) {
                      final isFavorite = wishlist.isWishlisted(
                        item['name']!,
                      );

                      return Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: 'Add to wishlist',
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite ? Colors.red : navy,
                            size: 21,
                          ),
                          onPressed: () {
                            wishlist.toggleWishlist(
                              productName: item['name']!,
                              price: item['price']!,
                              oldPrice: item['oldPrice']!,
                              imagePath: item['image']!,
                              discount: item['discount']!,
                              rating: item['rating']!,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite
                                      ? 'Removed from wishlist'
                                      : 'Added to wishlist ❤️',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item['name']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 15,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      item['rating']!,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      item['price']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        item['oldPrice']!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Add to Cart
                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    onPressed: () {
                      final numericPrice = double.parse(
                        item['price']!.replaceAll(
                          RegExp(r'[^0-9.]'),
                          '',
                        ),
                      );

                      final product = Product(
                        id: 'yora_${item['name']!.toLowerCase().replaceAll(' ', '_')}',
                        name: item['name']!,
                        price: numericPrice,
                        emoji: item['emoji']!,
                        description: item['name']!,
                      );

                      context.read<CartProvider>().addToCart(product);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${item['name']} added to cart 🛒',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 16,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
  }

  Widget _buildGroomingBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [darkNavy, navy],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.style_rounded,
            color: Colors.white,
            size: 45,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Your Look',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Explore watches, shoes and everyday accessories.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
