import 'package:cha_casa_nova/pix_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pix_flutter/pix_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
    const kSecondaryColor = Color(0xFF979797);
    const kPrimaryColor = Color(0xFFFF7643);
    FirebaseFirestore db = FirebaseFirestore.instance;
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              widget.produto.imagem,
              width: widget.width,
              height: 250,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.produto.nome,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatNumber(widget.produto.preco),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PixPage(
                          preco: widget.produto.preco,
                          descricao: widget.produto.nome)));
                },
                padding: const EdgeInsets.all(2),
                icon: const Icon(Icons.shopping_cart),
              ),
              IconButton(
                onPressed: () async {
                  db
                      .collection("produtos")
                      .doc(widget.produto.id)
                      .update({"comprado": !widget.produto.comprado});
                },
                padding: const EdgeInsets.all(2),
                icon: Icon(
                  widget.produto.comprado
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: Colors.red,
                ),
              ),
            ],
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
