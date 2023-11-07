import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(FilmeApp());

class FilmeApp extends StatelessWidget {
  Future<List<Map<String, dynamic>>?> fetchFilmes() async {
    final response = await http
        .get(Uri.parse('https://sujeitoprogramador.com/r-api/?api=filmes'));

    if (response.statusCode == 200) {
      final List<dynamic> filmesJson = json.decode(response.body);
      return filmesJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Falha ao carregar filmes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('App Lista de Filmes'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>?>(
          future: fetchFilmes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final filmes = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: filmes.length,
                  itemBuilder: (context, index) {
                    final filme = filmes[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Image.network(
                          filme['foto'] as String,
                          width: 100.0, // Largura da imagem
                          height: 150.0, // Altura da imagem
                        ),
                        title: Text(
                          filme['nome'] as String,
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FilmeDetalhes(
                                  nome: filme['nome'] as String,
                                  sinopse: filme['sinopse'] as String,
                                  foto: filme['foto'] as String,
                                ),
                              ),
                            );
                          },
                          child: Text('Ler mais'),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Text('Nenhum dado encontrado.');
            }
          },
        ),
      ),
      debugShowCheckedModeBanner: false, // Desativa o banner de depuração
    );
  }
}

class FilmeDetalhes extends StatelessWidget {
  final String nome;
  final String sinopse;
  final String foto;

  FilmeDetalhes({
    required this.nome,
    required this.sinopse,
    required this.foto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nome),
      ),
      body: Column(
        children: [
          Image.network(foto),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(sinopse),
          ),
        ],
      ),
    );
  }
}