import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';

import '../widgets/products_grid.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen();

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  var _showOnlyFavorits = false;
  // var _isInit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isLoading = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => setState(() => _isLoading = false)).catchError((_) =>
        setState(() => _isLoading = false)) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (selectedVal) {
                setState(() {
                  if (selectedVal == FilterOption.Favorites) {
                      _showOnlyFavorits = true;
                  } else {
                      _showOnlyFavorits = false;

                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOption.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOption.All,
                    ),
                  ],
                  ),
              Consumer <Cart>(child:  IconButton(
                icon : Icon(Icons.shopping_cart) , 
                onPressed: ()=> Navigator.of(context).pushNamed(CartScreen.routName),),
              builder: (_ , cart , ch) => BadgeW(
                child: ch!,
                value: cart.itemCount.toString(),
              )
              ),
        ],
      ),
      body: _isLoading ?  Center(
        child: CircularProgressIndicator(),
      ): ProductGrid( _showOnlyFavorits),
      drawer: AppDrawer(),
    );
  }
}
