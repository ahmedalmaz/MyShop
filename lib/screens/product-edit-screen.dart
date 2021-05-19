import 'package:flutter/material.dart';
import 'package:myshop/Providers/products.dart';
import 'package:provider/provider.dart';
import '../Providers/product.dart';

class ProductEditScreen extends StatefulWidget {
  static const routeName = '/productEditScreen';

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      Product(price: 0, title: '', id: null, description: '', imageUrl: '');
  var _isInit = true;
  var _isLoad = false;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': ''
        };
        _imageController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrlListener);
    super.initState();
  }

  void updateImageUrlListener() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageController.text.isNotEmpty &&
              !_imageController.text.startsWith('http:') &&
              !_imageController.text.startsWith('https:') ||
          !_imageController.text.endsWith('.png') &&
              !_imageController.text.endsWith('.jpg') &&
              !_imageController.text.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrlListener);
    _imageController.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void saveForm() async {
    setState(() {
      _isLoad = true;
    });
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return;
    }
    _form.currentState.save();
    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);

    } else {

      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error occurred '),
            content: Text('Some thing went wrong '),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Ok'))
            ],
          ),
        );
      }
      // finally {
      //   setState(
      //     () {
      //       _isload = false;
      //       Navigator.of(context).pop();
      //     },
      //   );
      // }

    }
    setState(() {
      _isLoad = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: saveForm)],
      ),
      body: _isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      validator: (value) {
                        if (value.isEmpty) return 'Please Enter a Title';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            title: value,
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite,
                            imageUrl: _editProduct.imageUrl,
                            description: _editProduct.description,
                            price: _editProduct.price);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a Price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please Enter a Valid Number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please Enter Number Greater Than 0 ';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'price',
                      ),
                      focusNode: _priceFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            title: _editProduct.title,
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite,
                            imageUrl: _editProduct.imageUrl,
                            description: _editProduct.description,
                            price: double.parse(value));
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a Description';
                        }
                        if (value.length < 10) {
                          return 'Description Should Be More Than 10 Characters .';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'description',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editProduct = Product(
                            title: _editProduct.title,
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite,
                            imageUrl: _editProduct.imageUrl,
                            description: value,
                            price: _editProduct.price);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: _imageController.text.isEmpty
                              ? Center(child: Text('Enter URL'))
                              : FittedBox(
                                  child: Image.network(
                                    _imageController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          margin: EdgeInsets.only(right: 8, top: 8),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            // borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Pls enter URL';
                              }
                              if (!value.startsWith('http:') &&
                                  !value.startsWith('https:')) {
                                return 'Pls Enter Valid URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Pls Enter Valid URL';
                              }
                              return null;
                            },
                            controller: _imageController,
                            onFieldSubmitted: (_) {
                              saveForm();
                            },
                            decoration: InputDecoration(
                              labelText: 'Image Url',
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            focusNode: _imageUrlFocusNode,
                            onSaved: (value) {
                              _editProduct = Product(
                                  title: _editProduct.title,
                                  id: _editProduct.id,
                                  isFavorite: _editProduct.isFavorite,
                                  imageUrl: value,
                                  description: _editProduct.description,
                                  price: _editProduct.price);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
