import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:node_jwt_auth/login_page.dart';
import 'package:node_jwt_auth/products_page.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  ProdutosData produto;

  ProductDetail(this.produto);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  ProdutosData produto;
  bool isAdmin = false;
  String roles;
  String token;

  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    produto = widget.produto;
    roles = globals.roles.toString();
    token = globals.token.toString();
    if (roles.contains('ADMIN')) {
      isAdmin = true;
    }
    _descricaoController.text = produto.descricao;
    _marcaController.text = produto.marca;
    _valorController.text = produto.valor;
    _thumbnailController.text = produto.thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onBackPressed,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Detalhe"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 130, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      (produto.thumbnail != null && produto.thumbnail.isNotEmpty) ?
                      Image.network(produto.thumbnail, width: 100, height: 150, fit: BoxFit.cover) :
                      Image(image: AssetImage('images/image_not_found.png'), width: 100, height: 150, fit: BoxFit.cover)
                    ],
                  )
                ]
              )
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: 
                        Container( 
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: _descricaoController,
                                  enabled: isAdmin,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Descrição', floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                  onSaved: (text) {
                                    _descricaoController.text = text;
                                  }
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: TextFormField(
                                  controller: _marcaController,
                                  enabled: isAdmin,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Marca', floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                  onSaved: (text) {
                                    _marcaController.text = text;
                                  }
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: TextFormField(
                                  controller: _valorController,
                                  enabled: isAdmin,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Valor', floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                  onSaved: (text) {
                                    _valorController.text = text;
                                  },
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: TextFormField(
                                  controller: _thumbnailController,
                                  enabled: isAdmin,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Imagem', floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                  onSaved: (text) {
                                    _thumbnailController.text = text;
                                  },
                                )
                              ),
                            ]
                          )
                        )
                      ),
                    ]
                  )
                ]
              )
            ),            
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: isAdmin ? () => _editar() : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: Colors.blueAccent,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                            BorderRadius.all(
                            Radius.circular(12.0)
                          )
                        ),
                        minimumSize: Size(100, 40)
                      ),
                      child: const Text(
                        'Alterar',
                        style: TextStyle(fontSize: 18),
                      ),            
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: isAdmin ? () => _apagar() : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: Colors.blueAccent,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                            BorderRadius.all(
                              Radius.circular(12.0)
                            )
                        ),
                        minimumSize: Size(100, 40)
                      ),
                      child: const Text(
                        'Apagar',
                        style: TextStyle(fontSize: 18),
                      ),                        
                    )
                  ]
                )
              )
            ]
          ),
        )
      );        
  }

  Future<bool> _onBackPressed() async {
    Navigator.push( 
      context,
      MaterialPageRoute(builder: (context) => ProdutosPage(globals.userData)),
    );
  }

  Future<void> _editar() async {
    final url = 'https://trabalhofinal01.herokuapp.com/api/produtos/${produto.id}';
    await http.put(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${token}'},
      body: jsonEncode(<String, dynamic>{
        'descricao': _descricaoController.text.toString(),
        'marca': _marcaController.text.toString(),
        'valor': _valorController.text.toString(),
        'thumbnail': _thumbnailController.text.toString()
      })
    )
    .then((response) {
      if (response.statusCode == 200) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blue,
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Registro alterado com sucesso!',
              style: TextStyle(fontSize: 14),
            ),
          ),
          duration: Duration(seconds: 2),
        )        
       );
      }     
    }
    );
  }

  Future<void> _apagar() async {
    final url = 'https://trabalhofinal01.herokuapp.com/api/produtos/${produto.id}';
    await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${token}'})
    .then((response) {    
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blue,
            content: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Registro removido com sucesso!',
                style: TextStyle(fontSize: 14),
              ),
            ),
            duration: Duration(seconds: 2),
          )
        );
      }      
    }
    );
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _marcaController.dispose();
    _valorController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }
}