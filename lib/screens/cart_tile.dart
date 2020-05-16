import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/model/product_cart.dart';
import 'package:flutterlojavirtual/model/product_item.dart';
import 'package:flutterlojavirtual/model/scope_model/card_model.dart';

class CartTile extends StatelessWidget {
  final ProductCart productCart;

  CartTile(this.productCart);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: productCart.item == null ?
          FutureBuilder<DocumentSnapshot>(
            future: Firestore.instance.collection('products').document(productCart.category).collection('items').document(productCart.pid).get(),
            builder: (context, snapshot){
              if (snapshot.hasData){
                productCart.item = ProductItem.fromDocument(snapshot.data);
                return _buildContent(context);
              }
              else {
                return Container(
                  height: 70,
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              }
            },
          ):_buildContent(context)
    );
  }

  Widget _buildContent(BuildContext context){
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          width: 120,
          child: Image.network(productCart.item.images[0], fit: BoxFit.cover),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(productCart.item.title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                Text('Tamanho: ${productCart.size}', style: TextStyle(fontWeight: FontWeight.w300),),
                Text('R\$ ${productCart.item.price.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: productCart.quantity > 1?(){
                        CartModel.of(context).decProduct(productCart);
                      }:null,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(productCart.quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: (){
                        CartModel.of(context).incProduct(productCart);
                      },
                    ),
                    FlatButton(
                      child: Text('Remover'),
                      textColor: Colors.grey[500],
                      onPressed: (){
                        CartModel.of(context).removeCartItem(productCart);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
