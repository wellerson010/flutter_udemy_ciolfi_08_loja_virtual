import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterlojavirtual/model/product_cart.dart';
import 'package:flutterlojavirtual/model/scope_model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  bool isLoading = false;

  String couponCode;
  int discountPerc = 0;

  List<ProductCart> products = [];

  static CartModel of(BuildContext context)=>ScopedModel.of<CartModel>(context);
  CartModel(this.user){
    if (user.isLoggedIn){
      _loadCartItem();
    }
  }

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

  void decProduct(ProductCart product){
    product.quantity--;
    Firestore.instance.collection('users').document(user.firebaseUserUid).collection('cart').document(product.cid).updateData(product.toMap());

    notifyListeners();
  }

  void incProduct(ProductCart product){
    product.quantity++;
    Firestore.instance.collection('users').document(user.firebaseUserUid).collection('cart').document(product.cid).updateData(product.toMap());

    notifyListeners();
  }

  void _loadCartItem() async{
    QuerySnapshot query = await Firestore.instance.collection('users').document(user.firebaseUserUid).collection('cart').getDocuments();

    products = query.documents.map((doc) => ProductCart.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupom(String code, int discountPercentage){
    this.couponCode = code;
    this.discountPerc = discountPercentage;
  }

  void updatePrices(){
    notifyListeners();
  }

  Future<String> finishOrder() async {
    if (products.length > 0){
      isLoading = true;
      notifyListeners();

      double price = getProductsPrice();
      double desconto = getDiscount();
      double total = price - desconto;
      
      DocumentReference refOrder = await Firestore.instance.collection('orders').add({
        'clientId': user.firebaseUserUid,
        'products': products.map((item) => item.toMap()).toList(),
        'price': price,
        'discount': desconto,
        'total': total,
        'status': 1
      });
      
      await Firestore.instance.collection('users').document(user.firebaseUserUid).collection('orders').document(refOrder.documentID).setData({
        'orderId': refOrder.documentID
      });

      QuerySnapshot query = await Firestore.instance.collection('users').document(user.firebaseUserUid).collection('cart').getDocuments();

      for(DocumentSnapshot snapshot in query.documents){
        await snapshot.reference.delete();
      }

      products.clear();

      discountPerc = 0;
      couponCode = null;

      isLoading = false;

      notifyListeners();

      return refOrder.documentID;
    }

    return null;
  }

  double getProductsPrice(){
    double price = 0;

    for(ProductCart c in products){
      if (c.item != null){
        price += c.quantity * c.item.price;
      }
    }

    return price;
  }

  double getDiscount(){
    return getProductsPrice() * discountPerc / 100;
  }
}