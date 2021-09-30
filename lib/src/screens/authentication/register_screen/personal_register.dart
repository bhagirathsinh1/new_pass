import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/customer_register_model.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/src/widgets/text_form_field_widget.dart';
import 'package:pass/themeData.dart';

class PersonalRegisterScreen extends StatefulWidget {
  const PersonalRegisterScreen({Key? key}) : super(key: key);

  @override
  _PersonalRegisterScreenState createState() => _PersonalRegisterScreenState();
}

class _PersonalRegisterScreenState extends State<PersonalRegisterScreen> {
  bool isFirstSubmit = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cpasswordController = TextEditingController();

  bool isObsecure = true;
  bool isObsecureCnfPass = true;
  bool agree = false;

  bool isInitial = true;
  bool isloading = false;

  register() async {
    // make custmer register model ..
    setState(() {
      isloading = !isloading;
    });
    var addressModel = RegisterModel(
      name: _nameController.text,
      email: _emailController.text,
      mobileNumber: _mobileController.text,
      closeTime: "00",
      openTime: "00",
      profilePicture: "",
      subscription: Subscription(
          name: "Free Pass", totalRides: 0, maxKm: 0, maxkmExceededRate: 0),
      uploadedDocuments: [],
      vehicle: [],
      role: "personalCustomer",
      pickupAddress: Address(
        // addressLine1: "",
        authorName: "",
        authorMobileNumber: "",
        originalAddress: "",
        addressLine2: "",
        city: "",
        landmark: "",
        lat: "",
        long: "",
        pincode: "",
      ),
      destinationAddress: Address(
          // addressLine1: "",
          authorName: "",
          authorMobileNumber: "",
          originalAddress: "",
          addressLine2: "",
          city: "",
          landmark: "",
          lat: "",
          long: "",
          pincode: ""),
      password: _passwordController.text,
    );

    String url = "auth/customer/register";

    try {
      var response = await HttpConfig().httpPostRequest(url, addressModel);

      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          isloading = !isloading;
        });
        showSnackbarMessageGlobal(
            AppStrings.UserRegisteredSuccessfully, context);
        // Navigator.pushNamed(context, Routes.logingRoute);
        Navigator.pushReplacementNamed(
          context,
          Routes.varifyEmailScreen,
          arguments: _emailController.text,
        );
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   Routes.logingRoute,
        //   (Route<dynamic> route) => false,
        // );
      } else if (response.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.AlreadyRegisterd, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      print(e);
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      setState(() {
        isloading = !isloading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: BackgraoundGradient(
          child: Container(
        child: Column(
          children: [
            SimpleAppBarWidget(
              title: AppStrings.RegisterPersonalAccount,
            ),
            SizedBox(
              height: 60,
            ),
            Flexible(
              child: Container(
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
                height: MediaQuery.of(context).size.height,
                // padding: EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  child: _buildForm(context),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Row _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.rAlreadyhaveanaccount,
            style: TextStyle(fontSize: 15, color: ThemeClass.greyColor)),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.logingRoute);
          },
          child: Text(AppStrings.rSignin,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: ThemeClass.orangeColor)),
        ),
      ],
    );
  }

  _buildForm(BuildContext context) {
    return Padding(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   shape: BoxShape.rectangle,
      //   boxShadow: [
      //     BoxShadow(
      //         color: Colors.black38,
      //         blurRadius: 15.0,
      //         offset: Offset(0.0, 9.75))
      //   ],
      //   borderRadius: BorderRadius.circular(30),
      // ),
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        autovalidateMode: !isFirstSubmit
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Container(
          child: Column(
            children: [
              TextFormFieldWdiget(
                controller: _nameController,
                hintText: AppStrings.rName,
                textCapitalization: TextCapitalization.words,
                type: 'name',
                showNext: TextInputAction.next,
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical *
                    Dimens.verticleSpaceClosestWidget,
              ),
              TextFormFieldWdiget(
                controller: _emailController,
                hintText: AppStrings.rEmail,
                type: "email",
                showNext: TextInputAction.next,
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical *
                    Dimens.verticleSpaceClosestWidget,
              ),
              TextFormFieldWdiget(
                controller: _mobileController,
                hintText: AppStrings.rMobileNumber,
                type: "number",
                showNext: TextInputAction.next,
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical *
                    Dimens.verticleSpaceClosestWidget,
              ),
              _passTextbox(),
              SizedBox(
                height: SizeConfig.safeBlockVertical *
                    Dimens.verticleSpaceClosestWidget,
              ),
              _cpassTextbox(),
              SizedBox(
                height: SizeConfig.safeBlockVertical *
                    Dimens.verticleSpaceClosestWidget,
              ),
              _buildCheckTermAndCondition(),
              SizedBox(
                height: SizeConfig.safeBlockVertical *
                    Dimens.verticleSpaceClosestWidget,
              ),
              ButtonWidget(
                isLoading: isloading,
                isDisable: !agree,
                icon: Icons.arrow_forward,
                title: AppStrings.rSignup,
                onpress: () {
                  setState(() {
                    isInitial = false;
                    isFirstSubmit = false;
                  });
                  if (_formKey.currentState!.validate()) {
                    print(_nameController.text);
                    print(_emailController.text);
                    print(_mobileController.text);
                    print(_passwordController.text);
                    register();
                  }
                },
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 40,
              ),
              _buildBottom(),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Align _buildCheckTermAndCondition() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: agree,
            activeColor: ThemeClass.orangeColor,
            onChanged: (value) {
              setState(() {
                agree = value ?? false;
              });
            },
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.termAndConditionScreen);
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppStrings.rAgreeto,
                    style: TextStyle(
                      color: ThemeClass.greyColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '  ',
                  ),
                  TextSpan(
                    text: AppStrings.rTermsConditions,
                    style: TextStyle(
                      color: ThemeClass.orangeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  TextFormField _cpassTextbox() {
    return TextFormField(
      controller: _cpasswordController,
      obscureText: isObsecureCnfPass,
      validator: (value) {
        if (value!.isEmpty) {
          return AppStrings.pleaseEnterValidText +
              ' ' +
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
      controller: _passwordController,
      obscureText: isObsecure,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return AppStrings.pleaseEnterValidText + ' ' + AppStrings.cPassword;
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
}
