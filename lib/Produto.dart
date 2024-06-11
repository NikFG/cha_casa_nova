import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  late String id;
  late String nome;
  late double preco;
  late bool comprado;
  late String imagem;
  late String link;


  Produto();

  Produto.fromJson(QueryDocumentSnapshot json) {
    id = json.id;
    nome = json.get("nome");
    preco = json.get("preco");
    comprado = json.get("comprado");
    imagem = json.get("imagem");
    link = json.get("link");
  }

  Map<String, dynamic> toJSon() {
    return {
      "id": id,
      "nome": nome,
      "preco": preco,
      "comprado": comprado,
      "imagem": imagem,
      "link": link,
    };
  }
}
