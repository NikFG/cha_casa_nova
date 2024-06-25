import 'dart:js' as js;

import 'package:cha_casa_nova/model/Categoria.dart';
import 'package:cha_casa_nova/model/Produto.dart';
import "package:cha_casa_nova/pages/home_page_mobile.dart";
import "package:cha_casa_nova/pages/home_page_pc.dart";
import 'package:cha_casa_nova/pages/presente_page.dart';
import 'package:cha_casa_nova/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pix_flutter/pix_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Produto> produtos = [];
  List<Categoria> categorias = [];

  @override
  void initState() {
    refresh();
    /*queryProdutos().snapshots().listen((event) {
      produtos = [];
      setState(() {
        for (QueryDocumentSnapshot doc in event.docs) {
          produtos.add(Produto.fromJson(doc));
        }
      });
    });*/
    // _convertCsv();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;
    final double height = size.height / 2;
    final bool isPc = size.width >= 1100;
    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          Container(
            height: height,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            )),
            child: isPc ? const HomePagePc() : const HomePageMobile(),
          ),
          ..._getProdutos(size),
        ],
      ),
    ));
  }

  void refresh() async {
    try {
      QuerySnapshot query = await db.collection("categorias").get();
    print(query.docs);
      for (var doc in query.docs) {
        String idCategoria = doc.id;
        QuerySnapshot productsSnapshot = await db
            .collection('categorias')
            .doc(idCategoria)
            .collection('produtos')
            .get();
        List<Produto> produtos =
            productsSnapshot.docs.map((doc) => Produto.fromJson(doc)).toList();
        setState(() {
          categorias.add(Categoria.fromJson(doc, produtos));
        });
        print(categorias);
      }
    } catch (ex) {
      print(ex);
    }
  }

  Query<Map<String, dynamic>> queryProdutos(String categoriaId) {
    return db
        .collection("categorias")
        .doc(categoriaId)
        .collection("produtos")
        .where('comprado', isEqualTo: false)
        .orderBy('comprado')
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
    try {
      var file = await DefaultAssetBundle.of(context).loadString(
        "assets/data.csv",
      );
      List<List<dynamic>> results =
          const CsvToListConverter().convert(file, fieldDelimiter: ";");
      for (var result in results) {
        var uuid = Uuid();
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
    } catch (ex) {
      print(ex);
    }
    // result.forEach((r)=>{
    // db.collection("categoria").doc();
    // });
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
          title: Text(categoria.id),
          initiallyExpanded: true,
          children: [
            ResponsiveGridList(
                shrinkWrap: true,
                desiredItemWidth: itemWidth > 600 ? 500 : 200,
                minSpacing: 50,
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
                                                descricaoProduto: produto.nome),
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
