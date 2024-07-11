import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:slitem/core/store.dart';
import 'package:slitem/models/cart.dart';
import 'package:slitem/pages/CheckoutPage.dart';
import 'package:velocity_x/velocity_x.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
      ),
      backgroundColor: context.canvasColor,
      body: Column(
        children: [
          Text(
            'Cart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.theme.accentColor,
            ),
            textScaleFactor: 2,
          ),
          _CartListState().p16().expand(),
          Divider(),
          _CartTotal(),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              child: Text('Checkout'),
              onPressed: () {
                final CartModel? _cart = (VxState.store as MyStore).cart;
                final totalAmount = _cart?.totalPrice ?? 0;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CheckoutPage(totalAmount: totalAmount),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  final _paymentItems = <PaymentItem>[];

  @override
  Widget build(BuildContext context) {
    final CartModel? _cart = (VxState.store as MyStore).cart;
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          VxBuilder(
            builder: (context, dynamic store, _) {
              _paymentItems.add(
                PaymentItem(
                  amount: _cart!.totalPrice.toString(),
                  label: 'Total',
                  status: PaymentItemStatus.final_price,
                ),
              );
              return '\LKR${_cart.totalPrice}'
                  .text
                  .xl5
                  .color(context.accentColor)
                  .make();
            },
            mutations: {RemoveMutation},
          ),
          30.widthBox,
          Row(
            children: [
              ApplePayButton(
                paymentConfigurationAsset: 'assets/applepay.json',
                paymentItems: _paymentItems,
                width: 200,
                height: 50,
                style: ApplePayButtonStyle.black,
                type: ApplePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (data) {
                  print(data);
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartListState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [RemoveMutation]);
    final CartModel _cart = (VxState.store as MyStore).cart!;
    return _cart.items.isEmpty
        ? 'Nothing to show'.text.xl3.makeCentered()
        : ListView.builder(
            itemCount: _cart.items?.length,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.done),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () => RemoveMutation(_cart.items[index]),
              ),
              title: _cart.items[index].name!.text.make(),
            ),
          );
  }
}
