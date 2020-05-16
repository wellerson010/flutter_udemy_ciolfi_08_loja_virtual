import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/product_item.dart';
import 'product_screen.dart';

class ProductItemScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  ProductItemScreen(this.snapshot);

  Widget _infoBottomTile(ProductItem product, BuildContext context){
    return  Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Text(product.title, style: TextStyle(
              fontWeight: FontWeight.w500
          )),
          Text('R\$${product.price.toStringAsFixed(2)}', style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.bold
          ),)
        ],
      ),
    );
  }

  Widget _buildProductTile(String type, ProductItem product, BuildContext context){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductScreen(product)
        ));
      },
      child: Card(
        child: type == 'grid'?Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.8,
              child: Image.network(
                product.images[0],
                fit: BoxFit.cover
              )
            ),
            Expanded(
              child: _infoBottomTile(product, context),
            )
          ],
        ):Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Image.network(
                  product.images[0],
                  fit: BoxFit.cover,
                height: 250
              ),
            ),
            Flexible(
              flex: 1,
              child:  _infoBottomTile(product, context),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data['title']),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on),),
              Tab(icon: Icon(Icons.list))
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection('products').document(snapshot.documentID).collection('items').getDocuments(),
          builder: (context, snapshot){
            if (!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator( ),
              );
            }
            return  TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
               GridView.builder(
                   padding: EdgeInsets.all(4),
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 2,
                     mainAxisSpacing: 4,
                     crossAxisSpacing: 4,
                     childAspectRatio: 0.65
                   ),
                   itemCount: snapshot.data.documents.length,
                   itemBuilder: (context, index) => _buildProductTile('grid', buildProductItem(snapshot.data.documents[index], this.snapshot.documentID), context)),
                ListView.builder(
                  itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) =>  _buildProductTile('list', buildProductItem(snapshot.data.documents[index], this.snapshot.documentID), context))
              ],
            );
          },
        )
      ),
    );
  }

  ProductItem buildProductItem(DocumentSnapshot snapshot, String categoryId){
    ProductItem item = ProductItem.fromDocument(snapshot);
    print('categoryid' + categoryId);

    item.categoryId = categoryId;

    return item;
  }
}