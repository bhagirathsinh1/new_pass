import 'package:flutter/material.dart';

class BackgraoundGradient extends StatelessWidget {
  const BackgraoundGradient({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        // decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splaceScreenBackgroundImage.png'),
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
