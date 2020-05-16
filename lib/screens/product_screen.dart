import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/model/product_cart.dart';
import 'package:flutterlojavirtual/model/scope_model/card_model.dart';
import 'package:flutterlojavirtual/model/scope_model/user_model.dart';
import 'package:flutterlojavirtual/screens/login_screen.dart';
import '../model/product_item.dart';

class ProductScreen extends StatefulWidget {
  final ProductItem product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductItem product;
  String _sizeSelected;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.9,
              child: Carousel(
                images: product.images.map((url) => NetworkImage(url)).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    maxLines: 3,
                  ),
                  Text(
                    'R\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 22,
                        color: primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Tamanho',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 36,
                    child: GridView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.5 //largura/altura
                          ),
                      children: product.sizes.map((item) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _sizeSelected = item;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                    color: (item == _sizeSelected)
                                        ? primaryColor
                                        : Colors.grey[500],
                                    width: 3)),
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(item),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      color: primaryColor,
                      textColor: Colors.white,
                      onPressed: (_sizeSelected != null)
                          ? () {
                              if (UserModel.of(context).isLoggedIn) {
                                ProductCart cartProduct = ProductCart();
                                cartProduct.size = _sizeSelected;
                                cartProduct.quantity = 1;
                                cartProduct.pid = product.id;
                                cartProduct.category = product.categoryId;

                                CartModel.of(context).addCartItem(cartProduct);
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              }
                            }
                          : null,
                      child: Text((UserModel.of(context).isLoggedIn)?'Adicionar ao carrinho':'Entre para comprar'),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Descrição',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
