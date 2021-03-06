import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/model/scope_model/user_model.dart';
import 'package:flutterlojavirtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 203, 236, 241),
            Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text('Loja\nVirtual', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, userModel){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Olá, ${userModel.isLoggedIn ? userModel.name:''}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              GestureDetector(
                                child: Text(userModel.isLoggedIn ? 'Sair': 'Entre ou cadastre-se', style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                )),
                                onTap: (){
                                  if (userModel.isLoggedIn){
                                    userModel.signOut();
                                  }
                                  else {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => LoginScreen()
                                    ));
                                  }

                                },
                              )
                            ],
                          );
                        },
                      )
                    )
                  ],
                )
              ),
              Divider(),
              DrawerTile(Icons.home, 'Início', pageController, 0),
              DrawerTile(Icons.list, 'Produtos', pageController, 1),
              DrawerTile(Icons.location_on, 'Lojas', pageController, 2),
              DrawerTile(Icons.playlist_add_check, 'Meus Pedidos', pageController, 3),

            ],
          )
        ],
      )
    );
  }
}