import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/themeData.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({Key? key, required this.email})
      : super(key: key);

  final String email;

  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  bool isObsecure = true;
  bool isFirstSubmit = true;
  bool isObsecureCnfPass = true;
  bool agree = false;

  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
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
            SimpleAppBarWidget(title: AppStrings.cCreatenewpassword),
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
                      SizeConfig.topLeftRadiousForContainer,
                    ),
                    topRight: Radius.circular(
                      SizeConfig.topRightRadiousForContainer,
                    ),
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
                ),
              ),
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
            _passTextbox(),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                      Dimens.verticleSpaceClosestWidget +
                  20,
            ),
            _cpassTextbox(),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                      Dimens.verticleSpaceClosestWidget +
                  20,
            ),
            ButtonWidget(
              isLoading: isloading,
              title: AppStrings.cChangePassword,
              onpress: () {
                setState(() {
                  isFirstSubmit = false;
                });
                if (_formKey.currentState!.validate()) {
                  // Navigator.pushNamed(context, Routes.logingRoute);
                  changePassword();
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

  changePassword() async {
    setState(() {
      isloading = true;
    });

    var mapData = new Map<String, dynamic>();
    mapData['email'] = widget.email;
    mapData['password'] = _passwordController.text;
    mapData['role'] = "customer";

    String url = "auth/forgotpassword/otpverified";

    try {
      var res = await HttpConfig().httpPostRequest(url, mapData);
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 201) {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => CreateNewPasswordScreen(email: widget.email),
        //   ),
        // );

        Navigator.pushNamed(context, Routes.logingRoute);
        showSnackbarMessageGlobal(AppStrings.passwordChangedMessage, context);
        // showSnackbarMessageGlobal("Otp successfully send.", context);
      } else if (res.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
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
