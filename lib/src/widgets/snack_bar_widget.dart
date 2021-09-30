import 'package:flutter/material.dart';
import 'package:pass/src/config/strings.dart';

void showSnackbarMessageGlobal(String msg, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(msg),
    action: SnackBarAction(
      label: AppStrings.Close,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showAlertDialogGlobal(
  String title,
  String content,
  BuildContext context,
  Function function,
) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.all(35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(AppStrings.maNo)),
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                    function();
                  },
                  child: Text(AppStrings.maYes))
            ],
          ));
}
