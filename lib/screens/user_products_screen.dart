import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> getDataFromDB(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: getDataFromDB(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => getDataFromDB(context),
                child: Consumer<Products>(builder: (ctx, productsData, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: productsData.items.isEmpty
                        ? Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "NO PRODUCTS FOUND",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            EditProductScreen.routeName);
                                      },
                                      child: const Text('Add Product'))
                                ]),
                          )
                        : ListView.builder(
                            itemBuilder: (_, index) => Column(
                              children: [
                                UserProductItem(
                                    product: productsData.items[index]),
                                const Divider()
                              ],
                            ),
                            itemCount: productsData.items.length,
                          ),
                  );
                }),
              ),
      ),
    );
  }
}
