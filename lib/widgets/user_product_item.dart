import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatefulWidget {
  final Product product;
  const UserProductItem({Key? key, required this.product}) : super(key: key);

  @override
  State<UserProductItem> createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  bool _isDeleting = false;

  Future<void> _deleteProduct() async {
    setState(() {
      _isDeleting = true;
    });
    try {
      await Provider.of<Products>(context, listen: false)
          .deleteProduct(widget.product.id!);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting ${widget.product.title}')));
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: widget.product.id);
              },
              color: Theme.of(context).primaryColor,
            ),
            _isDeleting
                ? const Center(
                    child: FittedBox(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteProduct,
                    color: Theme.of(context).errorColor,
                  ),
          ],
        ),
      ),
    );
  }
}
