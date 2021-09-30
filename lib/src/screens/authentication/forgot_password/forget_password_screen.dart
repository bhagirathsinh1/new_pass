import 'package:flutter/material.dart';

import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/screens/authentication/forgot_password/otp_verification_screen.dart';

import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/src/widgets/text_form_field_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool isFirstSubmit = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgraoundGradient(
          child: Container(
        child: Column(
          children: [
            SimpleAppBarWidget(title: AppStrings.fForgetPassWord),
            SizedBox(
              height: 60,
            ),
            Flexible(
                child: Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(SizeConfig.topLeftRadiousForContainer),
                  topRight:
                      Radius.circular(SizeConfig.topRightRadiousForContainer),
                ),
              ),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  _buildForm(context),
                  SizedBox(
                    height: 40,
                  ),
                ],
              )),
            ))
          ],
        ),
      )),
    );
  }

  Container _buildForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        autovalidateMode: !isFirstSubmit
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  AppStrings.ftitle,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                  Dimens.verticleSpaceClosestWidget,
            ),
            TextFormFieldWdiget(
              type: "email",
              hintText: AppStrings.fhintTextEmail,
              controller: _emailController,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                  Dimens.verticleSpaceClosestWidget,
            ),
            SizedBox(
              height: 10,
            ),
            ButtonWidget(
                isLoading: isLoading,
                title: AppStrings.fresetPassword,
                icon: Icons.arrow_forward,
                onpress: () {
                  setState(() {
                    isFirstSubmit = false;
                  });
                  if (_formKey.currentState!.validate()) {
                    checkEmail();
                  }
                }),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  checkEmail() async {
    setState(() {
      isLoading = true;
    });
    print(_emailController.text);
    var mapData = new Map<String, dynamic>();
    mapData['email'] = _emailController.text;
    mapData['role'] = "customer";

    String url = "auth/findByEmail";
    //  /api/customer/{id}/forgotPassword
    try {
      var res = await HttpConfig().httpPostRequest(url, mapData);
      print(res.statusCode);

      if (res.statusCode == 201) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              email: _emailController.text,
            ),
          ),
        );
        // Navigator.pushNamed(context, Routes.otpVerificationScreen);
      } else if (res.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.Emailnotfound, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      // setState(() {
      //   isLoading = !isLoading;
      // });
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  // Navigator.pushNamed(context, Routes.otpVerificationScreen);

}
