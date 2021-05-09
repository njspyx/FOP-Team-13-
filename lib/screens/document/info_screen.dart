import "dart:io";
import "package:http/http.dart" as http;
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:fop_team_13/document.dart';

class InfoScreen extends StatefulWidget {
  InfoScreen({Key key, this.isNew, this.document}) : super(key: key);
  bool isNew;
  Document document;

  void saveDocument() {
    document.ocrText = _ocrController.text;
    document.summaryText = _summaryController.text;
    document.keywords = _keywordsController.text.split(",");
  }

  TextEditingController _ocrController;
  TextEditingController _keywordsController;
  TextEditingController _summaryController;

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.isNew) {
      getOcrText(widget.document.image).then((String result) {
        this.setState(() {
          widget._ocrController = new TextEditingController(text: result);
        });
      });
    } else {
      widget._ocrController =
          new TextEditingController(text: widget.document.ocrText);
    }

    widget._keywordsController =
        new TextEditingController(text: widget.document.keywords.join(","));
    widget._summaryController =
        new TextEditingController(text: widget.document.summaryText);
  }

  Future<String> getOcrText(File img) async {
    var dio = Dio();
    const url = "http://10.0.2.2:5000/ocr";
    try {
      FormData data = new FormData.fromMap({
        "image": await MultipartFile.fromFile(img.path),
      });
      Response response = await dio.post(url, data: data);

      return response.data["text"].toString();
    } catch (error) {
      print("ERROR: " + error.toString());
    }
  }

  Future<Map> getSummaryText(
      String text, int numSentences, String keywords, bool isBullets) async {
    var dio = Dio();
    const url = "http://10.0.2.2:5000/summarize";
    try {
      FormData data = new FormData.fromMap({
        "text": text,
        "num_sentences": numSentences,
        "keywords": keywords,
        "bullets": isBullets.toString(),
      });
      Response response = await dio.post(url, data: data);

      return response.data;
    } catch (error) {
      print("ERROR: " + error.toString());
    }
  }

  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: ListView(
      children: [
        Image.file(widget.document.image, width: 500, height: 500),
        TextField(
          maxLines: 7,
          controller: widget._ocrController,
        ),
        CheckboxListTile(
          value: widget.document.isBulleted,
          title: Text("Bulleted"),
          onChanged: (newValue) {
            this.setState(() {
              widget.document.isBulleted = newValue;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        TextFormField(
          decoration: InputDecoration(hintText: "Keywords"),
          controller: widget._keywordsController,
        ),
        ElevatedButton(
          child: Text("Summarize!"),
          onPressed: () {
            this.setState(() {
              getSummaryText(
                      widget._ocrController.text,
                      3,
                      widget._keywordsController.text,
                      widget.document.isBulleted)
                  .then((Map result) {
                widget._summaryController.text = result["text"];
                widget.document.topWords = result["top_words"].split(" ");
              });
            });
          },
        ),
        TextField(
          maxLines: 7,
          controller: widget._summaryController,
        ),
      ],
    )));
  }
}
