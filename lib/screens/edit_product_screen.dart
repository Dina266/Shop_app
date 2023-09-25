
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/edit_product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _fromKey = GlobalKey<FormState>();
  var _editedProduct =
      Product(
      id: null, 
      title: '', 
      description: '', 
      price: 0, 
      imageUrl: '',
      );

  var _initialValue = {
    'id': '',
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var _isLoading = false;
  var _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _descriptionFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http')) &&
              (!_imageUrlController.text.startsWith('http')) ||
          ((!_imageUrlController.text.endsWith('.png'))) &&
              (!_imageUrlController.text.endsWith('.jpg')) &&
              (!_imageUrlController.text.endsWith('.jpeg'))) return;
    }
    setState(() {});
  }


  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;

      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initialValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }
  }
Future<void> _saveForm() async {
    final isValid = _fromKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _fromKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {

      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id! , _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: [
              TextButton(
                child: Text('Okay!'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _fromKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initialValue['title'].toString(),
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value!,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValue['price'].toString(),
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please provide a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please provide a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(value!),
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValue['description'].toString(),
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        focusNode: _descriptionFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value!,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _imageUrlController,
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.next,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_descriptionFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a image URL.';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!value.endsWith('png') &&
                                    !value.endsWith('jpeg') &&
                                    !value.endsWith('jpg')) {
                                  return 'Please enter a valid URL';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value!,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}
