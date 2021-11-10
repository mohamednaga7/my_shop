import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _togglingFavorite = false;

  Future<void> _toggleFavorite(BuildContext context, Product product) async {
    setState(() {
      _togglingFavorite = true;
    });
    try {
      await product.toggleFavorite();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error adding to favorite')));
    } finally {
      setState(() {
        _togglingFavorite = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: ProductDetailScreenRouteArguments(
                      productId: product.id!));
            },
            child: Image.network(product.imageUrl)),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: _togglingFavorite
              ? const Center(
                  child: FittedBox(
                    child: CircularProgressIndicator(),
                  ),
                )
              : IconButton(
                  icon: Consumer<Product>(builder: (ctx, product, child) {
                    return Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).colorScheme.secondary,
                    );
                  }),
                  onPressed: () => _toggleFavorite(context, product),
                ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              cart.addItem(product: product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Added item to cart!'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    cart.removeSingleItem(product.id!);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
