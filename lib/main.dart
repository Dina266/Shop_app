import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider <Auth, Orders>(
          create: (_) => Orders(),
          update: (ctx , authValue , previousOrder) => previousOrder!
          ..getData(
            authValue.token!, 
            authValue.userId!, 
            previousOrder.orders
            ),
          ),
        ChangeNotifierProxyProvider <Auth, Products>(
          create: (_) => Products(),
          update: (ctx , authValue , previousProduct) => previousProduct!
          ..getData(
            authValue.token!, 
            authValue.userId!, 
            previousProduct.items
            ),
          ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            // useMaterial3: true,
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, AsyncSnapshot authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routName: (_) => ProductDetailScreen(),
            CartScreen.routName: (_) => CartScreen(),
            OrderScreen.routName: (_) => OrderScreen(),
            UserProductScreen.routName: (_) => UserProductScreen(),
            EditProductScreen.routName: (_) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
