import 'package:flutter/material.dart';

import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/themeData.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool isObsecure = true;
  bool isObsecureCnfPass = true;
  bool agree = false;

  // @override
  // Widget build(BuildContext context) {
  //   SizeConfig().init(context);

  //   return Scaffold(
  //     body: BackgraoundGradient(
  //       child: CustomScrollView(
  //         slivers: <Widget>[
  //           AppBarWidget(title: AppStrings.Aboutus),
  //           SliverList(
  //             delegate: SliverChildListDelegate(
  //               [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   // alignment: Alignment.topCenter,
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     shape: BoxShape.rectangle,
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(
  //                           SizeConfig.topLeftRadiousForContainer),
  //                       topRight: Radius.circular(
  //                           SizeConfig.topRightRadiousForContainer),
  //                     ),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: _buildForm(context),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: Container(
          child: Column(
            children: [
              SimpleAppBarWidget(
                title: AppStrings.Aboutus,
                onpress: () {
                  Navigator.pop(context);
                },
                onPress: true,
              ),
              SizedBox(
                height: 60,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  // alignment: Alignment.topCenter,
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SingleChildScrollView(child: _buildForm(context)),
                  ),
                ),
              ),
              // _buildForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          child: Text(
            "Trasportiamo la tua passione...\nCan la tua stessa cura!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(
            "L'App che ti porta la moto dal meccanico",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.55,
          // height: MediaQuery.of(context).size.width * 0.5,
          child: Image.asset(
            "assets/images/aboutscreenIcon.png",
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          child: Text(
            "Attiva il servizio ed usalo quando vuoi per trasportare la tua moto o il tuo scooter dal gommista o dal meccanico.",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 8, top: 10, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ThemeClass.orangeColor),
                height: 10,
                width: 10,
                margin: EdgeInsets.only(
                  right: 8,
                ),
              ),
              Container(
                child: Text(
                  "Flotta di furgoni attrezzati",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 8, top: 5, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ThemeClass.orangeColor),
                height: 10,
                width: 10,
                margin: EdgeInsets.only(
                  right: 8,
                ),
              ),
              Container(
                child: Text(
                  "Personale esperto",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Text(
            "${AppStrings.tcFollowuson}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  _launchURL("https://m.facebook.com/");
                },
                child: CircleAvatar(
                  // backgroundColor: Colors.red,
                  backgroundImage: AssetImage("assets/images/facebook.png"),
                  radius: 26,
                ),
              ),
              InkWell(
                onTap: () {
                  _launchURL(
                      "https://www.instagram.com/sem/campaign/emailsignup/?campaign_id=13804936943&extra_1=s|c|532005755748|e|instagram%20login|&placement=&creative=532005755748&keyword=instagram%20login&partner_id=googlesem&extra_2=campaignid%3D13804936943%26adgroupid%3D122851064565%26matchtype%3De%26network%3Dg%26source%3Dnotmobile%26search_or_content%3Ds%26device%3Dc%26devicemodel%3D%26adposition%3D%26target%3D%26targetid%3Dkwd-1321618857291%26loc_physical_ms%3D1007759%26loc_interest_ms%3D%26feeditemid%3D%26param1%3D%26param2%3D&gclid=CjwKCAjwgviIBhBkEiwA10D2j6vyDzJgf_uOA_e_f_-BVC1GLR6OhZGgr3yQTNjqaKnR6Qcl7aYhQxoCOmAQAvD_BwE");
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/instagram.png"),
                  radius: 26,
                ),
              ),
              InkWell(
                onTap: () {
                  _launchURL("https://twitter.com/");
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/twitter.png"),
                  radius: 26,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
