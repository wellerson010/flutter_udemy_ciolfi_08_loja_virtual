import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/model/scope_model/user_model.dart';
import 'package:flutterlojavirtual/screens/login_screen.dart';

class OrdersScreen extends StatelessWidget {
  Widget _buildCircle(String title, String subtitle, int status, int thisStatus){
    Color backColor;
    Widget child;

    if (status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    }
    else if (status == thisStatus){
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    }
    else {
      backColor = Colors.green;
      child = Icon(Icons.check);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }

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

            int status = snapshot.data['status'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Código do pedido: ${snapshot.data.documentID}', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 4,
                ),
                Text(
                  _buildProductText(snapshot.data)
                ),
                SizedBox(height: 4,),
                Text('Status do pedido', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildCircle('1', 'Preparação', status, 1),
                    Container(
                        height: 1,
                        width: 40,
                        color: Colors.grey[500]
                    ),
                    _buildCircle('2', 'Transporte', status, 2),
                    Container(
                        height: 1,
                        width: 40,
                        color: Colors.grey[500]
                    ),
                    _buildCircle('3', 'Entrega', status, 3),
                  ],
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
        children: snapshot.data.documents.map((item) => _orderTile(item.documentID)).toList().reversed.toList(),
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
