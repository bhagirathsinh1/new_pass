import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';

import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/drawer_list_tile.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';

import 'package:pass/themeData.dart';

class UploadDocumentDialog extends StatefulWidget {
  final BuildContext ctx;
  const UploadDocumentDialog({
    Key? key,
    required this.ctx,
    required this.files,
    required this.setImageInList,
    required this.removeImageInList,
    required this.addLoadingList,
    required this.removeLoadingList,
    required this.loadingList,
    required this.editLoadingList,
  }) : super(key: key);

  final FilePickerResult? files;
  final Function setImageInList;

  final Function removeImageInList;
  final Function addLoadingList;
  final Function removeLoadingList;
  final Function editLoadingList;

  final List loadingList;

  @override
  _UploadDocumentDialogState createState() => _UploadDocumentDialogState();
}

class _UploadDocumentDialogState extends State<UploadDocumentDialog> {
  bool isUploading = false;
  FilePickerResult? files;
  final List<String> allowExtension = ["png", "jpeg", "jpg", "pdf"];
  @override
  void initState() {
    super.initState();
    files = widget.files;
  }

  // List loadingList = [];

  _pickfile() async {
    files = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: allowExtension,
    );
    if (files != null) {
      for (int i = 0; i < files!.files.length; i++) {
        widget.addLoadingList(true);
        setState(() {});
        try {
          // String imageulr =
          //     await HttpConfig().httpuploadFile(files!.files[i], "document");
          String imageulr = await HttpConfig()
              .uploadFileToFirestore(files!.files[i].path.toString());
          if (imageulr != "false") {
            widget.setImageInList(imageulr);
          } else {
            showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
          }
        } catch (e) {
          showSnackbarMessageGlobal(e.toString(), context);
        }
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            widget.editLoadingList(i, false);
          });
        });
      }
    }

    setState(() {});
  }

  _pickfile1() async {
    FilePickerResult? tfiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: allowExtension,
    );

    if (tfiles != null) {
      for (int i = 0; i < tfiles.files.length; i++) {
        int a = widget.loadingList.length;

        widget.addLoadingList(true);
        setState(() {});

        try {
          String imageulr = await HttpConfig().uploadFileToFirestore(
            tfiles.files[i].path.toString(),
          );
          print("--------------");

          if (imageulr != "false") {
            widget.setImageInList(imageulr);
          } else {
            showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
          }
        } catch (e) {
          showSnackbarMessageGlobal(e.toString(), context);
        }
        setState(() {
          widget.editLoadingList(a, false);
        });
      }
      setState(() {
        files!.files.addAll(tfiles.files);
      });
    }
  }

  _removefileFromList(index) {
    setState(() {
      // widget.removeLoadingList(index);
      // widget.removeImageInList(index);
      files!.files.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(
            Dimens.borderCircleRadius,
          ),
        ),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.uuploadDocTitle,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal *
                      Dimens.dialogTitleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical *
                    Dimens.verticleSpaceClosestWidget,
              ),
              files != null
                  ? files!.files.length > 0
                      ? Column(
                          children: files!.files.map((e) {
                            var index = files!.files.indexOf(e);
                            var fileName = files!.files[index].name;
                            return DrawerlistTileWidget(
                                isLoading: widget.loadingList.length > 0
                                    ? widget.loadingList[index]
                                    : false,
                                fileName: fileName,
                                filePath: files!.files[index].path.toString(),
                                index: index,
                                function: _removefileFromList);
                          }).toList(),
                        )
                      : Text("")
                  : Text(""),
              files == null
                  ? _buildAddDocButton(context)
                  : files!.files.isEmpty
                      ? _buildAddDocButton(context)
                      : SizedBox(),
              files != null && files!.files.length != 0
                  ? _buildimageNameoutline()
                  : SizedBox(),
              files != null && files!.files.length != 0
                  ? SizedBox(
                      height: SizeConfig.blockSizeVertical *
                          Dimens.verticleSpaceClosestWidget,
                    )
                  : SizedBox(),
              files != null && files!.files.length != 0
                  ? _buildSubmitButton(context)
                  : SizedBox(),
              SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: ButtonWidget(
                  title: 'Cancel',
                  onpress: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildAddDocButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: MaterialStateProperty.resolveWith(
              (states) => ThemeClass.orangeColor),
          padding: MaterialStateProperty.resolveWith(
              (states) => EdgeInsets.all(10))),
      onPressed: () {
        _pickfile();
      },
      child: isUploading
          ? Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size:
                      SizeConfig.safeBlockVertical * Dimens.iconFontSizeNormal,
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal *
                      Dimens.horizontalSpaceClosestWidget,
                ),
                Text(
                  AppStrings.btnAddDoc,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
    );
  }

  ElevatedButton _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith((states) =>
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => ThemeClass.orangeColor),
        padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.all(10),
        ),
      ),
      onPressed: () {
        Navigator.pop(context, files);
        // _pickfile();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2, top: 2),
        child: isUploading
            ? Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    )))
            : Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.uSubmit,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: SizeConfig.safeBlockHorizontal *
                        Dimens.horizontalSpaceClosestWidget,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                ],
              ),
      ),
    );
  }

  InkWell _buildimageNameoutline() {
    return InkWell(
      onTap: () {
        _pickfile1();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          decoration: new BoxDecoration(
            //new Color.fromRGBO(255, 0, 0, 0.0),
            border: Border.all(color: ThemeClass.orangeColor, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.uAddDocuments,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ThemeClass.orangeColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
