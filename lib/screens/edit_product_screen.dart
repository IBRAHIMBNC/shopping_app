import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  var _imageURlCon = TextEditingController();
  final imageURLFocus = FocusNode();
  final _editFormData = GlobalKey<FormState>();
  var _editProId = '';
  Product _newProd =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0.0);
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productsPro = Provider.of<Products>(context, listen: false);
      _editProId = ModalRoute.of(context)!.settings.arguments as String;
      _newProd = productsPro.findById(_editProId);
      print(_editProId);
      print("find by id done");
      _imageURlCon.text = _newProd.imageUrl;
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    imageURLFocus.addListener(updateImageUI);
    super.initState();
  }

  void updateImageUI() {
    if (!_imageURlCon.text.startsWith('http') &&
        !_imageURlCon.text.startsWith('https') &&
        !_imageURlCon.text.endsWith('png') &&
        !_imageURlCon.text.endsWith('jpg') &&
        !_imageURlCon.text.endsWith('jpeg')) return;
    if (!imageURLFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    imageURLFocus.removeListener(updateImageUI);
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    _imageURlCon.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    final bool formSub = _editFormData.currentState!.validate();
    if (!formSub) {
      return;
    }
    _editFormData.currentState!.save();
    if (_newProd.id == null)
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_newProd);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("An error accourd!"),
                content: Text("Something went Wrong!"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okey'))
                ],
              );
            });
      }
    else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProId, _newProd);
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
        title: Text('Edit product'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editFormData,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _newProd.id != null ? _newProd.title : "",
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).autofocus(priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter title';
                        return null;
                      },
                      onSaved: (value) {
                        _newProd = Product(
                            id: _newProd.id,
                            isFavourite: _newProd.isFavourite,
                            title: value!,
                            description: _newProd.description,
                            imageUrl: _newProd.imageUrl,
                            price: _newProd.price);
                      },
                    ),
                    TextFormField(
                      initialValue:
                          _newProd.id != null ? _newProd.price.toString() : "",
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).autofocus(descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter price';
                        if (double.tryParse(value) == null)
                          return 'Enter a valid value';
                        if (double.parse(value) <= 0)
                          return 'Price must be greater than zero';
                        return null;
                      },
                      onSaved: (value) {
                        _newProd = Product(
                            id: _newProd.id,
                            isFavourite: _newProd.isFavourite,
                            title: _newProd.title,
                            description: _newProd.description,
                            imageUrl: _newProd.imageUrl,
                            price: double.parse(value!));
                      },
                    ),
                    TextFormField(
                      initialValue:
                          _newProd.id != null ? _newProd.description : "",
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      focusNode: descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please enter Descrition';
                        else if (value.length < 20)
                          return 'Description must be atleast 20 characters';
                        return null;
                      },
                      onSaved: (value) {
                        _newProd = Product(
                            id: _newProd.id,
                            isFavourite: _newProd.isFavourite,
                            title: _newProd.title,
                            description: value!,
                            imageUrl: _newProd.imageUrl,
                            price: _newProd.price);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageURlCon.text.isEmpty
                                ? Text('Enter Image URL')
                                : Container(
                                    child: FittedBox(
                                      child: Image.network(
                                        _imageURlCon.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                controller: _imageURlCon,
                                focusNode: imageURLFocus,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return 'Please enter Image URl';
                                  else if (!value.startsWith('http') &&
                                      !value.startsWith('https'))
                                    return ' Please enter a valid image URl';
                                  else if (!value.endsWith(".jpg") &&
                                      !value.endsWith(".jpeg") &&
                                      !value.endsWith(".png"))
                                    return 'Please enter a valid image URl';
                                  return null;
                                },
                                onSaved: (value) {
                                  _newProd = Product(
                                      id: _newProd.id,
                                      isFavourite: _newProd.isFavourite,
                                      title: _newProd.title,
                                      description: _newProd.description,
                                      imageUrl: value!,
                                      price: _newProd.price);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
