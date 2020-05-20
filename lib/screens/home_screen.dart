import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/screens/cart_button.dart';
import 'package:flutterlojavirtual/screens/orders_screen.dart';
import 'package:flutterlojavirtual/screens/place_screen.dart';

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
        Scaffold(
          appBar: AppBar(
            title: Text('Lojas'),
            centerTitle: true,
          ),
          body: PlaceScreen(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Meus pedidos'),
            centerTitle: true,
          ),
          body: OrdersScreen(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
  }
}