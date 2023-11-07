import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController cepController = TextEditingController();
  String info_endereco = '';

  _recuperarCep() async {
    String url = 'https://viacep.com.br/ws/${cepController.text}/json/';

    print(url);

    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> retorno = json.decode(response.body);
    String logradouro = retorno["logradouro"];
    String bairro = retorno["bairro"];
    String localidade = retorno["localidade"];
    String uf = retorno["uf"];
    String cep = cepController.text;

    setState(() {
      info_endereco =
          ' CEP: $cep \n Logradouro: $logradouro \n Bairro: $bairro \n Cidade: $localidade \n Estado: $uf';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consulta de CEP"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Digite o CEP",
                      labelStyle: TextStyle(color: Colors.black87),
                    ),
                    controller: cepController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                      child: Text(
                        'Obter endereço',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: _recuperarCep),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                info_endereco,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
