import 'package:cha_casa_nova/my_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'Produto.dart';

class AddProduto extends StatefulWidget {
  const AddProduto({super.key, required this.title});

  final String title;

  @override
  State<AddProduto> createState() => _AddProdutoState();
}

class _AddProdutoState extends State<AddProduto> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _imagemController = TextEditingController();
  final _linkController = TextEditingController();

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
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(title: 'Chá de casa nova NikolLaís'),
                    ),
                  );
                },
              ),
            ]),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                // the username input field
                decoration: const InputDecoration(
                  hintText: 'Nome',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'nome is required';
                  }
                  return null;
                },
                controller: _nomeController,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Preço',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'preço is required';
                  }
                  return null;
                },
                controller: _precoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                // the username input field
                decoration: const InputDecoration(
                  hintText: 'Imagem',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'imagem is required';
                  }
                  return null;
                },
                controller: _imagemController,
              ),
              const SizedBox(height: 20),
              TextFormField(
                // the username input field
                decoration: const InputDecoration(
                  hintText: 'Link',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'link is required';
                  }
                  return null;
                },
                controller: _linkController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Produto produto = Produto();
                    produto.id = const Uuid().v1();
                    produto.nome = _nomeController.text;
                    produto.imagem = _imagemController.text;
                    produto.link = _linkController.text;
                    produto.preco = double.parse(_precoController.text);
                    produto.comprado = false;
                    _add(produto);
                  }
                },
                child: const Text("Add"),
              )
            ],
          ),
        ));
  }

  void _add(Produto produto) {
    db.collection("produtos").doc(produto.id).set(produto.toJSon());
  }
}
