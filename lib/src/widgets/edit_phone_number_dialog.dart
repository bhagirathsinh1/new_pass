import 'package:flutter/material.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/src/widgets/text_form_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ShowAlertDialogEditNumber extends StatefulWidget {
  ShowAlertDialogEditNumber({Key? key, required this.controller})
      : super(key: key);
  TextEditingController controller;
  _ShowAlertDialogEditNumberState createState() =>
      _ShowAlertDialogEditNumberState();
}

class _ShowAlertDialogEditNumberState extends State<ShowAlertDialogEditNumber> {
  bool isFirstSubmit = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Container(
        child: Center(
          child: Text(AppStrings.editNumber),
        ),
      ),
      content: Container(
        child: Form(
          key: _formKey,
          autovalidateMode: !isFirstSubmit
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormFieldWdiget(
                  hintText: AppStrings.EnterNumber,
                  type: "number",
                  controller: widget.controller)
            ],
          ),
        ),
      ),
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.only(top: 20, left: 20, right: 20),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('NO')),
        TextButton(
            onPressed: () async {
              setState(() {
                isFirstSubmit = false;
              });
              if (_formKey.currentState!.validate()) {
                print("valide");
                updateNumber();
              }
              // Navigator.of(context).pop(false);
              // function();
            },
            child: Text(AppStrings.maYes))
      ],
    );
  }

  updateNumber() async {
    print(widget.controller.text);

    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    var mapData = new Map<String, dynamic>();
    mapData['mobileNumber'] = widget.controller.text;
    String custid = prefs.getString("customer_id").toString();
    String url = "customer/$custid";

    try {
      var response = await HttpConfig().httpPatchRequestWithToken(
          url, mapData, prefs.getString("customer_accessToken").toString());
      print(response);
      if (response.statusCode == 201 || response.statusCode == 200) {
        showSnackbarMessageGlobal(AppStrings.Numbersucessfullyupdated, context);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("customer_mobile", widget.controller.text);
        Navigator.pop(context, true);
      } else if (response.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.Numbernotupdated, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }
}
