import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:node_jwt_auth/login_page.dart';
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

  TextEditingController descricaoController = TextEditingController();
  TextEditingController marcaController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController thumbnailController = TextEditingController();

@override
  void initState() {
    super.initState();
    produto = widget.produto;
    roles = globals.roles.toString();
    token = globals.token.toString();
    if (roles.contains('ADMIN')) {
      isAdmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Image.network(produto.thumbnail, width: 100, height: 150, fit: BoxFit.cover)
                      ],
                    )])),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Row(
                      children: <Widget>[
          Expanded(child: Container( 
            child: Column(
              children: <Widget>[
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: descricaoController,
            enabled: isAdmin,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Descrição', floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: produto.descricao,
            ),
          )
          ),
           Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TextFormField(
            controller: marcaController,
            enabled: isAdmin,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Marca', floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: produto.marca,
            ),
          )
          ),
           Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TextFormField(
            controller: valorController,
            enabled: isAdmin,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Valor', floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onSaved: (text) {
              valorController.text = text;
            },
          )
          ),
           Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TextFormField(
            controller: thumbnailController,
            enabled: isAdmin,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Imagem', floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: produto.thumbnail,
            ),
          )
          ),
              ]
            ))),
                      ]
                      )
                      ]
                      )
                      ),            
  Center(
  child:  Row(
    mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: isAdmin ? () => editar() : null,
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
                    child: Text(
                      'Alterar',
                      style: TextStyle(fontSize: 18),
                    ),            
                ),
                 SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isAdmin ? () => apagar() : null,
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
                    child: Text(
                      'Apagar',
                      style: TextStyle(fontSize: 18),
                    ),                        
                )
              ]
            )
          )
]
                      ));
              
  }

  Future<void> editar() async {
    final url = 'http://localhost:5000/api/produtos/${produto.id}';
    await http.put(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${token}'},
      body: jsonEncode(<String, dynamic>{
        'descricao': descricaoController.text.toString(),
        'marca': marcaController.text.toString(),
        'valor': valorController.text.toString(),
        'thumbnail': thumbnailController.text.toString()
      })
    )
    .then((response) {
      print(valorController.text.toString());
      if (response.statusCode == 200) {
       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.blue,
                          content: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Registro alterado com sucesso!',
                              style: TextStyle(fontSize: 14),
                              ),
                            ),
                              duration: Duration(seconds: 2),
                        )        
       );}     
    });
  }

  Future<void> apagar() async {
    final url = 'http://localhost:5000/api/produtos/${produto.id}';
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
                            child: Text('Registro removido com sucesso!',
                              style: TextStyle(fontSize: 14),
                              ),
                            ),
                              duration: Duration(seconds: 2),
                        )
        );}      
  });
  }

  @override
void dispose() {
  // other dispose methods
  descricaoController.dispose();
  marcaController.dispose();
  valorController.dispose();
  thumbnailController.dispose();
  super.dispose();
}
}