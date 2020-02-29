import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../models/edited_product.dart';
import '../providers/cart.dart' show Cart;

class EditProductScreen extends StatefulWidget {
  static const String routeName = 'edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // TODO: remember this
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  // TODO: dispose FocusNode() after exiting this page to avoid memory leaks
  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
  }

  // TODO: lose focusing on imageUrl textField, image will update
  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final index = ModalRoute.of(context).settings.arguments as int;
    final products = Provider.of<Products>(context);
    final product = products.items[index];
    _imageUrlController.text = product.imageUrl;
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      // TODO: for update image
      setState(() {});
    }
  }

  ProductForm _editedProduct = Edited().editedProduct;

  @override
  Widget build(BuildContext context) {
    final productIndex = ModalRoute.of(context).settings.arguments as int;
    final products = Provider.of<Products>(context);
    final product = products.items[productIndex];

    void _saveFormForEditing() {
      final validate = _form.currentState.validate();
      if (!validate) return;
      _form.currentState.save();
    }

    void _updateItem() {
      final validate = _form.currentState.validate();
      if (validate) {
        Product newProduct = Product(
          id: product.id,
          title: _editedProduct.title,
          description: _editedProduct.description,
          price: _editedProduct.price,
          imageUrl: _editedProduct.imageUrl,
          isFavorite: product.isFavorite,
        );
        products.updateItem(productIndex, newProduct);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: <Widget>[
          RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              setState(() {
                _saveFormForEditing();
              });
            },
            child: Text(
              'Check Input',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          IconButton(
            onPressed: () {
              final validate = _form.currentState.validate();
              validate
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Edit ?"),
                          content: Text("This will modify your product."),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Ok"),
                              onPressed: () {
                                _saveFormForEditing();
                                _updateItem();
                                //TODO: update price
                                final cartData =
                                    Provider.of<Cart>(context, listen: false);
                                cartData.updatePrice(
                                    product.id, _editedProduct.price);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    )
                  : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Please correct your input"),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FlatButton(
                              child: Text("Ok"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      // TODO: check out this link: https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/15145432#questions
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // TODO: Focus on Form
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              // TODO: 'textInputAction' control the bottom right button in the soft keyboard
              TextFormField(
                initialValue: product.title,
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = ProductForm(
                    id: null,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: product.price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                // TODO: save for each TextFormField
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a price greater than zero.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = ProductForm(
                    id: null,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: product.description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                // TODO: TextInputType.multiline add 'Enter' button
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Please enter at least 10 charaters long.';
                  }

                  return null;
                },
                onSaved: (value) {
                  _editedProduct = ProductForm(
                    id: null,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Center(child: Text('Enter your URL'))
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  // TODO: if not having Expanded => error: An InputDecorator, which is typically created by a TextField, cannot have an unbounded width
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      // TODO: this is updated when we type into the text form field
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveFormForEditing();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (!value.startsWith('http://') &&
                            !value.startsWith('https://')) {
                          return 'Please enter a valid URL';
                        }

                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpeg') &&
                            !value.endsWith('.jpg')) {
                          return 'Valid URL extension is png, jpg, jpeg';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = ProductForm(
                          id: null,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value,
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
