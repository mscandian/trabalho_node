import 'package:flutter/material.dart';
import 'package:node_jwt_auth/productdetail_page.dart';
import 'package:validate/validate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

AlertDialog getAlertDialog(title, content, context) {
  return AlertDialog(
    title: Text("Login failed"),
    content: Text('${content}'),
    actions: <Widget>[
      FlatButton(
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
/*
  void addData (Map<String, dynamic> responseMap) {
    this.id = responseMap["id"];
    this.descricao = responseMap["descricao"];
    this.valor = responseMap["valor"];
    this.marca = responseMap["marca"];
    this.thumbnail = responseMap["thumbnail"];
  }
*/
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
    final url = 'http://localhost:5000/seguranca/login';
    await http.post(Uri.parse(url), body: {'login': userData.login, 'senha': (userData.senha)})
    .then((response) {
      Map<String, dynamic> responseMap = json.decode(response.body);
      if(response.statusCode == 200) {
        userData.addData(responseMap);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProdutosPage(userData)),
        );
      }
      else {
        if(responseMap.containsKey("message"))
          showDialog(context: context, builder: (BuildContext context) =>
            getAlertDialog("Login failed", '${responseMap["message"]}', context));
      }
    }).catchError((err) {
      showDialog(context: context, builder: (BuildContext context) =>
        getAlertDialog("Login failed", '${err.toString()}', context));
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
                keyboardType: TextInputType.emailAddress, // Use email input type for emails.
                decoration: const InputDecoration(hintText: 'Informe seu login', labelText: 'Login'),
                onSaved: (String value) { this.userData.login = value; }
              ),
              TextFormField(
                obscureText: true, // To display typed char with *
                decoration: const InputDecoration(
                  hintText: 'Informe sua senha',
                  labelText: 'Senha'
                ),
                onSaved: (String value) { this.userData.senha = value; }
              ),
              Container(
                width: screenSize.width,
                child: RaisedButton(
                  child: Text('Login', style: TextStyle(color: Colors.white),),
                  onPressed: this.submit,
                  color: Colors.blue,
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

class ProdutosPage extends StatefulWidget {
  UserData userData;
  ProdutosPage(@required this.userData);
  @override
  State<StatefulWidget> createState() =>  _ProdutosPageState(userData);
}

class _ProdutosPageState extends State<ProdutosPage> {
  UserData userData;
  final ScrollController scrollController = ScrollController();
  Map<String, String> headers = Map();
  var dataList = <dynamic>[];
  List<ProdutosData> produtos;
  _ProdutosPageState(this.userData);

  @override
  void initState() {
    headers["Content-Type"] = 'application/json;charset=UTF-8';
    headers["Charset"] = 'utf-8';
    headers["Authorization"] = 'Bearer ${userData.token}';
    // headers["x-access-token"] = '${userData.username}';
    super.initState();
    this.getServerData();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: Text("Produtos"), backgroundColor: Colors.blue),
      body: 
        GridView.builder(
          padding: const EdgeInsets.only(top: 5.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
          ),
          controller: scrollController,
          itemCount: produtos == null ? 0 : produtos.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductDetail(produtos[index])),
          );
        },
        child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            color: Colors.white,
            elevation: 5.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image.network(produtos[index].thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 30,
                  child: Center(
                    child: Text(
                      produtos[index].descricao,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                )
              ],
            )
            )
            );
          }
        )
   );
  }

  Future<List<ProdutosData>> getServerData() async {
    final url = 'http://localhost:5000/api/produtos';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${userData.token}',
    }).then((response) {
      if(response.statusCode == 200) {
        List<dynamic> dataList = jsonDecode(response.body);
        print(dataList);
        produtos = dataList.map<ProdutosData>((dynamic item) => ProdutosData.fromJson(item)).toList();
        print(produtos[0].descricao);
      }
    });
}
}
//    .then((response) {
//      List responseMap = json.decode(response.body);
//      print("Body: "+ response.body);
//      if(response.statusCode == 200) {
//        print("deu bom");
//      }
//      else {
//        if(responseMap.containsKey("message"))
//          throw(Exception('${responseMap["message"]}'));
//        else
//          throw(Exception('error while server fetch'));
//      }
//    })
//    .timeout(Duration(seconds:40),onTimeout: () {
//      throw(new TimeoutException("fetch from server timed out"));
//    })
//    .catchError((err) {
//      throw(err);
//    });
//    return responseMap["descricao"];
//  }
 