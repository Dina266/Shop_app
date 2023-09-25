import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  UserProductItem(this.id,  this.title, this.imageURl);
  final String id; 
  final String title;
  final String imageURl;

  

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routName , arguments: id),
              icon: Icon(Icons.edit)),
            IconButton(
              onPressed: () async{
                try{
                  await Provider.of<Products>(context).deleteProduct(id);

                }catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Deleting failed!' , textAlign: TextAlign.center,)
                  ));
                }
                
              }, 
              color: Theme.of(context).colorScheme.error,
              icon: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}