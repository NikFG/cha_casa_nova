import "dart:io";
import 'dart:js' as js;

import 'package:cha_casa_nova/Produto.dart';
import "package:cha_casa_nova/home_page_mobile.dart";
import "package:cha_casa_nova/home_page_pc.dart";
import 'package:cha_casa_nova/pix_page.dart';
import 'package:cha_casa_nova/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          toolbarHeight: height,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            )),
            child: isPc ? HomePagePc() : HomePageMobile(),
          ),
        ),
        body: SafeArea(
          child: Container(
            color: Color.fromARGB(255,255, 249, 242),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.2),
              child: ResponsiveGridList(
                  desiredItemWidth: itemWidth > 600 ? 500 : 200,
                  minSpacing: 50,
                  children: produtos
                      .map(
                        (p) => InkWell(
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
                                          onPressed: () => js.context
                                              .callMethod('open', [p.link]),
                                          child: const Text("Loja"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) => PixPage(
                                                      preco: p.preco,
                                                      descricao: p.nome))),
                                          child: const Text("Pix"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: ProductCard(produto: p, width: itemWidth)),
                      )
                      .toList()),
            ),
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
        .orderBy('comprado')
        .orderBy('preco', descending: true);
  }
}
