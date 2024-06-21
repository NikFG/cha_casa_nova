import 'dart:js' as js;

import 'package:cha_casa_nova/model/Produto.dart';
import "package:cha_casa_nova/pages/home_page_mobile.dart";
import "package:cha_casa_nova/pages/home_page_pc.dart";
import 'package:cha_casa_nova/pages/presente_page.dart';
import 'package:cha_casa_nova/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pix_flutter/pix_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Produto> produtos = [];

  @override
  void initState() {
    refresh();
    queryProdutos().snapshots().listen((event) {
      produtos = [];
      setState(() {
        for (QueryDocumentSnapshot doc in event.docs) {
          produtos.add(Produto.fromJson(doc));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double height = size.height / 2;
    final double itemWidth = size.width / 2;
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
          Container(
            color: const Color.fromARGB(255, 255, 249, 242),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.2),
              child: ResponsiveGridList(
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
                                              builder: (context) =>
                                                  PresentePage(
                                                      pix: _geraQrCodePix(
                                                          produto.preco,
                                                          produto.id),
                                                      idProduto: produto.id,
                                                      descricaoProduto:
                                                          produto.nome),
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
                            child: ProductCard(
                                produto: produto, width: itemWidth)),
                      )
                      .toList()),
            ),
          ),
        ],
      ),
    ));
  }

  void refresh() async {
    QuerySnapshot query = await queryProdutos().get();
    setState(() {
      produtos = query.docs.map((doc) {
        return Produto.fromJson(doc);
      }).toList();
    });
  }

  Query<Map<String, dynamic>> queryProdutos() {
    return db
        .collection("produtos")
        .where('comprado', isEqualTo: false)
        .orderBy('comprado')
        .orderBy('preco', descending: true);
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
}


