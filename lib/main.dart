import "dart:io";

import 'package:flutter/material.dart';
import 'package:fop_team_13/document.dart';
import 'package:fop_team_13/widgets/fab_animated.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_tag_editor/tag_editor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Sprint 2 Demo'),
    );
  }
}

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
        keywords: []);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DocumentScreen(
                isNew: true,
                document: newDoc,
              )),
    );
    setState(() {
      if (result.name != null) docList.add(result);
    });
  }

  void _openCamera(BuildContext context) async {
    var result = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(result.path);
    });
    print("test");
    _navigateScreen(context, imageFile);
  }

  void _openGallery(BuildContext context) async {
    var result = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(result.path);
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
          itemBuilder: (BuildContext conttext, i) {
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

// ignore: must_be_immutable
class DocumentScreen extends StatefulWidget {
  DocumentScreen({Key key, this.isNew, this.document}) : super(key: key);
  bool isNew;
  Document document;

  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  TextEditingController _ocrController;
  TextEditingController _keywordsController;
  TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    if (widget.isNew) {
      _ocrController = new TextEditingController(text: widget.document.ocrText);
      _keywordsController =
          new TextEditingController(text: widget.document.keywords.join(","));
      _summaryController =
          new TextEditingController(text: widget.document.summaryText);
    } else {
      _ocrController = new TextEditingController(text: widget.document.ocrText);
      _keywordsController =
          new TextEditingController(text: widget.document.keywords.join(","));
      _summaryController =
          new TextEditingController(text: widget.document.summaryText);
    }
  }

  void _saveAndClose() {
    widget.document.ocrText = _ocrController.text;
    widget.document.summaryText = _summaryController.text;
    widget.document.keywords = _keywordsController.text.split(",");

    Navigator.pop(context, widget.document);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Container(
            child: Center(
                child: ListView(
          children: [
            Image.file(widget.document.image, width: 500, height: 500),
            TextField(
              maxLines: 8,
              controller: _ocrController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Keywords"),
              controller: _keywordsController,
            ),
            ElevatedButton(
              child: Text("Summarize!"),
              onPressed: () {
                _summaryController.text = "SUMMARY TEXT";
              },
            ),
            TextField(
              maxLines: 8,
              controller: _summaryController,
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: _saveAndClose,
            ),
          ],
        ))));
  }
}
