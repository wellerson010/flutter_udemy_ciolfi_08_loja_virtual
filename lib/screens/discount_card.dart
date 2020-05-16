import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/model/scope_model/card_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        title: Text('Cupom de Desconto', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[500]),),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu cupom'
              ),
              initialValue: CartModel.of(context).couponCode ?? '',
              onFieldSubmitted: (text){
                Firestore.instance.collection('coupons').document(text).get().then((document){
                  if (document.data != null){
                    CartModel.of(context).setCoupom(text, document.data['percent']);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Desconto de ${document.data['percent']}% aplicado'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  }
                  else {
                    CartModel.of(context).setCoupom(null, 0);

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Cupom não existente'),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
