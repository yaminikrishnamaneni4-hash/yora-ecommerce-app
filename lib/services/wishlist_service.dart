import 'package:flutter/foundation.dart';

class WishlistService extends ChangeNotifier {
  WishlistService._privateConstructor();

  static final WishlistService instance =
      WishlistService._privateConstructor();

  final List<Map<String, String>> _items = [];

  List<Map<String, String>> get items {
    return List.unmodifiable(_items);
  }

  bool isWishlisted(String productName) {
    return _items.any(
      (item) => item['productName'] == productName,
    );
  }

  void addToWishlist({
    required String productName,
    required String price,
    required String oldPrice,
    required String imagePath,
    required String discount,
    required String rating,
  }) {
    // Already exists → don't add again
    if (isWishlisted(productName)) {
      return;
    }

    _items.add({
      'productName': productName,
      'price': price,
      'oldPrice': oldPrice,
      'imagePath': imagePath,
      'discount': discount,
      'rating': rating,
    });

    notifyListeners();
  }

  void removeFromWishlist(String productName) {
    _items.removeWhere(
      (item) => item['productName'] == productName,
    );

    notifyListeners();
  }

  void toggleWishlist({
    required String productName,
    required String price,
    required String oldPrice,
    required String imagePath,
    required String discount,
    required String rating,
  }) {
    if (isWishlisted(productName)) {
      removeFromWishlist(productName);
    } else {
      addToWishlist(
        productName: productName,
        price: price,
        oldPrice: oldPrice,
        imagePath: imagePath,
        discount: discount,
        rating: rating,
      );
    }
  }

  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }
}