import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/screens/cart_button.dart';

import 'main_screen.dart';
import 'custom_drawer.dart';
import 'products_screen.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: MainScreen(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Produtos'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsScreen(),
          floatingActionButton: CartButton(),
        ),
        Container(
            color: Colors.red
        ),
        Container(
            color: Colors.green
        )
      ],
    );
  }
}