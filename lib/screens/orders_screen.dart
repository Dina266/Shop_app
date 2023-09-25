import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show  Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Order'),),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context , listen: false).fetchAndSetOrders(),
        builder: (ctx  , AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {return CircularProgressIndicator();}
          else {
            if (snapshot.error != null) {
              return Center (child: Text('An error occured!'),);
            }
            else {
              return Consumer <Orders>(builder: (ctx, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (context, index) => OrderItems(
                  orderData.orders[index]
                  ),
              ) ,
              );
            }
          }
          
        }
        ),
    );
  }
}