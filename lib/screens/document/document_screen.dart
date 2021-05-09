import "dart:io";
import 'package:fop_team_13/screens/document/info_screen.dart';
import 'package:fop_team_13/screens/document/relatedsource_screen.dart';
import "package:http/http.dart" as http;
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:fop_team_13/document.dart';

// ignore: must_be_immutable
class DocumentScreen extends StatefulWidget {
  DocumentScreen({Key key, this.isNew, this.document}) : super(key: key);
  bool isNew;
  Document document;

  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  InfoScreen _infoScreen;
  RelatedSourceScreen _relatedSourceScreen;

  @override
  void initState() {
    super.initState();
    _infoScreen =
        new InfoScreen(isNew: widget.isNew, document: widget.document);
    _relatedSourceScreen =
        new RelatedSourceScreen(topWords: widget.document.topWords);
  }

  _showMaterialDialog() {
    var _saveTitleController =
        new TextEditingController(text: widget.document.name);

    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Save Document"),
              content: new TextFormField(
                controller: _saveTitleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Save"),
                  onPressed: () {
                    this.setState(() {
                      widget.document.name = _saveTitleController.text == null
                          ? "New Document"
                          : _saveTitleController.text;
                    });
                    Navigator.of(context).pop();
                    _saveAndClose();
                  },
                ),
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  void _saveAndClose() {
    this._infoScreen.saveDocument();
    widget.document = this._infoScreen.document;

    Navigator.pop(context, widget.document);
  }

  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Container(
            child: Column(
          children: [
            Expanded(
                child: Container(
                    child: PageView(
              controller: controller,
              children: [this._infoScreen, this._relatedSourceScreen],
              onPageChanged: (i) {
                this._infoScreen.saveDocument();
                widget.document = this._infoScreen.document;
                this._relatedSourceScreen.topWords = widget.document.topWords;
                print(_relatedSourceScreen.topWords);
              },
            ))),
            ElevatedButton(
              child: Text("Save"),
              onPressed: _showMaterialDialog,
            )
          ],
        )));
  }
}
