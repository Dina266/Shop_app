import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routName = '/product_detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context , listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(title: Text('product detail'),),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(title: Text(loadedProduct.title),
            background: Hero(tag: loadedProduct.id!, child: Image.network(loadedProduct.imageUrl , fit: BoxFit.cover,)),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10,),
                Text(
                  '\$${loadedProduct.price}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey , fontSize: 20),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    loadedProduct.description,
                    textAlign : TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ]

            )
            ),
        ],
      )
    );
  }
}