import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';

class SignupAsScreen extends StatefulWidget {
  const SignupAsScreen({Key? key}) : super(key: key);

  @override
  _SignupAsScreenState createState() => _SignupAsScreenState();
}

class _SignupAsScreenState extends State<SignupAsScreen> {
  bool isObsecure = true;
  bool isObsecureCnfPass = true;
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: BackgraoundGradient(
        child: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: <Widget>[
            AppBarWidget(title: AppStrings.sSignupas),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    // height: MediaQuery.of(context).size.height * 0.8,
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
                    child: Column(
                      children: [
                        _buildForm(context),
                        SizedBox(
                          height: 40,
                        ),
                      ],
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                Routes.personalRegisterScreen,
              );
              // Navigator.pushNamed(context, Routes.personalRegisterScreen);
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (ctx) => RegisterScreen(
              //           isProfessional: false,
              //         )));
            },
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/images/personalAccountIcon.png',
                    height: 240,
                    width: 240,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.sPersonalAccount,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                Routes.professionalRegisterScreen,
              );
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (ctx) => RegisterScreen(
              //           isProfessional: true,
              //         )));
            },
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/images/professionalLogo.png',
                    height: 240,
                    width: 240,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.sProfessionalAccount,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
