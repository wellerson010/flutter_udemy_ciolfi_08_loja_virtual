import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'product_item_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(
          snapshot.data['icon']
        ),
      ),
      title: Text(
        snapshot.data['title']
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=>ProductItemScreen(snapshot)
        ));
      },
    );
  }
}

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('products').orderBy('title').getDocuments(),
      builder: (context, snapshot){
        if (!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        }
        else {
          var divideTilers = ListTile.divideTiles(tiles: snapshot.data.documents.map((doc) => CategoryTile(doc)).toList(), color: Colors.grey[500]).toList();
          return ListView(
            children: divideTilers,
          );
        }
      },
    );
  }
}