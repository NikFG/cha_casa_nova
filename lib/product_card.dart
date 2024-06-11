import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Produto.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.produto,
    required this.width,
  }) : super(key: key);

  final Produto produto;
  final double width;

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
            produto.imagem,
            width: width,
            height: 250,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          produto.nome,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatNumber(produto.preco),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                db
                    .collection("produtos")
                    .doc(produto.id)
                    .update({"comprado": !produto.comprado});
              },
              padding: const EdgeInsets.all(2),
              icon: Icon(
                produto.comprado
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: Colors.red,
              ),
            ),
          ],
        )
      ],
    ),);
  }

  String formatNumber(double number) {
    var formatter = NumberFormat.decimalPattern("pt_BR");
    return "R\$${formatter.format(number)}";
  }
}
