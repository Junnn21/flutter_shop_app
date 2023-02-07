import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import './providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', ''),
          update: (_, auth, products) => Products(auth.token, auth.userId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart()
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '',[]),
          update: (_, auth, previousOrders) => Orders(
            auth.token, 
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders),
        )
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) =>
        MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.purple,
              secondary: Colors.deepOrange, 
            ),
            fontFamily: 'Lato'
          ),
          home: auth.isAuth ? 
            ProductsOverviewScreen() 
            : 
            FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: 
                (ctx, authResultSnapshot) => 
                  authResultSnapshot.connectionState == ConnectionState.waiting ? 
                    SplashScreen()
                    :  
                    AuthScreen()
            ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen()
          },
        ),
      ),
    );
  }
}