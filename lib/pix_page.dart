import 'package:flutter/material.dart';
import 'package:pix_flutter/pix_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PixPage extends StatefulWidget {
  const PixPage(
      {super.key, required double this.preco, required String this.descricao});

  final double preco;

  final String descricao;

  @override
  State<PixPage> createState() => _PixPageState();
}

class _PixPageState extends State<PixPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  bool mostraQrCode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: ListView(
            children: [
              mostraQrCode
                  ? Center(
                      child: QrImageView(
                      data: _geraQrCodePix(),
                      size: 200,
                    ))
                  : TextFormField(
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
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      mostraQrCode = true;
                    });
                  },
                  child: Text("Ok"))
            ],
          )),
    );
  }

  String _geraQrCodePix() {
    PixFlutter pixFlutter = PixFlutter(
        payload: Payload(
            pixKey: '+5537998456938',
            merchantName:
            'NikollasFerreiraGoncal',
            merchantCity: 'Brasilia',
            amount: widget.preco.toStringAsFixed(2)));

    String qrCode = pixFlutter.getQRCode();
    print(qrCode);
    return qrCode;
    // return "00020126360014br.gov.bcb.pix0114+553799845693852040000530398654040.015802BR5922NikollasFerreiraGoncal6008Brasilia620063049596";
  }
}
