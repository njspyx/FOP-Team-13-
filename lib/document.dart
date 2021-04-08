import 'dart:io';

import 'package:flutter/material.dart';

class Document {
  String name;
  File image;
  String ocrText;
  List<String> keywords;
  String summaryText;

  Document({
    @required this.name,
    this.image,
    @required this.ocrText,
    @required this.keywords,
    @required this.summaryText,
  });
}
