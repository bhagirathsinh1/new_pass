import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';

import 'package:pass/themeData.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    setFirstloginfalse();
    super.initState();
  }

  setFirstloginfalse() async {
    // await SharedPrefService.setSharedPreferencFirstlogin();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: 3,
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: onboardSlide()[i],
              );
            },
          ),
        ),
        Container(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: List.generate(3, (index) => buildDot(index, context)),
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.all(40),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text(AppStrings.skip,
                    style: TextStyle(decoration: TextDecoration.underline)),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.logingRoute, (route) => false);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
                      (states) => ThemeClass.orangeColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (currentIndex == 3 - 1) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.logingRoute, (route) => false);
                  }
                  _controller.nextPage(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.bounceIn);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.black),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(currentIndex == 3 - 1
                        ? AppStrings.finish
                        : AppStrings.next),
                    Icon(Icons.arrow_forward_ios,
                        size: SizeConfig.safeBlockHorizontal *
                            Dimens.iconFontSizeNormal)
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }

  List<Widget> onboardSlide() => [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(AppStrings.welcome,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.safeBlockHorizontal *
                          Dimens.titleFontSize)),
            ),
            Center(
              child: Text(
                AppStrings.welcomeDesc,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.asset(
                    "assets/images/onbordingFirstIcon.png",
                    fit: BoxFit.fill,
                  )),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(AppStrings.personalAccount,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.safeBlockHorizontal *
                          Dimens.titleFontSize)),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image.asset(
                    "assets/images/account_slide.png",
                    fit: BoxFit.fill,
                  )),
            ),
            // Image.asset("assets/images/account_slide.png"),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(AppStrings.personalDesc,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 19)),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(AppStrings.professionalAccount,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.safeBlockHorizontal *
                          Dimens.titleFontSize)),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image.asset(
                    "assets/images/professionalIcon1.png",
                    fit: BoxFit.fill,
                  )),
            ),
            // Image.asset("assets/images/professionalIcon1.png"),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(AppStrings.professionalDesc,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 19)),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ];

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: currentIndex == index ? Colors.transparent : Colors.black),
          color: currentIndex == index
              ? ThemeClass.orangeColor
              : Colors.transparent),
    );
  }
}
