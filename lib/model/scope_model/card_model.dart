import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterlojavirtual/model/product_cart.dart';
import 'package:flutterlojavirtual/model/scope_model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  List<ProductCart> products = [];

  static CartModel of(BuildContext context)=>ScopedModel.of<CartModel>(context);
  CartModel(this.user);

  void addCartItem(ProductCart product){
    products.add(product);

    Firestore.instance.collection('users').document(user.firebaseUserUid).collection('cart').add(product.toMap()).then((document){
      product.cid = document.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(ProductCart product){
    Firestore.instance.collection('users').document(user.firebaseUserUid).collection('cart').document(product.cid).delete();

    products.remove(product);

    notifyListeners();
  }
}