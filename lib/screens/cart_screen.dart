import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.headline6 !=
                                        null
                                    ? Theme.of(context)
                                        .primaryTextTheme
                                        .headline6!
                                        .color
                                    : Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                        onPressed: () {
                          Provider.of<Orders>(context, listen: false).addOrder(
                              cart.items.values.toList(), cart.totalAmount);
                          cart.clear();
                        },
                        child: Text(
                          'ORDER NOW',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (_, index) =>
                  CartItemWidget(cartItem: cart.items.values.toList()[index]),
              itemCount: cart.items.length,
            ))
          ],
        ));
  }
}
