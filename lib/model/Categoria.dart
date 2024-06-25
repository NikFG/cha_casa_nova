import 'package:cloud_firestore/cloud_firestore.dart';

import 'Produto.dart';

class Categoria {
  late String id;
  late List<Produto> produtos;

  Categoria();

  Categoria.fromJson(QueryDocumentSnapshot json, this.produtos) {
    id = json.id;
  }
}
