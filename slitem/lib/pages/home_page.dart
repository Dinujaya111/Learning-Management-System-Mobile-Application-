import 'dart:convert';
import 'package:slitem/core/store.dart';
import 'package:slitem/models/cart.dart';
import 'package:slitem/models/catelog.dart';
import 'package:slitem/utils/routes.dart';
import 'package:slitem/widgets/home_widgets/catelog_header.dart';
import 'package:slitem/widgets/home_widgets/catelog_list.dart';
import 'package:slitem/widgets/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String email;
  final String userid;

  const HomePage({Key? key, required this.email, required this.userid})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final url = 'API KEY HERE';

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    await Future.delayed(
      Duration(seconds: 1),
    );

    var items =
        await CatelogModel().getProducts(); // Call the getProducts() function
    setState(() {
      CatelogModel.items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _cart = (VxState.store as MyStore).cart;
    return Scaffold(
      backgroundColor: context.canvasColor,
      floatingActionButton: VxBuilder(
        mutations: {AddMutation, RemoveMutation},
        builder: (context, dynamic store, _) => FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, MyRoutes.cartRoute),
          backgroundColor: context.theme.buttonColor,
          child: Icon(
            CupertinoIcons.cart,
            color: Colors.white,
          ),
        ).badge(
            color: Colors.white,
            size: 22,
            count: _cart!.items.length,
            textStyle: TextStyle(
              color: Mytheme.darkBluishColor,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CatelogHeader(
                email: widget.email,
                userId: widget.userid,
              ),
              if (CatelogModel.items != null && CatelogModel.items!.isNotEmpty)
                CatelogList().py16().expand()
              else
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
