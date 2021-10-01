import 'package:flutter/material.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/widgets/appbar_widget.dart';

import 'package:pass/src/widgets/background_gradiant.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: Container(
          child: Column(
            children: [
              SimpleAppBarWidget(title: AppStrings.nAppTitleNotifications),
              SizedBox(
                height: 60,
              ),
              Flexible(
                child: Container(
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
                  height: MediaQuery.of(context).size.height,
                  // padding: EdgeInsets.all(40.0),
                  child: SingleChildScrollView(child: _buildListView()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text(
              'Yay ! your ride is confirmed.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Mr. Abrado is coming to pick your bike.'),
            trailing: Text('30 mins ago'),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Yay ! your ride is confirmed.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Mr. Abrado is coming to pick your bike.'),
            trailing: Text('30 mins ago'),
          ),
        ],
      ),
    );
  }
}
