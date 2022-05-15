import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:node_jwt_auth/login_page.dart';
import 'package:node_jwt_auth/productdetail_page.dart';
import 'package:node_jwt_auth/products_list.dart';

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
            return ListaProdutos(result: produtos[index]);
  }));
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
        produtos = dataList.map<ProdutosData>((dynamic item) => ProdutosData.fromJson(item)).toList();
      }
    });
}
}