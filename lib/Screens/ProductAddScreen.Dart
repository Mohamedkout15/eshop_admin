import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/networkservice.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  File? _pickedImage;

  Future<void> _pickImage() async {
    final pickedImageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: _pickedImage != null
                      ? Image.file(
                          _pickedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Icon(Icons.add_a_photo),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  String productName = nameController.text;
                  if (productName.length >= 5) {
                    Map<String, dynamic> productData = {
                      'name': productName,
                      'description': descriptionController.text,
                      'price': double.parse(priceController.text),
                      'quantity': int.parse(quantityController.text),
                      'category': categoryController.text,
                      'image': _pickedImage?.path ?? '', 
                    };

                    ProductService.addProduct(productData)
                      .then((_) {
                        ProductService.fetchProducts(); 
                        Navigator.pop(context); 
                      })
                      .catchError((error) {
                        print('Error adding product: $error');
                      });
                  } else {
                    print('Product name should be at least 5 characters long.');
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
