import 'package:flutter/material.dart';

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
            onPressed: (){},
            child: Text('Criar conta',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white
            ),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: 'E-mail'
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (text){
                if (text.isEmpty || !text.contains('@')){
                  return 'E-mail inválido';
                }

                return '';
              },
            ),
            SizedBox(height: 16,),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Senha'
              ),
              obscureText: true,
              validator: (text){
                if (text.isEmpty || text.length < 6){
                  return 'Senha inválida';
                }

                return '';
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: (){},
                padding: EdgeInsets.zero,
                child: Text(
                  'Esqueci a minha senha',
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(height: 16,),
            SizedBox(
              height: 44,
              child: RaisedButton(
                child: Text('Entrar',
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: (){
                  if (_formKey.currentState.validate()){

                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}