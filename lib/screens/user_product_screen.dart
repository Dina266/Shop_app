
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {


  static const routName = '/user_product';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(); // here is the error when put true
  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: [
            IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(EditProductScreen.routName),
                icon: Icon(Icons.add))
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _refreshProducts(context),
                        child: Consumer<Products>(
                          builder: (ctx, productsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            
                            child: ListView.builder(
                                itemCount: productsData.items.length,
                                itemBuilder: (_, int index) => Column(
                                  
                                      children: [
                                        UserProductItem(
                                          productsData.items[index].id!,
                                          productsData.items[index].title,
                                          productsData.items[index].imageUrl,
                                        ),
                                        
                                        Divider(),
                                      ],
                                    )),
                          ),
                        ),
                      )));
  }
}
