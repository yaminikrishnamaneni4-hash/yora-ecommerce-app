
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';
import 'providers/cart_provider.dart';
import 'theme/app_theme.dart';

import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/my_orders_screen.dart';

void main() {
  runApp(const ShopEaseApp());
}

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'YORA',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: '/',

        // NORMAL ROUTES
        routes: {
          '/': (context) => const HomeScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),

          // MY ORDERS ROUTE
          '/orders': (context) => const MyOrdersScreen(),
        },

        // PRODUCT DETAILS ROUTE
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final product = settings.arguments as Product;

            String oldPrice = '₹0';
            String imagePath = '';
            String discount = '20% OFF';
            String rating = '4.5';

            // ELEGANT KURTI
            if (product.name == 'Elegant Kurti') {
              oldPrice = '₹1,499';
              imagePath = 'assets/products/trending_kurti.jpg';
              discount = '40% OFF';
              rating = '4.6';
            }

            // DESIGNER SAREE
            else if (product.name == 'Designer Saree') {
              oldPrice = '₹2,499';
              imagePath = 'assets/products/designer_saree.jpg';
              discount = '48% OFF';
              rating = '4.8';
            }

            // PREMIUM HANDBAG
            else if (product.name == 'Premium Handbag') {
              oldPrice = '₹1,299';
              imagePath = 'assets/products/handbag_product.jpg';
              discount = '38% OFF';
              rating = '4.5';
            }

            // FLORAL DRESS
            else if (product.name == 'Floral Dress') {
              oldPrice = '₹1,799';
              imagePath = 'assets/products/floral_dress.jpg';
              discount = '44% OFF';
              rating = '4.7';
            }

            // OTHER PRODUCTS
            else {
              oldPrice =
                  '₹${(product.price * 1.5).toStringAsFixed(0)}';
              discount = '20% OFF';
              rating = '4.5';
              imagePath = '';
            }

            // OPEN PRODUCT DETAILS
            return MaterialPageRoute(
              builder: (context) {
                return ProductDetailsScreen(
                  productName: product.name,
                  price: '₹${product.price.toStringAsFixed(0)}',
                  oldPrice: oldPrice,
                  imagePath: imagePath,
                  discount: discount,
                  rating: rating,
                );
              },
            );
          }

          return null;
        },
      ),
    );
  }
}
