import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/model/scope_model/user_model.dart';
import 'package:flutterlojavirtual/screens/login_screen.dart';

class OrdersScreen extends StatelessWidget {
  String _buildProductText(DocumentSnapshot snapshot){
    String text = 'Descrição: \n';

    for(var item in snapshot.data['products']){
      text += '${item['quantity']} x ${item['product']['title']} (R\$ ${item['product']['price'].toStringAsFixed(2)}) \n';
    }

    text += 'Total: R\$ ${snapshot.data['price'].toStringAsFixed(2)}';

    return text;
  }

  Widget _orderTile(String orderId){
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('orders').document(orderId).snapshots(),
          builder: (context, snapshot){
            if (!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Código do pedido: ${snapshot.data.documentID}', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 4,
                ),
                Text(
                  _buildProductText(snapshot.data)
                )
              ],
            );

          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn) {
  String uid = UserModel.of(context).firebaseUserUid;

  return FutureBuilder<QuerySnapshot>(
    future: Firestore.instance.collection('users').document(uid).collection('orders').getDocuments(),
    builder: (context, snapshot){
      if (!snapshot.hasData){
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return ListView(
        children: snapshot.data.documents.map((item) => _orderTile(item.documentID)).toList(),
      );
    },
  );
    }
    else {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list, size: 80, color: Theme
                .of(context)
                .primaryColor,),
            SizedBox(height: 16,),
            Text('Faça o login para acompanhar!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,),
            RaisedButton(
              child: Text('Entrar', style: TextStyle(fontSize: 18),),
              textColor: Colors.white,
              color: Theme
                  .of(context)
                  .primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ),
      );
    }
  }
}
