import 'package:flutter/material.dart';
import 'package:flutterlojavirtual/model/scope_model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Criar Conta'),
        centerTitle: true
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, userModel){
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
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: 'Nome completo'
                  ),
                  validator: (text){
                    if (text.isEmpty){
                      return 'Nome inválido';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'E-mail'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text){
                    if (text.isEmpty || !text.contains('@')){
                      return 'E-mail inválido';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                      hintText: 'Senha'
                  ),
                  obscureText: true,
                  validator: (text){
                    if (text.isEmpty || text.length < 6){
                      return 'Senha inválida';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                      hintText: 'Endereço'
                  ),
                  validator: (text){
                    if (text.isEmpty){
                      return 'Endereço inválido';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16,),
                Builder(
                  builder: (context){
                    return SizedBox(
                      height: 44,
                      child: RaisedButton(
                        child: Text('Criar conta',
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          if (_formKey.currentState.validate()){
                            userModel.signUp(
                                email: _emailController.text,
                                password: _passController.text,
                                address: _addressController.text,
                                name: _nameController.text,
                                onSuccess: (){
                                  _onSuccess(context);
                                },
                                onFail: (){
                                  _onFail(context);
                                }
                            );
                          }
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      )
    );
  }

  void _onSuccess(BuildContext context){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Usuário criado com sucesso!'),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));

    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFail(BuildContext context){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Usuário não criado!'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}

