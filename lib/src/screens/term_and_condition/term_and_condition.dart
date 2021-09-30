import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/themeData.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:url_launcher/url_launcher.dart';

class TermAndConditionScreen extends StatefulWidget {
  const TermAndConditionScreen({Key? key}) : super(key: key);

  @override
  _TermAndConditionScreenState createState() => _TermAndConditionScreenState();
}

class _TermAndConditionScreenState extends State<TermAndConditionScreen> {
  bool isObsecure = true;
  bool isObsecureCnfPass = true;
  bool agree = false;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  // @override
  // Widget build(BuildContext context) {
  //   SizeConfig().init(context);

  //   return Scaffold(
  //     body: BackgraoundGradient(
  //       child: CustomScrollView(
  //         slivers: <Widget>[
  //           AppBarWidget(title: AppStrings.tcTermandcondition),
  //           SliverList(
  //             delegate: SliverChildListDelegate(
  //               [
  //                 Container(
  //                   // width: MediaQuery.of(context).size.width,
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
  //                       padding: const EdgeInsets.all(20.0),
  //                       child: Container(
  //                         height: MediaQuery.of(context).size.height,
  //                         child: _buildForm(context),
  //                       )),
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
                title: AppStrings.tcTermandcondition,
                onpress: () {
                  Navigator.pop(context);
                },
                onPress: true,
              ),
              SizedBox(
                height: 50,
              ),
              Flexible(
                child: Container(
                  // width: MediaQuery.of(context).size.width,
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
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: _buildForm(context),
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

  // _buildForm(BuildContext context) {
  //   return SfPdfViewer.network(
  //     'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
  //     key: _pdfViewerKey,
  //   );
  // }
  _buildForm(BuildContext context) {
    return FutureBuilder(
      future: HttpConfig().httpGetRequest('termsandconditions', ''),
      builder: (BuildContext context, AsyncSnapshot<Response> snap) {
        if (snap.hasData) {
          var tnc = jsonDecode(snap.data!.body);
          return SfPdfViewer.network(
            tnc['tnc'],
            key: _pdfViewerKey,
          );
        } else if (snap.hasError) {
          return Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Text('Error ${snap.error}'),
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height - 150,
            child: Center(
              child: CircularProgressIndicator(
                color: ThemeClass.orangeColor,
              ),
            ),
          );
        }
      },
    );
  }

  // void _launchURL(String _url) async => await canLaunch(_url)
  //     ? await launch(_url)
  //     : throw 'Could not launch $_url';
}
