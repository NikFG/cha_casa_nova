import 'package:flutter/material.dart';
import 'package:pix_flutter/pix_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PixPage extends StatefulWidget {
  const PixPage({super.key, required this.preco, required this.descricao});

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
                  child: const Text("Ok"))
            ],
          )),
    );
  }

  String _geraQrCodePix() {
    PixFlutter pixFlutter = PixFlutter(
        payload: Payload(
      pixKey: '5faa8df4-7404-4e89-9622-64cbe0478623',
      merchantName: 'NikollasFerreiraGoncal',
      merchantCity: 'Brasilia',
      amount: widget.preco.toStringAsFixed(2),
    ));

    String qrCode = pixFlutter.getQRCode();
    return qrCode;
  }
}
