import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  String address;
  String name;

  bool isLoading = false;

  void signUp({ @required String email, @required String name, @required String password, @required String address, @required VoidCallback onSuccess, @required VoidCallback onFail} ){
    isLoading = true;
    notifyListeners();
    
    _auth.createUserWithEmailAndPassword(email: email, password: password).then((user) async{
      _user = user.user;
      isLoading = false;
      await _saveUserData(address, name);

      onSuccess();

      notifyListeners();
    }).catchError((error){
      _user = null;
      isLoading = false;
      onFail();

      print(error);

      notifyListeners();
    });
  }

  void signIn() async{
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  bool get isLoggedIn{
    return _user != null;
  }

  Future<Null> _saveUserData(String address, String name) async{
    address = address;
    await Firestore.instance.collection('users').document(_user.uid).setData({
      address: address,
      name: name
    });
  }

  void signOut() async{
    await _auth.signOut();

    _user = null;
    name = '';
    address = '';

    notifyListeners();
  }
}