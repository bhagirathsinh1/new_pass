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

class VarifyEmailScreen extends StatefulWidget {
  const VarifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VarifyEmailScreenState createState() => _VarifyEmailScreenState();
}

class _VarifyEmailScreenState extends State<VarifyEmailScreen> {
  bool isObsecure = true;
  bool isObsecureCnfPass = true;
  bool agree = false;
  bool isResendLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      body: BackgraoundGradient(
        child: CustomScrollView(
          slivers: <Widget>[
            AppBarWidget(title: AppStrings.vVerifyyouremail),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: MediaQuery.of(context).size.height - 120,
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildForm(context),
                          SizedBox(
                            height: 40,
                          ),
                          _buildBottom(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildForm(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height - 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 15.0,
            offset: Offset(0.0, 9.75),
          )
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                AppStrings.vCheckyourEmail,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * Dimens.verticleSpaceWidget,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Image.asset(
              "assets/images/verifyEmailLogo.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * Dimens.verticleSpaceWidget,
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical *
                Dimens.verticleSpaceClosestWidget,
          ),
          ButtonWidget(
            icon: Icons.arrow_forward,
            title: AppStrings.vContinue,
            onpress: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.logingRoute,
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _verifyEmail() async {
    try {
      setState(() => isResendLoading = true);
      final tempMail = ModalRoute.of(context)!.settings.arguments as String;
      var obj = {'email': tempMail};

      // var emailTosend = tempMail;
      // print(obj);
      var response = await HttpConfig().httpPostRequest(
          'auth/customer/resendverificationlink/$tempMail', obj);
      print("response $response");
      showSnackbarMessageGlobal(AppStrings.Verificationemailisresent, context);
    } catch (e) {
      print(e);
    } finally {
      setState(() => isResendLoading = false);
    }
  }

  Row _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              AppStrings.vDidntget,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            !isResendLoading
                ? OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: BorderSide(
                        width: 1.5,
                        color: ThemeClass.orangeColor,
                      ),
                    ).copyWith(
                      foregroundColor: MaterialStateProperty.all(
                        ThemeClass.orangeColor,
                      ),
                    ),
                    onPressed: _verifyEmail,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 12, 40, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            AppStrings.vResendEmail,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: BorderSide(
                        width: 1.5,
                        color: ThemeClass.orangeColor,
                      ),
                    ).copyWith(
                      foregroundColor: MaterialStateProperty.all(
                        ThemeClass.orangeColor,
                      ),
                    ),
                    onPressed: _verifyEmail,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 12, 40, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CircularProgressIndicator(
                            color: ThemeClass.orangeColor,
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ],
    );
  }
}
