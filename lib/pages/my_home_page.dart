import 'dart:js' as js;

import 'package:cha_casa_nova/model/Categoria.dart';
import 'package:cha_casa_nova/model/Produto.dart';
import "package:cha_casa_nova/pages/home_page_mobile.dart";
import "package:cha_casa_nova/pages/home_page_pc.dart";
import 'package:cha_casa_nova/pages/presente_page.dart';
import 'package:cha_casa_nova/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pix_flutter/pix_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Categoria> categorias = [];

  @override
  void initState() {
    refresh();
    queryCategorias().snapshots().listen((event) {
      for (QueryDocumentSnapshot doc in event.docs) {
        queryProdutos(doc.id).snapshots().listen((event) {
          Categoria categoria = categorias.where((cat) {
            return cat.id == doc.id;
          }).first;
          setState(() {
            categoria.produtos =
                event.docs.map((prod) => Produto.fromJson(prod)).toList();
          });
        });
      }
    });
    // _convertCsv();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final bool isPc = size.width >= 1100;
    const String pix =
        "00020126360014br.gov.bcb.pix0114+55379984569385204000053039865802BR5924Nikollas Ferreira Goncal6008Brasilia62090505n5gai630446D9";
    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            )),
            child: isPc ? const HomePagePc() : const HomePageMobile(),
          ),
          Container(
            padding: EdgeInsets.only(top: 50),
            color: const Color.fromARGB(255, 255, 249, 242),
            child: Center(
              child: Text(
                "Sugestão\nde\nPresentes\n\nClique no produto para comprar",
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ..._getProdutos(size),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: const Color.fromARGB(255, 255, 249, 242),
            child: Column(
              children: [
                Text(
                  "Qualquer quantia pode nos ajudar e somos gratos pela sua presença!",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Caso seja de sua vontade, deixamos um pix abaixo.",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                QrImageView(
                  data: pix,
                  size: 200,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: SelectableText(
                    pix,
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Forum",
                    ),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  onPressed: () => {
                    Clipboard.setData(ClipboardData(text: pix)).then((value) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Pix copiado"))))
                  },
                  icon: Icon(Icons.copy),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  void refresh() async {
    QuerySnapshot query = await db.collection("categorias").get();
    for (var doc in query.docs) {
      QuerySnapshot productsSnapshot = await queryProdutos(doc.id).get();
      setState(() {
        List<Produto> produtos =
            productsSnapshot.docs.map((doc) => Produto.fromJson(doc)).toList();
        categorias.add(Categoria.fromJson(doc, produtos));
      });
    }
  }

  Query<Map<String, dynamic>> queryProdutos(String categoriaId) {
    return db
        .collection("categorias")
        .doc(categoriaId)
        .collection("produtos")
        .where('comprado', isEqualTo: false)
        .orderBy('preco', descending: true);
  }

  Query<Map<String, dynamic>> queryCategorias() {
    return db.collection("categorias");
  }

  String _geraQrCodePix(double preco, String idProduto) {
    PixFlutter pixFlutter = PixFlutter(
      payload: Payload(
        amount: preco.toStringAsFixed(2),
        pixKey: "+5537998456938",
        merchantCity: "Brasilia",
        txid: idProduto.split('-')[0],
        merchantName: "Nikollas",
      ),
    );
    return pixFlutter.getQRCode();
  }

  _convertCsv() async {
    var file = await DefaultAssetBundle.of(context).loadString(
      "assets/data.csv",
    );
    List<List<dynamic>> results =
        const CsvToListConverter().convert(file, fieldDelimiter: ";");
    for (var result in results) {
      await db
          .collection("categorias")
          .doc(result[0])
          .collection("produtos")
          .add({
        "nome": result[1],
        "comprado": false,
        "imagem": result[8],
        "link": result[7],
        "preco": result[2],
      });
    }
  }

  List<Widget> _getProdutos(Size size) {
    final double itemWidth = size.width / 2;
    List<Widget> widgetProduto = [];
    for (var categoria in categorias) {
      List<Produto> produtos = categoria.produtos;
      Widget gridList = Container(
        color: const Color.fromARGB(255, 255, 249, 242),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.2),
        child: ExpansionTile(
          title: Text("${categoria.id} (${categoria.produtos.length})"),
          initiallyExpanded: true,
          children: [
            ResponsiveGridList(
                shrinkWrap: true,
                desiredItemWidth: itemWidth > 600 ? 500 : 200,
                minSpacing: 50,
                physics: NeverScrollableScrollPhysics(),
                children: produtos
                    .map(
                      (Produto produto) => InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                    'Qual será a forma de presentear?'),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          js.context.callMethod(
                                              'open', [produto.link]);

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PresentePage(
                                                        idProduto: produto.id,
                                                        descricaoProduto:
                                                            produto.nome,
                                                        idCategoria:
                                                            categoria.id,
                                                      )));
                                        },
                                        child: const Text("Loja"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => PresentePage(
                                              pix: _geraQrCodePix(
                                                  produto.preco, produto.id),
                                              idProduto: produto.id,
                                              descricaoProduto: produto.nome,
                                              idCategoria: categoria.id,
                                            ),
                                          ));
                                        },
                                        child: const Text("Pix"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          child:
                              ProductCard(produto: produto, width: itemWidth)),
                    )
                    .toList())
          ],
        ),
      );
      widgetProduto.add(gridList);
    }
    return widgetProduto;
  }
}
