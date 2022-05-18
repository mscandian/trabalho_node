import 'package:flutter/material.dart';
import 'package:node_jwt_auth/login_page.dart';
import 'package:node_jwt_auth/productdetail_page.dart';

class ListaProdutos extends StatelessWidget {
  ListaProdutos({this.result});

  final ProdutosData result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetail(result)),
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
              child: (result.thumbnail != null && result.thumbnail.isNotEmpty) ? Image(
                image: NetworkImage((result.thumbnail))) : Image(image: AssetImage('images/image_not_found.png'),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 30,
              child: Center(
                child: Text(
                  result.descricao,
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
}