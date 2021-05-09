import "dart:io";
import "package:http/http.dart" as http;
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class RelatedSourceScreen extends StatefulWidget {
  RelatedSourceScreen({Key key, this.topWords}) : super(key: key);
  List<String> topWords;

  @override
  _RelatedSourceScreen createState() => _RelatedSourceScreen();
}

class _RelatedSourceScreen extends State<RelatedSourceScreen> {
  List _articleList = [];

  TextEditingController _numArticlesController;

  @override
  void initState() {
    super.initState();
    _numArticlesController = new TextEditingController();
  }

  _updatearticleList() {
    getJstorInfo(widget.topWords, _numArticlesController.text)
        .then((List result) {
      setState(() {
        _articleList = result;
      });
    });
  }

  Future<List> getJstorInfo(List<String> wordList, String numArticles) async {
    var dio = Dio();
    const url = "http://10.0.2.2:5000/jstor";

    String wordStr = wordList.join(" ");
    try {
      FormData data = new FormData.fromMap({
        "words": wordStr,
        "num_articles": numArticles,
      });
      Response response = await dio.post(url, data: data);

      return response.data["articles"];
    } catch (error) {
      print("ERROR: " + error.toString());
    }
  }

  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      children: [
        Container(
            child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _numArticlesController,
                decoration: InputDecoration(hintText: '# Articles'),
              ),
            ),
            ElevatedButton(
                onPressed: _updatearticleList, child: Text("Search JSTOR"))
          ],
        )),
        Expanded(
            child: Container(
                child: ListView.builder(
                    itemCount: this._articleList.length,
                    itemBuilder: (BuildContext context, i) {
                      return Card(
                          child: ExpansionTile(
                              title: Text(this._articleList[i]["title"]),
                              children: [
                            Text(this._articleList[i]["abstract"]),
                            TextButton(
                                onPressed: () {}, child: Text("Explore")),
                          ]));
                    })))
      ],
    )));
  }
}
