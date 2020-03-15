import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../models/product_adding.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../helpers/screen_controller.dart';
import '../screens/user_products_screen.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = 'add_product_screen';

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // TODO: remember this
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

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

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      // TODO: for update image
      setState(() {});
    }
  }

  ProductAdding _editedProduct = Edited().editedProduct;

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    Future<void> _saveFormForAdding() async {
      final validate = _form.currentState.validate();
      if (!validate) return;
      _form.currentState.save();
    }

    Future<void> _addProduct() async {
      _saveFormForAdding();
      setState(() {
        _isLoading = true;
      });
      final validate = _form.currentState.validate();
      if (validate) {
        try {
          await products.addProduct(_editedProduct);
          //TODO: http request and addProduct finish, then navigator
        } catch (error) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Something went wrong'),
              content: Text(error.toString()),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                )
              ],
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
          // TODO: Navigate to UserProductsScreen and then remove all route memory
          Navigator.of(context).pushNamedAndRemoveUntil(
              UserProductsScreen.routeName, (Route<dynamic> route) => false);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Product'),
        actions: <Widget>[
          RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              setState(() {
                _saveFormForAdding();
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
                          title: Text("Add Product ?"),
                          content: Text("Add this new product to your shop ?"),
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
                                Navigator.of(context).pop();
                                _addProduct().then((_) {
                                  ScreenController
                                      .setFirstLoadingOnProductsOverviewScreen(
                                          true);
                                  ScreenController
                                      .setFirstLoadingOnUserProductsScreen(
                                          true);
                                });
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
      body: _isLoading
          ?
          // TODO: Add loading indicator
          SpinKitFadingCircle(
              color: Theme.of(context).primaryColor,
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              // TODO: Focus on Form
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    // TODO: 'textInputAction' control the bottom right button in the soft keyboard
                    TextFormField(
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
                        _editedProduct = ProductAdding(
                          id: null,
                          title: value,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
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
                        _editedProduct = ProductAdding(
                          id: null,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
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
                        _editedProduct = ProductAdding(
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
                                  child:
                                      Image.network(_imageUrlController.text),
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
                              _saveFormForAdding();
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
                              _editedProduct = ProductAdding(
                                id: null,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
