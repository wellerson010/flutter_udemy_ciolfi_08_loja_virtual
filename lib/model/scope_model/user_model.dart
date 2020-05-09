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


  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

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

      print('error' + error.toString());

      notifyListeners();
    });
  }

  void signIn({@required String email, @required String password, @required VoidCallback onSuccess, @required VoidCallback onFail}) async{
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: password).then((user) async{
      _user = user.user;
      await _loadCurrentUser();

      onSuccess();
      isLoading = false;

      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  bool get isLoggedIn{
    return _user != null;
  }

  Future<Null> _saveUserData(String address, String name) async{
    this.address = address;
    this.name = name;

    print({
      address: address,
      name: name
    });

    await Firestore.instance.collection('users').document(_user.uid).setData({
      'address': address,
      'name': name
    });
  }

  void signOut() async{
    await _auth.signOut();

    _user = null;
    name = '';
    address = '';

    notifyListeners();
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _loadCurrentUser() async {
    if (_user == null){
      _user = await _auth.currentUser();
    }

    if (_user != null){
        DocumentSnapshot doc = await Firestore.instance.collection('users').document(_user.uid).get();
        Map<String, dynamic> data = doc.data;

        name = data['name'];
        address = data['address'];
        notifyListeners();
    }
  }


}