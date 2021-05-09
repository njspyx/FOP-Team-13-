import 'dart:io';

import 'package:flutter/material.dart';

class Document {
  String name;
  File image;
  String ocrText;
  List<String> keywords;
  bool isBulleted;
  String summaryText;
  List<String> topWords;

  Document({
    @required this.name,
    this.image,
    @required this.ocrText,
    @required this.keywords,
    @required this.isBulleted,
    @required this.summaryText,
    @required this.topWords,
  });
}
