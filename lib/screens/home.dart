import "dart:io";

import 'package:flutter/material.dart';
import 'package:fop_team_13/document.dart';
import 'package:fop_team_13/widgets/fab_animated.dart';
import 'package:image_picker/image_picker.dart';

import 'document/document_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Document> docList = [];
  File imageFile;

  void _navigateScreen(BuildContext context, img) async {
    Document newDoc = Document(
        name: "New Document",
        image: img,
        ocrText: "OCR Text",
        summaryText: "",
        isBulleted: false,
        keywords: [],
        topWords: []);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DocumentScreen(
                isNew: true,
                document: newDoc,
              )),
    );
    setState(() {
      if (result.name != null) this.docList.add(result);
    });
  }

  void _openCamera(BuildContext context) async {
    var result = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      this.imageFile = File(result.path);
    });
    print("test");
    _navigateScreen(context, imageFile);
  }

  void _openGallery(BuildContext context) async {
    var result = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      this.imageFile = File(result.path);
    });
    _navigateScreen(context, imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: docList.length,
          itemBuilder: (BuildContext context, i) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.note),
                title: Text(docList[i].name),
                trailing: Icon(Icons.more_vert),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DocumentScreen(
                              isNew: true,
                              document: docList[i],
                            )),
                  );
                  setState(() {
                    if (result.name != null) docList[i] = result;
                  });
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FabAnimated(
        uploadClicked: () {
          _openGallery(context);
        },
        cameraClicked: () {
          _openCamera(context);
        },
      ),
    );
  }
}
