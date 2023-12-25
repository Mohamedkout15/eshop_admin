import 'package:flutter/material.dart';
import '../Services/networkservice.dart' as networkService;
import '../Screens/ProductAddScreen.Dart';
import '../Screens/ProductEditScreen.Dart';
import '../Models/Product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      List<dynamic> productListData =
          await networkService.ProductService.fetchProducts();

      List<Product> productsList = productListData
          .map((productData) => Product.fromJson(productData))
          .toList();

      setState(() {
        products = productsList;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              leading: Image.network(
                products[index].image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(products[index].name),
              subtitle:
                  Text('Price: ${products[index].price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      navigateToEditScreen(products[index]);
                      print(products[index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteProduct(products[index].id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToAddScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    );
    fetchProducts();
  }

void navigateToEditScreen(Product product) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductEditScreen(product: product),
    ),
  ).then((_) {
    fetchProducts(); // Refresh the product list after editing
  });
}

  Future<void> deleteProduct(String productId) async {
    try {
      await networkService.ProductService.deleteProduct(productId);
      fetchProducts();
    } catch (e) {
      print('Error: $e');
      // Add an empty body here:
    }
  }

}