import 'package:cloud_firestore/cloud_firestore.dart';

import 'product_item.dart';

class ProductCart {
  String pid;
  String cid;
  String category;

  int quantity;
  String size;

  ProductItem item;

  ProductCart();

  ProductCart.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data['category'];
    pid = document.data['pid'];
    quantity = document.data['quantity'];
    size = document.data['size'];
  }

  Map<String, dynamic> toMap(){
    return {
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
  //    'product': item.toResumedMap()
    };
  }
}