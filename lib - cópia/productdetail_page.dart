import 'package:flutter/material.dart';
import 'package:node_jwt_auth/login_page.dart';

class ProductDetail extends StatefulWidget {
  ProdutosData produto;

  ProductDetail(this.produto);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  ProdutosData produto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(produto.descricao),
      ),
    );
  }
}