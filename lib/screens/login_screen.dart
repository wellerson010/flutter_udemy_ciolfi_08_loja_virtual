import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/model/scope_model/user_model.dart';
import 'package:flutterlojavirtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      key: _scaffoldKey,
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
          if (userModel.isLoading) {
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
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.isEmpty || !text.contains('@')) {
                      return 'E-mail inválido';
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                // InputField(icon: Icons.add, hint: 'aa', obscure: false),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: 'Senha'),
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty || text.length < 6) {
                      return 'Senha inválida';
                    }

                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Insira seu e-mail para recuperação'),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ));
                        return;
                      }

                      userModel.recoverPass(_emailController.text);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Veja seu e-mail'),
                        backgroundColor: Theme.of(context).primaryColor,
                        duration: Duration(seconds: 2),
                      ));
                      return;
                    },
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
                      if (_formKey.currentState.validate()) {
                        userModel.signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail);
                      }
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

  void _onSuccess() {
    Navigator.of(_context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Login não permitido!'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;

  InputField({this.icon, this.hint, this.obscure});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.deepPurple,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.deepPurple),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple)),
      ),
      style: TextStyle(color: Colors.deepPurple),
      obscureText: obscure,
    );
  }
}
