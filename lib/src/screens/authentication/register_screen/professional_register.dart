import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/customer_register_model.dart';
import 'package:pass/src/screens/authentication/register_screen/uploaddocument_dialog.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/src/widgets/text_form_field_widget.dart';
import 'package:pass/themeData.dart';

class ProfessionalRegisterScreen extends StatefulWidget {
  const ProfessionalRegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ProfessionalRegisterScreenState createState() =>
      _ProfessionalRegisterScreenState();
}

class _ProfessionalRegisterScreenState
    extends State<ProfessionalRegisterScreen> {
  bool isFirstSubmit = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cpasswordController = TextEditingController();
  TextEditingController _cStartDateController = TextEditingController();
  TextEditingController _cEndDateController = TextEditingController();

  bool isObsecure = true;
  bool isObsecureCnfPass = true;
  bool agree = false;
  bool isloading = false;
  FilePickerResult? files;
  bool isInitial = true;

  List<String> imageListToSend = [];
  List<bool> loadingList = [];

  addLoadingList(value) {
    setState(() {
      loadingList.add(value);
    });
  }

  editLoadingList(index, value) {
    setState(() {
      loadingList[index] = value;
    });
  }

  removeLoadingList(index) {
    setState(() {
      loadingList.removeAt(index);
    });
  }

  setImageInList(String image) {
    print(imageListToSend);
    setState(() {
      imageListToSend.add(image);
    });
  }

  removeImageInList(index) {
    print(imageListToSend);
    setState(() {
      imageListToSend.removeAt(index);
    });
  }

  Future<void> _showTimepicker() async {
    final TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.black, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: ThemeClass.orangeColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });

    if (result != null) {
      setState(() {
        print("current date ${result.hour}");
        print("current date ${result.minute}");

        String temp = result.minute.toString();
        String startTime;
        if (temp.length == 1) {
          startTime = "${result.hour}:0${result.minute}";
        } else {
          startTime = "${result.hour}:${result.minute}";
        }

        _cStartDateController.text = startTime;
      });
    }
  }

  Future<void> _showTimepickerend() async {
    final TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.black, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: ThemeClass.orangeColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });

    if (result != null) {
      String temp = result.minute.toString();
      String endTime;
      if (temp.length == 1) {
        endTime = "${result.hour}:0${result.minute}";
      } else {
        endTime = "${result.hour}:${result.minute}";
      }
      setState(() {
        _cEndDateController.text = endTime;
      });
    }
  }

  Future uploadImageToFireStore() async {
    var futures = files!.files.map(
        (image) => HttpConfig().uploadFileToFirestore(image.path.toString()));

    var response = await Future.wait(futures);
    imageListToSend = response;
  }

  register() async {
    setState(() {
      isloading = true;
    });
    await uploadImageToFireStore();
    String openTime = _cStartDateController.text;
    openTime = openTime.replaceAll(":", "");

    String closeTime = _cEndDateController.text;
    closeTime = closeTime.replaceAll(":", "");

    String url = "auth/customer/register";
    var addressModel = RegisterModel(
      name: _nameController.text,
      email: _emailController.text,
      pickupAddress: Address(
          authorName: "",
          authorMobileNumber: "",
          originalAddress: "",
          addressLine2: "",
          city: "",
          landmark: "",
          lat: "",
          long: "",
          pincode: ""),
      destinationAddress: Address(
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
      profilePicture: "",
      subscription: Subscription(
          name: "Free Pass", totalRides: 0, maxKm: 0, maxkmExceededRate: 0),
      vehicle: [],
      mobileNumber: _mobileController.text,
      role: "professionalCustomer",
      password: _passwordController.text,
      openTime: openTime,
      closeTime: closeTime,
      uploadedDocuments: imageListToSend,
    );
    // );

    try {
      var response = await HttpConfig().httpPostRequest(url, addressModel);

      if (response.statusCode == 201 || response.statusCode == 200) {
        showSnackbarMessageGlobal(
            AppStrings.UserRegisteredSuccessfully, context);

        Navigator.pushReplacementNamed(
          context,
          Routes.varifyEmailScreen,
          arguments: _emailController.text,
        );
      } else if (response.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.AlreadyRegisterd, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      setState(() => isloading = false);
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
            SimpleAppBarWidget(title: AppStrings.registerProAccount),
            SizedBox(
              height: 60,
            ),
            Flexible(
              child: Container(
                // height: MediaQuery.of(context).size.height + 70,
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
                  child: _buildForm(context),
                ),
              ),
            ),
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
      //       color: Colors.black38,
      //       blurRadius: 15.0,
      //       offset: Offset(0.0, 9.75),
      //     )
      //   ],
      //   borderRadius: BorderRadius.circular(30),
      // ),
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        autovalidateMode: !isFirstSubmit
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          children: [
            TextFormFieldWdiget(
              controller: _nameController,
              hintText: AppStrings.rName,
              showNext: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              type: 'name',
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
            Row(
              children: [
                Flexible(
                  child: _buildStartAlarm(),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: _buildEndAlarm(),
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                  Dimens.verticleSpaceClosestWidget,
            ),
            _fileupload(),
            !isInitial
                ? files == null || files!.files.length < 0
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 9, left: 12),
                          child: Text(
                            AppStrings.rPleaseuploadfiles,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff76777B),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      )
                : SizedBox(
                    height: 0,
                  ),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                  Dimens.verticleSpaceClosestWidget,
            ),
            files != null
                ? files!.files.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: files!.files.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              title: Text(files!.files[index].name));
                        },
                      )
                    : SizedBox()
                : SizedBox(),
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
                  if (files != null) {
                    if (files!.files.length > 0) {
                      register();
                    }
                  }
                }
              },
            ),
            SizedBox(
              height: 40,
            ),
            _buildBottom(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildStartAlarm() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onTap: () {
        _showTimepicker();
        print("object");
      },
      controller: _cStartDateController,
      // enabled: false,
      readOnly: true,
      validator: (value) {
        if (value == "") {
          return AppStrings.Startingdateisrequire;
        }
      },
      decoration: InputDecoration(
        hintText: AppStrings.startingtime,

        // suffixStyle: TextStyle(wordSpacing: 0, letterSpacing: 0),
        suffixIconConstraints: BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              _showTimepicker();
              print("object");
            },
            icon: Icon(
              Icons.alarm,
              color: ThemeClass.orangeColor.withOpacity(0.5),
            ),
          ),
        ),
        errorStyle: TextStyle(color: Color(0xff76777B)),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.outlineBorderRadius),
          borderSide: BorderSide(
            color: ThemeClass.orangeColor,
          ),
        ),
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 20, top: 20, right: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.outlineBorderRadius),
          borderSide: BorderSide(
            color: ThemeClass.orangeColor,
          ),
        ),
      ),
    );
  }

  TextFormField _buildEndAlarm() {
    return TextFormField(
      onTap: () {
        _showTimepickerend();
        print("object");
      },
      controller: _cEndDateController,
      // enabled: false,
      readOnly: true,
      validator: (value) {
        if (value == "") {
          return AppStrings.Endingdateisrequire;
        }
      },
      decoration: InputDecoration(
        hintText: AppStrings.Endingtime,

        // suffixStyle: TextStyle(wordSpacing: 0, letterSpacing: 0),
        suffixIconConstraints: BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              // _showTimepickerend();
              // print("object");
            },
            icon: Icon(
              Icons.alarm,
              color: ThemeClass.orangeColor.withOpacity(0.5),
            ),
          ),
        ),
        errorStyle: TextStyle(color: Color(0xff76777B)),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.outlineBorderRadius),
          borderSide: BorderSide(
            color: ThemeClass.orangeColor,
          ),
        ),
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 20, top: 20, right: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.outlineBorderRadius),
          borderSide: BorderSide(
            color: ThemeClass.orangeColor,
          ),
        ),
      ),
    );
  }

  InkWell _fileupload() {
    return InkWell(
      onTap: () {
        showUploadDocumentDialog();
      },
      child: Theme(
        data: ThemeData(
          disabledColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(Dimens.outlineBorderRadius)),
            border: Border.all(color: ThemeClass.orangeColor),
            // shape: BoxShape.circle,
          ),
          child: TextFormField(
            enabled: false,
            decoration: InputDecoration(
              hintText: AppStrings.rUploadDocuments + " *",
              hintStyle: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
              suffixIcon: GestureDetector(
                child: Icon(
                  Icons.upload_file_sharp,
                  color: ThemeClass.orangeColor.withOpacity(0.5),
                ),
                onTap: () {
                  // onpress!();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.outlineBorderRadius),
                // borderSide: BorderSide(
                //   color: Colors.transparent,
                // ),
              ),
            ),
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
                  TextSpan(text: ' '),
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

  showUploadDocumentDialog() async {
    var filesTemp = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: UploadDocumentDialog(
          setImageInList: (image) {
            setImageInList(image);
          },
          removeImageInList: (index) {
            removeImageInList(index);
          },
          addLoadingList: (value) {
            addLoadingList(value);
          },
          removeLoadingList: (index) {
            removeLoadingList(index);
          },
          editLoadingList: (index, value) {
            editLoadingList(index, value);
          },
          loadingList: loadingList,
          ctx: ctx,
          files: files,
        ),
      ),
    );

    if (filesTemp != null) {
      setState(() {
        files = filesTemp;
      });
    }
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
