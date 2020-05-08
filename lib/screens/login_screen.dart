import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/model/scope_model/user_model.dart';
import 'package:flutterlojavirtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: Text(
              'Criar conta',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, userModel) {
          if (userModel.isLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.isEmpty || !text.contains('@')) {
                      return 'E-mail inválido';
                    }

                    return '';
                  },
                ),
                SizedBox(
                  height: 16,
                ),
               // InputField(icon: Icons.add, hint: 'aa', obscure: false),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Senha'),
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty || text.length < 6) {
                      return 'Senha inválida';
                    }

                    return '';
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: Text(
                      'Esqueci a minha senha',
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    child: Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {}

                      userModel.signIn();
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class InputField extends StatelessWidget {

  final IconData icon;
  final String hint;
  final bool obscure;

  InputField({this.icon,this.hint,this.obscure});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          icon: Icon(icon, color: Colors.deepPurple,),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.deepPurple),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple)
          ),
      ),
      style: TextStyle(color: Colors.deepPurple),
      obscureText: obscure,
    );
  }
}
