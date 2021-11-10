import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  final ProductFromValues _initValues = ProductFromValues();

  bool _isInit = true;

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .getProductById(productId as String);
        _initValues.title = _editedProduct.title;
        _initValues.price = _editedProduct.price;
        _initValues.description = _editedProduct.description;
        _imageUrlController.text = _editedProduct.imageUrl;
        setState(() {});
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageURLFocusNode.hasFocus) {
      var value = _imageUrlController.text;
      if (value.isEmpty ||
          (!value.startsWith('http') && !value.startsWith('https')) ||
          ((!value.endsWith('.png') &&
              !value.endsWith('.jpg') &&
              !value.endsWith('.jpeg')))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm(BuildContext context) {
    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _form.currentState?.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
  }

  _onFieldSave(fieldName) {
    return (value) {
      switch (fieldName) {
        case Product.TITLE:
          _editedProduct = Product(
              id: _editedProduct.id,
              title: value ?? _editedProduct.title,
              description: _editedProduct.description,
              price: _editedProduct.price,
              imageUrl: _editedProduct.imageUrl,
              isFavorite: _editedProduct.isFavorite);
          break;
        case Product.PRICE:
          _editedProduct = Product(
              id: _editedProduct.id,
              title: _editedProduct.title,
              description: _editedProduct.description,
              price: double.parse(value ?? _editedProduct.price.toString()),
              imageUrl: _editedProduct.imageUrl,
              isFavorite: _editedProduct.isFavorite);
          break;
        case Product.DESCRIPTION:
          _editedProduct = Product(
              id: _editedProduct.id,
              title: _editedProduct.title,
              description: value ?? _editedProduct.description,
              price: _editedProduct.price,
              imageUrl: _editedProduct.imageUrl,
              isFavorite: _editedProduct.isFavorite);
          break;
        case Product.IMAGE_URL:
          _editedProduct = Product(
              id: _editedProduct.id,
              title: _editedProduct.title,
              description: _editedProduct.description,
              price: _editedProduct.price,
              imageUrl: value ?? _editedProduct.imageUrl,
              isFavorite: _editedProduct.isFavorite);
          break;
      }
    };
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageURLFocusNode.removeListener(_updateImageUrl);
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () => _saveForm(context), icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _initValues.title,
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: _onFieldSave(Product.TITLE),
                  ),
                  TextFormField(
                    initialValue: _initValues.price.toString(),
                    decoration: const InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please enter a number greater than zero';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: _onFieldSave(Product.PRICE),
                  ),
                  TextFormField(
                    initialValue: _initValues.description,
                    decoration: const InputDecoration(labelText: 'Desciption'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      if (value.length < 10) {
                        return 'Should be at least 10 characters long.';
                      }
                      return null;
                    },
                    onSaved: _onFieldSave(Product.DESCRIPTION),
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                          ? const Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: "Image URL"),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageURLFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a image URL';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please enter a valid IMAGE URL';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _saveForm(context),
                        onSaved: _onFieldSave(Product.IMAGE_URL),
                      ),
                    )
                  ])
                ],
              ),
            )),
      ),
    );
  }
}

class ProductFromValues {
  String title;
  String description;
  double price;
  String imageUrl;

  ProductFromValues(
      {this.description = '',
      this.imageUrl = '',
      this.price = 0.0,
      this.title = ''});
}
