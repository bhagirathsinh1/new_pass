import 'package:flutter/material.dart';
import 'package:pass/routes.dart';

class AppBarWithIconWidget extends StatelessWidget {
  const AppBarWithIconWidget(
      {Key? key,
      this.isNotificationScreen = false,
      this.isProfileScreen = false,
      required this.title,
      required this.globalScafoldKey})
      : super(key: key);
  final String title;
  final bool isNotificationScreen;
  final bool isProfileScreen;
  final GlobalKey<ScaffoldState> globalScafoldKey;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      snap: false,
      floating: false,
      elevation: 0,
      expandedHeight: 100,
      automaticallyImplyLeading: false,
      collapsedHeight: 100,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isProfileScreen
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      globalScafoldKey.currentState!.openDrawer();
                    },
                  ),
            Text(
              title,
              style: TextStyle(fontSize: 26),
            ),
            IconButton(
              onPressed: () {
                if (!isNotificationScreen) {
                  Navigator.pushNamed(context, Routes.notificationScreen);
                }
                // Navigator.push(
              },
              icon: Icon(Icons.notifications),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleAppBar extends StatelessWidget {
  const SimpleAppBar(
      {Key? key,
      this.isNotificationScreen = false,
      this.isProfileScreen = false,
      required this.title,
      required this.globalScafoldKey})
      : super(key: key);
  final String title;
  final bool isNotificationScreen;
  final bool isProfileScreen;
  final GlobalKey<ScaffoldState> globalScafoldKey;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Container(
        padding: EdgeInsets.only(
          top: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isProfileScreen
                ? SizedBox(
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                : SizedBox(
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        globalScafoldKey.currentState!.openDrawer();
                      },
                    ),
                  ),
            Text(
              title,
              style: TextStyle(fontSize: 26),
            ),
            SizedBox(
              width: 30,
            ),
            // IconButton(
            //   onPressed: () {
            //     if (!isNotificationScreen) {
            //       Navigator.pushNamed(context, Routes.notificationScreen);
            //     }
            //     // Navigator.push(
            //   },
            //   icon: Icon(Icons.notifications),
            // ),
          ],
        ),
      ),
    );
  }
}
