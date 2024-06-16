import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/Produto.dart';
import '../utils/constants.dart';

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
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Constants.secondaryColor.withOpacity(0.1),
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
            style: TextStyle(fontSize: 30, color: Constants.primaryColor),
            maxLines: 2,
          ),
          Text(
            formatNumber(widget.produto.preco),
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Constants.secondaryColor,
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
