import 'package:cha_casa_nova/pix_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Produto.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.produto,
    required this.width,
  });

  final Produto produto;
  final double width;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 219, 161, 145).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              widget.produto.imagem,
              width: 250,
              height: 250,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.produto.nome,
            style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 112, 89, 83)
            ),
            maxLines: 2,
          ),
          Text(
            formatNumber(widget.produto.preco),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 219, 161, 145),
            ),
          )
        ],
      ),
    );
  }

  String formatNumber(double number) {
    var formatter = NumberFormat.decimalPattern("pt_BR");
    return "R\$${formatter.format(number)}";
  }
}
