import 'package:cha_casa_nova/Produto.dart';
import 'package:cha_casa_nova/add_produto.dart';
import 'package:cha_casa_nova/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

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
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            toolbarHeight: height / 2,
            title: Text(widget.title),
            flexibleSpace: Image.network(
              'https://cdn.pixabay.com/photo/2016/07/07/16/46/dice-1502706_640.jpg',
              fit: BoxFit.fitWidth,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const AddProduto(title: 'Adicionar produto'),
                    ),
                  );
                },
              ),
            ]),
        body: SafeArea(
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
                            js.context.callMethod('open', [p.link]);
                          },
                          child: ProductCard(produto: p, width: itemWidth)),
                    )
                    .toList()),
          ),
          // child: GridView.builder(
          //     itemCount: produtos.length,
          //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //       maxCrossAxisExtent: itemWidth,
          //       crossAxisSpacing: 20,
          //       childAspectRatio: 0.7,
          //     ),
          //     itemBuilder: (context, index) {
          //       Produto produto = produtos[index];
          //       return InkWell(
          //         onTap: () {
          //           js.context.callMethod('open', [produto.link]);
          //         },
          //         child: ProductCard(produto: produto),
          //       );
          //     }),
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
