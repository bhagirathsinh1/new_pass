import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/driver_model.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';

import 'package:pass/themeData.dart';

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({Key? key}) : super(key: key);

  @override
  _DriverDetailsScreenState createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    DriverModel driver =
        ModalRoute.of(context)!.settings.arguments as DriverModel;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: CustomScrollView(
          slivers: <Widget>[
            AppBarWidget(title: AppStrings.ddDriverdetails),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
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
                    height: MediaQuery.of(context).size.height - 130,
                    // padding: EdgeInsets.all(40.0),
                    child: _buildDriverView(context, driver),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDriverView(BuildContext context, DriverModel driver) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              height: 95,
              width: 95,
              child: (driver.profilePicture == null ||
                      driver.profilePicture == "null" ||
                      driver.profilePicture == "")
                  ? Image.network(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: driver.profilePicture,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: ThemeClass.orangeColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: ThemeClass.orangeColor,
                      ),
                    ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          driver.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 6),
        Text(
          driver.mobileNumber.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: ThemeClass.orangeColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: ThemeClass.greyColor.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            minLeadingWidth: 10,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.language,
                  color: Colors.black,
                ),
              ],
            ),
            title: Text(
              AppStrings.ddLanguages,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(AppStrings.ddEnglishItalic),
          ),
        ),
        // SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: ThemeClass.greyColor.withOpacity(0.3),
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.ddArrivingin15mins,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 5),
        // Padding(
        //   padding: const EdgeInsets.all(28.0),
        //   child: ButtonWidget(
        //     title: AppStrings.ddTrackdriver,
        //     onpress: () {},
        //     icon: Icons.arrow_forward,
        //   ),
        // ),
      ],
    );
  }
}
