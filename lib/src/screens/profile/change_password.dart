import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/shared_preferance/shared_pref_service.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/themeData.dart';

class ChangePassWordScreen extends StatefulWidget {
  const ChangePassWordScreen({Key? key}) : super(key: key);

  @override
  _ChangePassWordScreenState createState() => _ChangePassWordScreenState();
}

class _ChangePassWordScreenState extends State<ChangePassWordScreen> {
  bool isObsecure = true;
  bool isObsecureold = true;
  bool isFirstSubmit = true;
  bool isObsecureCnfPass = true;
  bool isLoading = false;

  bool agree = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _oldpasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgraoundGradient(
          child: Container(
        child: Column(
          children: [
            SimpleAppBarWidget(title: AppStrings.cpChangePassword),
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
                      topLeft: Radius.circular(
                          SizeConfig.topLeftRadiousForContainer),
                      topRight: Radius.circular(
                          SizeConfig.topRightRadiousForContainer),
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
                    ),
                  )),
            )
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
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                      Dimens.verticleSpaceClosestWidget +
                  10,
            ),
            _oldpassTextbox(),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                      Dimens.verticleSpaceClosestWidget +
                  10,
            ),
            _passTextbox(),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                      Dimens.verticleSpaceClosestWidget +
                  10,
            ),
            _cpassTextbox(),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                      Dimens.verticleSpaceClosestWidget +
                  20,
            ),
            ButtonWidget(
              isLoading: isLoading,
              title: AppStrings.cChangePassword,
              onpress: () {
                setState(() {
                  isFirstSubmit = false;
                });

                if (_formKey.currentState!.validate()) {
                  callApi();
                  // Navigator.pushNamed(context, Routes.logingRoute);
                }
              },
              icon: Icons.arrow_forward,
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

  TextFormField _cpassTextbox() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _cpasswordController,
      obscureText: isObsecureCnfPass,
      validator: (value) {
        if (value!.isEmpty) {
          return AppStrings.pleaseEnterValidText +
              " " +
              AppStrings.cconfirmPassword;
        } else {
          if (_cpasswordController.text != _passwordController.text) {
            return AppStrings.passwordshouldbematch;
          }
        }
      },
      decoration: InputDecoration(
        hintText: AppStrings.cconfirmPassword + " *",
        suffixIcon: GestureDetector(
          child: Icon(
            isObsecureCnfPass ? Icons.visibility_off : Icons.visibility,
            color: ThemeClass.orangeColor.withOpacity(0.5),
          ),
          onTap: () {
            setState(() {
              isObsecureCnfPass = !isObsecureCnfPass;
            });
          },
        ),
        errorStyle: TextStyle(color: Color(0xff76777B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.outlineBorderRadius),
          borderSide: BorderSide(
            color: ThemeClass.orangeColor,
          ),
        ),
      ),
    );
  }

  TextFormField _oldpassTextbox() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _oldpasswordController,
      obscureText: isObsecureold,
      validator: (value) {
        if (value!.isEmpty) {
          return AppStrings.pleaseEnterValidText +
              " " +
              AppStrings.cpOldPassword;
        } else {
          if (value.length < 8) {
            return AppStrings.mustbeatleast8characters;
          }
        }
      },
      decoration: InputDecoration(
        hintText: AppStrings.cpOldPassword + " *",
        suffixIcon: GestureDetector(
          child: Icon(
            isObsecureold ? Icons.visibility_off : Icons.visibility,
            color: ThemeClass.orangeColor.withOpacity(0.5),
          ),
          onTap: () {
            setState(() {
              isObsecureold = !isObsecureold;
            });
          },
        ),
        errorStyle: TextStyle(color: Color(0xff76777B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.outlineBorderRadius),
          borderSide: BorderSide(
            color: ThemeClass.orangeColor,
          ),
        ),
      ),
    );
  }

  TextFormField _passTextbox() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _passwordController,
      obscureText: isObsecure,
      validator: (value) {
        if (value!.isEmpty) {
          return AppStrings.pleaseEnterValidText + " " + AppStrings.cPassword;
        } else {
          if (value.length < 8) {
            return AppStrings.mustbeatleast8characters;
          }
        }
      },
      decoration: InputDecoration(
        hintText: AppStrings.cPassword + " *",
        suffixIcon: GestureDetector(
          child: Icon(
            isObsecure ? Icons.visibility_off : Icons.visibility,
            color: ThemeClass.orangeColor.withOpacity(0.5),
          ),
          onTap: () {
            setState(() {
              isObsecure = !isObsecure;
            });
          },
        ),
        errorStyle: TextStyle(color: Color(0xff76777B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.outlineBorderRadius),
          borderSide: BorderSide(
            color: ThemeClass.orangeColor,
          ),
        ),
      ),
    );
  }

  void callApi() async {
    setState(() {
      isLoading = !isLoading;
    });
    try {
      var mapData = new Map<String, dynamic>();
      mapData['oldPassword'] = _oldpasswordController.text;
      mapData['newPassword'] = _passwordController.text;

      String? token = await SharedPrefService.getUserToken();

      String url = "auth/changepassword";
      var res =
          await HttpConfig().httpPostRequestWithToken(url, mapData, "$token");
      print(res.body);
      print(res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 200) {
        print("success");

        Navigator.pushNamed(context, Routes.profileScreen);
        showSnackbarMessageGlobal(AppStrings.Passwordchanged, context);
        setState(() {
          isLoading = !isLoading;
        });
      } else {
        showSnackbarMessageGlobal(AppStrings.incorrectpassword, context);
        print("failed");
        setState(() {
          isLoading = !isLoading;
        });
        print(res.body);
      }
    } catch (e) {
      setState(() {
        isLoading = !isLoading;
      });

      print(e);
      showSnackbarMessageGlobal(e.toString(), context);
    }
  }
}
