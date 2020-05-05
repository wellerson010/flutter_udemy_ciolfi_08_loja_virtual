import 'package:cloud_firestore/cloud_firestore.dart';

class ProductItem {
  String id;
  String title;
  String description;
  double price;
  List<String> images;
  List<String> sizes;
  String categoryId;

  ProductItem.fromDocument(DocumentSnapshot document){
    id = document.data['id'];
    title = document.data['title'];
    description = document.data['description'];
    price = document.data['price'];
    images = (document.data['images'] as List<dynamic>).cast<String>().toList();
    sizes = (document.data['sizes'] as List<dynamic>).cast<String>().toList();
  }
}