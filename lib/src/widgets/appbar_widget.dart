import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key, required this.title, this.onpress})
      : super(key: key);
  final String title;
  final Function? onpress;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      snap: false,
      floating: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      expandedHeight: 100,
      collapsedHeight: 100,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            IconButton(
              splashColor: Colors.transparent,
              icon: Icon(
                Icons.dangerous,
                color: Colors.transparent,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleAppBarWidget extends StatelessWidget {
  const SimpleAppBarWidget(
      {Key? key, required this.title, this.onpress, this.onPress = false})
      : super(key: key);
  final String title;
  final VoidCallback? onpress;
  final bool onPress;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: onPress
                  ? onpress
                  : () {
                      Navigator.pop(context);
                    },
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              splashColor: Colors.transparent,
              icon: Icon(Icons.dangerous, color: Colors.transparent),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
