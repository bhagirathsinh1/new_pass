import 'dart:io';

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pass/src/widgets/full_screen_image_view.dart';
import 'package:pass/themeData.dart';

class DrawerlistTileWidget extends StatefulWidget {
  DrawerlistTileWidget({
    Key? key,
    required this.index,
    required this.fileName,
    required this.function,
    required this.isLoading,
    required this.filePath,
  }) : super(key: key);
  final int index;
  final String fileName;
  final Function function;
  final bool isLoading;
  final String filePath;

  @override
  _DrawerlistTileWidgetState createState() => _DrawerlistTileWidgetState();
}

class _DrawerlistTileWidgetState extends State<DrawerlistTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        decoration: new BoxDecoration(
          border: Border.all(color: ThemeClass.orangeColor, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.fileName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ThemeClass.greyColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              widget.isLoading
                  ? SizedBox()
                  : IconButton(
                      padding: EdgeInsets.only(left: 10),
                      constraints: BoxConstraints(),
                      onPressed: () async {
                        if (widget.fileName.split(".").last.toLowerCase() ==
                            "pdf") {
                          // File file = File(widget.filePath);
                          // PDFDocument document =
                          //     await PDFDocument.fromFile(file);
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         FullScreenPdfView(path: document)
                          //         ,
                          //   ),
                          // );
                        } else if (widget.fileName
                                    .split(".")
                                    .last
                                    .toLowerCase() ==
                                "png" ||
                            widget.fileName.split(".").last.toLowerCase() ==
                                "jpg" ||
                            widget.fileName.split(".").last.toLowerCase() ==
                                "jpeg") {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenImageView(path: widget.filePath),
                            ),
                          );
                        }

                        // widget.function(widget.index);
                      },
                      icon: Icon(
                        Icons.remove_red_eye_sharp,
                      ),
                      color: ThemeClass.greyColor,
                    ),
              widget.isLoading
                  ? Container(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: ThemeClass.orangeColor,
                          ),
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        widget.function(widget.index);
                      },
                      icon: Icon(
                        Icons.cancel,
                      ),
                      color: ThemeClass.orangeColor,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
