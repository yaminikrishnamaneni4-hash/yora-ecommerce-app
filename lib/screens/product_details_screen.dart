import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/wishlist_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String price;
  final String oldPrice;
  final String imagePath;
  final String discount;
  final String rating;

  const ProductDetailsScreen({
    super.key,
    required this.productName,
    required this.price,
    required this.oldPrice,
    required this.imagePath,
    required this.discount,
    required this.rating,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {
  String selectedSize = 'M';
  int quantity = 1;
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    isWishlisted =
        WishlistService.instance.isWishlisted(widget.productName);
  }

  double _getPrice() {
    final cleanedPrice =
        widget.price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleanedPrice) ?? 0.0;
  }

  Product _createProduct() {
    return Product(
      id: 'yora_${widget.productName.toLowerCase().replaceAll(' ', '_')}',
      name: widget.productName,
      price: _getPrice(),
      emoji: '👗',
      description:
          'Stylish ${widget.productName} from the ShopEase collection. '
          'Selected size: $selectedSize.',
    );
  }

  // WISHLIST
  void _toggleWishlist() {
    WishlistService.instance.toggleWishlist(
      productName: widget.productName,
      price: widget.price,
      oldPrice: widget.oldPrice,
      imagePath: widget.imagePath,
      discount: widget.discount,
      rating: widget.rating,
    );

    setState(() {
      isWishlisted =
          WishlistService.instance.isWishlisted(widget.productName);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            isWishlisted
                ? '${widget.productName} added to wishlist ❤️'
                : '${widget.productName} removed from wishlist',
          ),
          backgroundColor: const Color(0xFF8B1E3F),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ADD TO CART
  void _addToCart() {
    if (_getPrice() <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid product price!')),
      );
      return;
    }

    final cart = context.read<CartProvider>();
    final product = _createProduct();

    for (int i = 0; i < quantity; i++) {
      cart.addToCart(product);
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$quantity x ${widget.productName} added to cart 🛍️',
          ),
          backgroundColor: const Color(0xFF8B1E3F),
          behavior: SnackBarBehavior.floating,
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

  // BUY NOW
  void _buyNow() {
    if (_getPrice() <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid product price!')),
      );
      return;
    }

    final cart = context.read<CartProvider>();
    final product = _createProduct();

    // Add the selected quantity to the cart.
    for (int i = 0; i < quantity; i++) {
      cart.addToCart(product);
    }

    // Navigate directly to checkout.
    Navigator.pushNamed(context, '/checkout');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleWishlist,
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted
                  ? const Color(0xFF8B1E3F)
                  : Colors.black,
              size: 27,
            ),
          ),
        ],
      ),

      // BODY
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRODUCT IMAGE
            Container(
              width: double.infinity,
              height: 420,
              color: Colors.white,
              child: Stack(
                children: [
                  if (widget.imagePath.isNotEmpty)
                    Positioned.fill(
                      child: Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 70,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 70,
                        color: Colors.grey,
                      ),
                    ),

                  Positioned(
                    top: 18,
                    left: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B1E3F),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.discount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 15,
                    right: 15,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _toggleWishlist,
                        icon: Icon(
                          isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isWishlisted
                              ? const Color(0xFF8B1E3F)
                              : Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PRODUCT INFORMATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202020),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.rating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Highly Rated',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Text(
                        widget.price,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF202020),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.oldPrice,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${widget.discount} discount',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // SIZE SELECTION
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _sizeButton('S'),
                      _sizeButton('M'),
                      _sizeButton('L'),
                      _sizeButton('XL'),
                      _sizeButton('XXL'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // QUANTITY
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() => quantity--);
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                        ),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => quantity++);
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // PRODUCT DESCRIPTION
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(18),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Premium quality product from ShopEase. '
                    'Designed with comfort, style and quality in mind. '
                    'Perfect for your everyday fashion needs.',
                    style: TextStyle(
                      color: Colors.grey,
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // BOTTOM BUTTONS
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _addToCart,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF8B1E3F),
                    side: const BorderSide(
                      color: Color(0xFF8B1E3F),
                    ),
                    minimumSize: const Size(
                      double.infinity,
                      52,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'ADD TO CART',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: _buyNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B1E3F),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(
                      double.infinity,
                      52,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'BUY NOW',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SIZE BUTTON
  Widget _sizeButton(String size) {
    final bool selected = selectedSize == size;

    return GestureDetector(
      onTap: () {
        setState(() => selectedSize = size);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 48,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF8B1E3F)
              : Colors.white,
          border: Border.all(
            color: selected
                ? const Color(0xFF8B1E3F)
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
