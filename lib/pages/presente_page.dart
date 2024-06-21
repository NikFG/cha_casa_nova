import 'package:cha_casa_nova/pages/my_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/constants.dart';

class PresentePage extends StatelessWidget {
  const PresentePage({
    super.key,
    required this.idProduto,
    required this.descricaoProduto,
    this.pix,
  });

  final String idProduto;
  final String descricaoProduto;
  final String? pix;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final mensagemController = TextEditingController();
    // importar planilha para csv
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: Constants.primaryColor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Constants.secondaryColor),
                ),
                child: Column(
                  children: const [
                    Text(
                      "Parabéns!",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      "Você concluiu a sua compra",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            pix != null
                ? Center(
                    child: Column(
                      children: [
                        QrImageView(
                          data: pix!,
                          size: 200,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: SelectableText(
                            pix!,
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Forum",
                            ),
                            maxLines: null,
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            Clipboard.setData(ClipboardData(text: pix!)).then(
                                (value) => ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                        SnackBar(content: Text("Pix copiado"))))
                          },
                          icon: Icon(Icons.copy),
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  )
                : SizedBox(
                    width: 0,
                    height: 0,
                  ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      "Muito obrigado por contribuir com a nossa nova casa!",
                      style: TextStyle(fontSize: 25, fontFamily: "Forum"),
                    ),
                    FutureBuilder(
                      future: db
                          .collection("horario")
                          .doc("irgHtBu9UDpmgCfK0kwE")
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox(
                            width: 0,
                            height: 0,
                          );
                        }
                        return Text(
                          "Esperamos você no dia ${snapshot.data?["data"]} às ${snapshot.data?["hora"]} horas para festejar conosco!",
                          style: TextStyle(fontSize: 25, fontFamily: "Forum"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      "Deixe uma mensagem abaixo para Laís e Nikollas:",
                      style: TextStyle(fontSize: 25, fontFamily: "Forum"),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width - 60,
                      child: TextField(
                        controller: mensagemController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Escreva aqui",
                          contentPadding: EdgeInsets.all(20),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        db
                            .collection("produtos")
                            .doc(idProduto)
                            .update({"comprado": true});
                        db.collection("mensagem").doc(idProduto).set({
                          "mensagem": mensagemController.text,
                          "produto": descricaoProduto
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ));
                      },
                      child: Text("Enviar",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
