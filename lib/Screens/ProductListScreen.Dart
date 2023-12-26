import 'package:flutter/material.dart';
import '../Services/networkservice.dart' as networkService;
import '../Screens/ProductAddScreen.Dart';
import '../Screens/ProductEditScreen.Dart';
import '../Models/Product.dart';
import '../Screens/ProductDetailScreen.Dart';

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
              leading: SizedBox(
                width: 50,
                height: 50,
                child: Image.network(
                  'http://localhost:9090/public/images/produit/${products[index].image}',
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(products[index].name),
              subtitle: Text('Price: \$${products[index].price.toStringAsFixed(2)}'),
              onTap: () {
                navigateToProductDetailScreen(products[index]);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      navigateToEditScreen(products[index]);
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

  void navigateToProductDetailScreen(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
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
      fetchProducts();
    });
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await networkService.ProductService.deleteProduct(productId);
      fetchProducts();
    } catch (e) {
      print('Error: $e');
    }
  }
}
