import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textController = TextEditingController();
  int github_id = 0;
  String github_nome = '';
  int github_repos = 0;
  int github_followers = 0;
  int github_following = 0;
  String github_created = '';
  String github_avatar =
      'https://th.bing.com/th/id/OIP.eTCbdR_AFzbqHMPXhrJWUQHaEK?pid=ImgDet&rs=1';

  _getUserData() async {
    String url = 'https://api.github.com/users/${textController.text}';

    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> retorno = json.decode(response.body);
    print(retorno);

    await _getUserRepos();
    await _getUserFollowers();
    await _getUserFollowing();

    setState(() {
      github_id = retorno['id'];
      github_nome = retorno['name'];
      github_created = retorno["created_at"];
      github_avatar = retorno["avatar_url"];
    });
  }

  _getUserRepos() async {
    String url = 'https://api.github.com/users/${textController.text}/repos';
    http.Response response = await http.get(Uri.parse(url));
    List<dynamic> retorno = json.decode(response.body);
    print(retorno);
    setState(() {
      github_repos = retorno.length;
    });
  }

  _getUserFollowers() async {
    String url =
        'https://api.github.com/users/${textController.text}/followers';
    http.Response response = await http.get(Uri.parse(url));
    List<dynamic> retorno = json.decode(response.body);
    print(retorno);
    setState(() {
      github_followers = retorno.length;
    });
  }

  _getUserFollowing() async {
    String url =
        'https://api.github.com/users/${textController.text}/following';
    http.Response response = await http.get(Uri.parse(url));
    List<dynamic> retorno = json.decode(response.body);
    print(retorno);
    setState(() {
      github_following = retorno.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil dos Devs"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Digite o login do github",
                      labelStyle: TextStyle(color: Colors.black87),
                    ),
                    controller: textController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                      child: Text(
                        'Encontrar DEV',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: _getUserData),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "ID: $github_id",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Text(
                          "Nome: $github_nome",
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Repositórios: $github_repos",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Criado em: $github_created",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Seguidores: $github_followers",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Seguindo: $github_following",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(github_avatar),
                      radius: 50,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}