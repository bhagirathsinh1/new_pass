import 'package:flutter/material.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/themeData.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {Key? key,
      required this.title,
      this.icon,
      this.isLoading = false,
      this.isDisable = false,
      required this.onpress})
      : super(key: key);

  final bool isLoading;
  final String title;
  final IconData? icon;
  final Function onpress;
  final bool isDisable;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        splashFactory: isDisable ? NoSplash.splashFactory : null,
        shadowColor: isDisable
            ? MaterialStateProperty.all<Color>(Colors.transparent)
            : null,
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.outlineBorderRadius,
            ),
          ),
        ),
        backgroundColor: !isDisable
            ? MaterialStateProperty.resolveWith(
                (states) => ThemeClass.orangeColor)
            : MaterialStateProperty.resolveWith(
                (states) => ThemeClass.greyColor.withOpacity(0.7)),
        padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.all(15),
        ),
      ),
      onPressed: () {
        if (!isDisable) {
          onpress();
        }
      },
      child: isLoading
          ? Center(
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  )))
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal *
                      Dimens.horizontalSpaceClosestWidget,
                ),
                icon != null
                    ? Icon(
                        icon,
                        size: SizeConfig.safeBlockVertical *
                            Dimens.iconFontSizeNormal,
                      )
                    : Text("")
              ],
            ),
    );
  }
}
