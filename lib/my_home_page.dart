import 'package:cha_casa_nova/Produto.dart';
import 'package:cha_casa_nova/add_produto.dart';
import 'package:cha_casa_nova/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:js' as js;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static const PRODUTOS = "produtos";
  List<Produto> produtos = [];

  @override
  void initState() {
    refresh();
    db
        .collection(PRODUTOS)
        .orderBy('comprado')
        .orderBy('preco', descending: true)
        .snapshots()
        .listen((event) {
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
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.person),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
                itemCount: produtos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  Produto produto = produtos[index];
                  return InkWell(
                    onTap: () {
                      js.context.callMethod('open', [produto.link]);
                    },
                    child: ProductCard(produto: produto),
                  );
                }),
          ),
        ));
  }

  void refresh() async {
    QuerySnapshot query = await db
        .collection(PRODUTOS)
        .orderBy('comprado')
        .orderBy('preco', descending: true)
        .get();
    setState(() {
      produtos = query.docs.map((doc) {
        return Produto.fromJson(doc);
      }).toList();
    });
  }
}
