import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:node_jwt_auth/products_page.dart';
import 'globals.dart' as globals;

class AddItem extends StatefulWidget {

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  String token;

  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

 @override
  void initState() {
    super.initState();
    token = globals.token.toString();
  }

  void _submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      _adicionar();
    }
  }  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onBackPressed,
    child: Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Cadastro de Produto"),
      ),
      body: 
        Container(
          padding: EdgeInsets.all(20.0),
            child: 
              Form(
                key: this._formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _descricaoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descrição', floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo descrição é obrigatório';
                        }
                        return null;
                      },                
                      onSaved: (text) {
                        _descricaoController.text = text;
                      }
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _marcaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Marca', floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo marca é obrigatório';
                        }
                        return null;
                      },                
                      onSaved: (text) {
                        _marcaController.text = text;
                      }
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _valorController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Valor', floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo valor é obrigatório';
                        }
                        return null;
                      },                
                      onSaved: (text) {
                        _valorController.text = text;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _thumbnailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Imagem', floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onSaved: (text) {
                        _thumbnailController.text = text;
                      }
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => _submit(),
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              primary: Colors.blueAccent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0)
                                )
                              ),
                              minimumSize: Size(100, 40)
                            ),
                            child: const Text(
                              'Adicionar',
                              style: TextStyle(fontSize: 18),
                            ),                                    
                          )
                        ]
                      )
                    ), 
                  ], 
                )
              ),
            ),
        )      
      );
  }

  Future<void> _adicionar() async {
    final url = 'http://localhost:5000/api/produtos/';
    await http.post(Uri.parse(url), headers: {
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
      if (response.statusCode == 201) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blue,
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Produto cadastrado com sucesso!',
              style: TextStyle(fontSize: 14),
            ),
          ),
          duration: Duration(seconds: 2),
        )        
       );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
          backgroundColor: Colors.blue,
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Erro ao cacdastrar com sucesso!',
              style: TextStyle(fontSize: 14),
            ),
          ),
          duration: Duration(seconds: 2),
        )        
       );        
      }
      setState(() {});    
    }
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.push( 
      context,
      MaterialPageRoute(builder: (context) => ProdutosPage(globals.userData)),
    );
  }

}