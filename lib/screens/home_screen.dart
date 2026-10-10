
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/wishlist_service.dart';
import 'women_screen.dart';
import 'men_screen.dart';
import 'product_details_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primary = Color(0xFF8B1E3F);
  static const Color darkText = Color(0xFF202020);
  static const Color greyText = Color(0xFF777777);
  static const Color pageBackground = Color(0xFFF8F8F8);

  int selectedBottomIndex = 0;

  final String womenImage =
      'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=900&q=85';

  final String menImage =
      'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?auto=format&fit=crop&w=900&q=85';

  final String girlsImage =
      'https://images.unsplash.com/photo-1596870230751-ebdfce98ec42?auto=format&fit=crop&w=900&q=85';

  final String boysImage =
      'https://images.unsplash.com/photo-1519457431-44ccd64a579b?auto=format&fit=crop&w=900&q=85';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: WishlistService.instance,
      builder: (context, child) {
        final wishlist = WishlistService.instance;

        return Scaffold(
          backgroundColor: pageBackground,

          // APP BAR
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 20,
            title: const Text(
              'YORA',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: primary,
              ),
            ),
            actions: [
              // WISHLIST ICON
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    tooltip: 'Wishlist',
                    onPressed: _openWishlist,
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      color: darkText,
                      size: 27,
                    ),
                  ),
                  if (wishlist.items.isNotEmpty)
                    Positioned(
                      top: 7,
                      right: 5,
                      child: _countBadge(wishlist.items.length),
                    ),
                ],
              ),

              // MY ORDERS ICON
              IconButton(
                tooltip: 'My Orders',
                onPressed: () {
                  Navigator.pushNamed(context, '/orders');
                },
                icon: const Icon(
                  Icons.receipt_long_outlined,
                  color: primary,
                  size: 27,
                ),
              ),

              // CART ICON
              IconButton(
                tooltip: 'Shopping Cart',
                onPressed: _openCart,
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: darkText,
                  size: 27,
                ),
              ),

              const SizedBox(width: 6),
            ],
          ),

          // HOME PAGE BODY
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;
              final horizontal = isDesktop ? 50.0 : 20.0;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SEARCH
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontal,
                        vertical: 18,
                      ),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              _showMessage(
                                'Searching for "${value.trim()}"',
                              );
                            }
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Search for products, brands and more...',
                            hintStyle: const TextStyle(
                              color: greyText,
                              fontSize: 13,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: primary,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => _showMessage(
                                'Voice search coming soon 🎤',
                              ),
                              icon: const Icon(
                                Icons.mic_none_rounded,
                                color: greyText,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ),

                    // HERO BANNER
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontal,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: isDesktop ? 300 : 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF5A1028),
                              Color(0xFF8B1E3F),
                              Color(0xFFB43B5E),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.20),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -70,
                              top: -70,
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                isDesktop ? 35 : 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Text(
                                      'YORA EXCLUSIVE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'Style. Beauty. You.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isDesktop ? 36 : 28,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Discover your perfect style\nwith our latest collection.',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.90),
                                      fontSize: isDesktop ? 16 : 13,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showMessage(
                                        'Explore the latest YORA collection ✨',
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: primary,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: 13,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      'SHOP NOW',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // CATEGORY TITLE
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontal,
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shop by Category',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: darkText,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Find your perfect style',
                            style: TextStyle(
                              fontSize: 13,
                              color: greyText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // CATEGORY GRID
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontal,
                      ),
                      child: GridView.count(
                        crossAxisCount: isDesktop ? 4 : 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: isDesktop ? 1.25 : 0.95,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildCategoryCard(
                            title: 'Women',
                            subtitle: 'Fashion & Beauty',
                            imageUrl: womenImage,
                            color: const Color(0xFF8B1E3F),
                            icon: Icons.woman_rounded,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WomenScreen(),
                                ),
                              );
                            },
                          ),
                          _buildCategoryCard(
                            title: 'Men',
                            subtitle: 'Style & Grooming',
                            imageUrl: menImage,
                            color: const Color(0xFF102A43),
                            icon: Icons.person_rounded,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MenScreen(),
                                ),
                              );
                            },
                          ),
                          _buildCategoryCard(
                            title: 'Girls',
                            subtitle: 'Cute & Trendy',
                            imageUrl: girlsImage,
                            color: const Color(0xFF7B4FA3),
                            icon: Icons.face_3_rounded,
                            onTap: () {
                              _showMessage(
                                'Girls collection coming soon 💜',
                              );
                            },
                          ),
                          _buildCategoryCard(
                            title: 'Boys',
                            subtitle: 'Fresh & Sporty',
                            imageUrl: boysImage,
                            color: const Color(0xFF087F8C),
                            icon: Icons.face_rounded,
                            onTap: () {
                              _showMessage(
                                'Boys collection coming soon 💙',
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // TRENDING TITLE
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontal,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trending Now',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: darkText,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Most loved styles on YORA',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: greyText,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              _showMessage(
                                'You are viewing trending products',
                              );
                            },
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // TRENDING PRODUCTS
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontal,
                      ),
                      child: GridView.count(
                        crossAxisCount: isDesktop ? 4 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 18,
                        childAspectRatio: isDesktop ? 0.72 : 0.68,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildMiniProduct(
                            name: 'Elegant Kurti',
                            price: '₹899',
                            oldPrice: '₹1,499',
                            imagePath: 'assets/products/trending_kurti.jpg',
                            discount: '40% OFF',
                            rating: '4.6',
                          ),
                          _buildMiniProduct(
                            name: 'Designer Saree',
                            price: '₹1,299',
                            oldPrice: '₹2,499',
                            imagePath: 'assets/products/saree.jpg',
                            discount: '48% OFF',
                            rating: '4.8',
                          ),
                          _buildMiniProduct(
                            name: 'Premium Handbag',
                            price: '₹799',
                            oldPrice: '₹1,299',
                            imagePath: 'assets/products/handbag.jpg',
                            discount: '38% OFF',
                            rating: '4.5',
                          ),
                          _buildMiniProduct(
                            name: 'Floral Dress',
                            price: '₹999',
                            oldPrice: '₹1,799',
                            imagePath: 'assets/products/dress.jpg',
                            discount: '44% OFF',
                            rating: '4.7',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // BEAUTY OFFER
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontal,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF202020),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 15,
                              offset: const Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'YORA BEAUTY EDIT',
                                    style: TextStyle(
                                      color: Color(0xFFF4C6D5),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Beauty that feels like you.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Explore skincare, grooming & beauty essentials.',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showMessage(
                                        'Beauty collection coming soon ✨',
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFFF4C6D5),
                                      foregroundColor:
                                          const Color(0xFF202020),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: const Text(
                                      'EXPLORE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: Color(0xFFF4C6D5),
                              size: 65,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // FOOTER
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'YORA',
                              style: TextStyle(
                                color: primary,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Style. Beauty. You.',
                              style: TextStyle(
                                color: greyText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // BOTTOM NAVIGATION
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: selectedBottomIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: primary,
              unselectedItemColor: greyText,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              elevation: 0,
              onTap: (index) {
                setState(() => selectedBottomIndex = index);

                if (index == 1) {
                  _showMessage(
                    'Categories: choose a category above 📂',
                  );
                } else if (index == 2) {
                  _openWishlist();
                } else if (index == 3) {
                  _showMessage('Profile coming soon 👤');
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_outlined),
                  activeIcon: Icon(Icons.grid_view_rounded),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border_rounded),
                  activeIcon: Icon(Icons.favorite_rounded),
                  label: 'Wishlist',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // OPEN WISHLIST
  void _openWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WishlistScreen(),
      ),
    ).then((_) {
      if (mounted) {
        setState(() => selectedBottomIndex = 0);
      }
    });
  }

  // OPEN CART
  void _openCart() {
    Navigator.pushNamed(context, '/cart');
  }

  // SMALL COUNT BADGE
  Widget _countBadge(int count) {
    return Container(
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(
        minWidth: 17,
        minHeight: 17,
      ),
      decoration: const BoxDecoration(
        color: primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ADD / REMOVE WISHLIST
  void _toggleWishlist({
    required String name,
    required String price,
    required String oldPrice,
    required String imagePath,
    required String discount,
    required String rating,
  }) {
    final service = WishlistService.instance;
    final wasWishlisted = service.isWishlisted(name);

    service.toggleWishlist(
      productName: name,
      price: price,
      oldPrice: oldPrice,
      imagePath: imagePath,
      discount: discount,
      rating: rating,
    );

    _showMessage(
      wasWishlisted
          ? '$name removed from wishlist'
          : '$name added to wishlist ❤️',
    );
  }

  // ADD FASHION PRODUCT TO CART
  void _addFashionProductToCart({
    required String name,
    required String price,
  }) {
    final numericPrice = double.parse(
      price.replaceAll(RegExp(r'[^0-9.]'), ''),
    );

    final product = Product(
      id: 'yora_${name.toLowerCase().replaceAll(' ', '_')}',
      name: name,
      price: numericPrice,
      emoji: '👗',
      description: 'Stylish $name from the YORA collection.',
    );

    context.read<CartProvider>().addToCart(product);

    _showMessage('$name added to cart 🛍️');
  }

  // OPEN PRODUCT DETAILS
  void _openProductDetails({
    required String productName,
    required String price,
    required String oldPrice,
    required String imagePath,
    required String discount,
    required String rating,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(
          productName: productName,
          price: price,
          oldPrice: oldPrice,
          imagePath: imagePath,
          discount: discount,
          rating: rating,
        ),
      ),
    );
  }

  // CATEGORY CARD
  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.20),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: color,
                      child: Icon(
                        icon,
                        size: 70,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.75),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 12,
                bottom: 14,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 21),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TRENDING PRODUCT CARD
  Widget _buildMiniProduct({
    required String name,
    required String price,
    required String oldPrice,
    required String imagePath,
    required String discount,
    required String rating,
  }) {
    final isWishlisted =
        WishlistService.instance.isWishlisted(name);

    return GestureDetector(
      onTap: () => _openProductDetails(
        productName: name,
        price: price,
        oldPrice: oldPrice,
        imagePath: imagePath,
        discount: discount,
        rating: rating,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRODUCT IMAGE AND HEART
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF2F2F2),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          discount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.94),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _toggleWishlist(
                            name: name,
                            price: price,
                            oldPrice: oldPrice,
                            imagePath: imagePath,
                            discount: discount,
                            rating: rating,
                          ),
                          icon: Icon(
                            isWishlisted
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 20,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PRODUCT DETAILS
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkText,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              oldPrice,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                color: greyText,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9F7EE),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 13,
                                  color: Color(0xFF168A3B),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  rating,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF168A3B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _addFashionProductToCart(
                              name: name,
                              price: price,
                            ),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7E7EC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                size: 18,
                                color: primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SNACKBAR
  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: primary,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}
