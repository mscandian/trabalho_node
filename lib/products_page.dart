import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:node_jwt_auth/additem_page.dart';
import 'package:node_jwt_auth/login_page.dart';
import 'package:node_jwt_auth/products_list.dart';

class ProdutosPage extends StatefulWidget {
  UserData userData;
  ProdutosPage(@required this.userData);
  @override
  State<StatefulWidget> createState() =>  _ProdutosPageState(userData);
}

class _ProdutosPageState extends State<ProdutosPage> {
  UserData userData;
  ProdutosData produto;
  final ScrollController scrollController = ScrollController();
  final _searchTextController = TextEditingController();
  Map<String, String> headers = Map();
  var dataList = <dynamic>[];
  List<ProdutosData> produtos;
  _ProdutosPageState(this.userData);
  bool isAdmin = false;

  @override
  void initState() {
    headers["Content-Type"] = 'application/json;charset=UTF-8';
    headers["Charset"] = 'utf-8';
    headers["Authorization"] = 'Bearer ${userData.token}';
    _getServerData();
    if (userData.roles.contains('ADMIN')) {
      isAdmin = true;
    }    
    // headers["x-access-token"] = '${userData.username}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: Text("Produtos"), backgroundColor: Colors.blue),
      body: 
        Container( 
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.black26,
                          decoration: InputDecoration(
                            labelText: 'Procurar',
                            labelStyle: TextStyle(color: Colors.black26),
                            hintText: 'Procurar pelo ID',
                            hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                              borderRadius: BorderRadius.all(Radius.circular(25.0))
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(25.0))
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              borderSide: BorderSide(color: Colors.grey)
                            ),
                            fillColor: Colors.grey.withOpacity(0.5),
                            prefixIcon: IconButton(
                              icon: Icon(Icons.search, color: Colors.grey),
                              onPressed: () { _search(); }
                            )
                          ),
                          onSubmitted: (text) {
                            _search();
                          },
                          controller: _searchTextController,
                        ),
                      ),
                    ],
                  )),
                  Expanded(child:    
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
                      }
                    ))])),
                    floatingActionButton: FloatingActionButton(
                      onPressed:  isAdmin? () => _addItem() : null,
                      tooltip: 'Adicionar Produto',
                      child: const Icon(Icons.add)
                    )
          );
  }

  Future<void> _addItem() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItem()),
    );    
  }

  Future<ProdutosData> _search() async {
    _getServerData();
}

  Future<List<ProdutosData>> _getServerData() async {
    if (_searchTextController.text == null || _searchTextController.text == '') {
    final url = 'http://localhost:5000/api/produtos';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${userData.token}',
    }).then((response) {
      if(response.statusCode == 200) {
        List<dynamic> dataList = jsonDecode(response.body);
        produtos = dataList.map<ProdutosData>((dynamic item) => ProdutosData.fromJson(item)).toList();
        setState(() {});
      }
    });
  } else {
    final url = 'http://localhost:5000/api/produtos/${_searchTextController.text}';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${userData.token}',
    }).then((response) {
      Map<String, dynamic> resp = json.decode(response.body);
      produtos.clear();
      produtos.add(ProdutosData.fromJson(resp)) as Map<String, dynamic>;
      setState(() {});
    });
  }
  }
}