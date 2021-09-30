import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class FullScreenPdfView extends StatefulWidget {
  const FullScreenPdfView({Key? key, required this.path}) : super(key: key);
  final PDFDocument path;

  @override
  _FullScreenPdfViewState createState() => _FullScreenPdfViewState();
}

class _FullScreenPdfViewState extends State<FullScreenPdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: PDFViewer(document: widget.path, zoomSteps: 1),
      ),
    );
  }
}

class FullScreenImageView extends StatefulWidget {
  const FullScreenImageView(
      {Key? key, required this.path, this.isFromNetwork = false})
      : super(key: key);
  final String path;
  final bool isFromNetwork;
  @override
  _FullScreenImageViewState createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.only(top: 0, bottom: 0),
          child: !widget.isFromNetwork
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(widget.path)),
                        fit: BoxFit.fitWidth),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: NetworkImage(widget.path), fit: BoxFit.fitWidth),
                  ),
                ),
        ),
      ),
    );
  }
}
