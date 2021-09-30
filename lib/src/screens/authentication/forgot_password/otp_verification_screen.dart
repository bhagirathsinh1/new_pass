import 'package:flutter/material.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/screens/authentication/forgot_password/create_new_password_screen.dart';

import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/themeData.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key, required this.email})
      : super(key: key);

  final String email;

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool isObsecure = true;
  bool isObsecureCnfPass = true;
  bool agree = false;
  bool isFirstSubmit = true;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _otpController = new TextEditingController();

  final FocusNode _pinPutFocusNode = FocusNode();
  bool isLoadingresend = false;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgraoundGradient(
          child: Container(
        child: Column(
          children: [
            SimpleAppBarWidget(title: AppStrings.oVerifyyouremail),
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
                  _buildBottom(),
                ],
              )),
            ))
          ],
        ),
      )),
    );
  }

  Widget darkRoundedPinPut() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: ThemeClass.orangeColor,
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Theme(
        data: ThemeData(),
        child: PinPut(
          eachFieldWidth: 50.0,
          eachFieldHeight: 50.0,
          withCursor: true,
          fieldsCount: 4,
          focusNode: _pinPutFocusNode,
          controller: _otpController,
          validator: (value) {
            if (value!.isEmpty) {
              return AppStrings.oPleaseenterOTP;
            } else if (value.length != 4) {
              return AppStrings.oPleaseenterOTP;
            }
          },
          submittedFieldDecoration: pinPutDecoration,
          selectedFieldDecoration: pinPutDecoration,
          followingFieldDecoration: pinPutDecoration,
          pinAnimationType: PinAnimationType.scale,
          textStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
        ),
      ),
    );
  }

  Container _buildForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                blurRadius: 15.0,
                offset: Offset(0.0, 9.75))
          ],
          borderRadius: BorderRadius.circular(30)),
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
                  AppStrings.opleaseenter4digit,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * Dimens.verticleSpaceWidget,
            ),
            darkRoundedPinPut(),
            SizedBox(
              height: SizeConfig.safeBlockVertical * Dimens.verticleSpaceWidget,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                  Dimens.verticleSpaceClosestWidget,
            ),
            ButtonWidget(
              isLoading: isloading,
              title: AppStrings.oconfirm,
              onpress: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  isFirstSubmit = false;
                });
                if (_formKey.currentState!.validate()) {
                  if (_otpController.text.length == 4) {
                    verifyOtp();
                  }

                  // Navigator.pushNamed(context, Routes.createNewPasswordScreen);
                }
              },
            ),
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

  Row _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              AppStrings.odidntgetcode,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: BorderSide(width: 1.5, color: ThemeClass.orangeColor),
              ).copyWith(
                  foregroundColor:
                      MaterialStateProperty.all(ThemeClass.orangeColor)),
              onPressed: () {
                resendOtp();
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 12, 40, 12),
                    child: isLoadingresend
                        ? Center(
                            child: SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: ThemeClass.orangeColor,
                                )))
                        : Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.oResendCode,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  resendOtp() async {
    setState(() {
      isLoadingresend = true;
    });

    var mapData = new Map<String, dynamic>();
    mapData['email'] = widget.email;
    mapData['role'] = "customer";

    String url = "auth/findByEmail";

    try {
      var res = await HttpConfig().httpPostRequest(url, mapData);
      print(res.statusCode);

      if (res.statusCode == 201) {
        showSnackbarMessageGlobal(AppStrings.Otpsuccessfullysend, context);
      } else if (res.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.Emailnotfound, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      setState(() {
        isLoadingresend = false;
      });
    }
  }

  verifyOtp() async {
    setState(() {
      isloading = true;
    });

    var mapData = new Map<String, dynamic>();
    mapData['email'] = widget.email;
    mapData['otp'] = _otpController.text;
    mapData['role'] = "customer";

    String url = "auth/forgotpassword/otpverification";

    try {
      var res = await HttpConfig().httpPostRequest(url, mapData);
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 201) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateNewPasswordScreen(email: widget.email),
          ),
        );
        // showSnackbarMessageGlobal("Otp successfully send.", context);
      } else if (res.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.Otpisinvalid, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }
}
