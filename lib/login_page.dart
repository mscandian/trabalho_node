import 'package:flutter/material.dart';
import 'package:node_jwt_auth/products_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as globals;

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

AlertDialog getAlertDialog(title, content, context) {
  return AlertDialog(
    title: Text("Login failed"),
    content: Text('${content}'),
    actions: <Widget>[
      TextButton(
        child: Text('Close'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

class _LoginData {
  String login = '';
  String senha = '';
}

class UserData extends _LoginData {
  String token = '';
  String nome = '';
  String email = '';
  String roles = '';
  int id;

  void addData (Map<String, dynamic> responseMap) {
    this.id = responseMap["id"];
    this.nome = responseMap["nome"];
    this.token = responseMap["token"];
    this.email = responseMap["email"];
    this.login = responseMap["login"];
    this.roles = responseMap["roles"];
  }
}

class ProdutosData {
  int id;
  String descricao = '';
  String valor = '';
  String marca = '';
  String thumbnail = '';

  ProdutosData({
    this.id,
    this.descricao,
    this.valor,
    this.marca,
    this.thumbnail
  });

  ProdutosData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    valor = json['valor'];
    marca = json['marca'];
    thumbnail = json['thumbnail'];
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['valor'] = this.valor;
    data['marca'] = this.marca;
    data['thumbnail'] = this.thumbnail;
  }

  void addData (Map<String, dynamic> responseMap) {
    this.id = responseMap["id"];
    this.descricao = responseMap["descricao"];
    this.valor = responseMap["valor"];
    this.marca = responseMap["marca"];
    this.thumbnail = responseMap["thumbnail"];
  }

}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserData userData = UserData();

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      login();
    }
  }

  void login() async {
    final url = 'https://trabalhofinal01.herokuapp.com/seguranca/login';
    await http.post(Uri.parse(url), body: {'login': userData.login, 'senha': (userData.senha)})
    .then((response) {
      Map<String, dynamic> responseMap = json.decode(response.body);
      if(response.statusCode == 200) {
        userData.addData(responseMap);
        globals.roles = userData.roles;
        globals.token = userData.token;
        globals.userData = userData;
        Navigator.push( 
          context,
          MaterialPageRoute(builder: (context) => ProdutosPage(userData)),
        );
      }
      else {
        if(responseMap.containsKey("message")) {
          showDialog(context: context, builder: (BuildContext context) =>
            getAlertDialog("Falha no login", '${responseMap["message"]}', context));
        }
      }
    }).catchError((err) {
      showDialog(context: context, builder: (BuildContext context) =>
        getAlertDialog("Falha no login", '${err.toString()}', context));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Login'),),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: this._formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress, 
                decoration: const InputDecoration(
                  hintText: 'Informe seu login', 
                  labelText: 'Login'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo login é obrigatório';
                  }
                  return null;
                },                
                onSaved: (String value) { this.userData.login = value; }
              ),
              TextFormField(
                obscureText: true, 
                decoration: const InputDecoration(
                  hintText: 'Informe sua senha',
                  labelText: 'Senha'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo senha é obrigatório';
                  }
                  return null;
                },                
                onSaved: (String value) { this.userData.senha = value; }
              ),
              Container(
                width: screenSize.width,
                child: ElevatedButton(
                  child: Text('Login', style: TextStyle(color: Colors.white),),
                  onPressed: this.submit,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        )
      ),
    );
  }
}