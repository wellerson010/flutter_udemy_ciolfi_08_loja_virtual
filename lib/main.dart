import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/model/scope_model/card_model.dart';
import 'package:flutterlojavirtual/model/scope_model/user_model.dart';
import 'package:flutterlojavirtual/screens/login_screen.dart';
import 'package:flutterlojavirtual/screens/main_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return ScopedModel<CartModel>(
          model: CartModel(model),
          child: MaterialApp(
            title: 'Loja Virtual',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 4, 125, 141)),
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          ),
        );
      }),
    );
  }
}
