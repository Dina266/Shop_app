import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;


class OrderItems extends StatelessWidget {
  const OrderItems(this.order);

  final ord.OrderItem order ;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(8) ,
    child: ExpansionTile (
      title: Text('\$ ${order.amount}'),
      subtitle: Text (DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)),
      
      children: 
        order.products.map((prod) =>Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(prod.title , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),),
          ),
          Text('${prod.quantity} x \$${prod.price}' , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold , color: Colors.grey),),
        ],) ).toList()
      ,
    ),
    );
  }
}