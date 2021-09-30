import 'package:flutter/material.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/themeData.dart';

class TextFormFieldWdiget extends StatelessWidget {
  const TextFormFieldWdiget({
    Key? key,
    this.isPassword = false,
    required this.hintText,
    required this.controller,
    this.type,
    this.icon,
    this.textCapitalization = TextCapitalization.none,
    this.isReadOnly = false,
    this.isAllowBlank = false,
    this.showNext,
    this.onpress,
  }) : super(key: key);
  final bool isPassword;
  final bool isReadOnly;
  final bool isAllowBlank;
  final String hintText;
  final IconData? icon;
  final Function? onpress;
  final TextEditingController? controller;
  final String? type;
  final TextCapitalization textCapitalization;
  final TextInputAction? showNext;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly,
      controller: controller,
      keyboardType: type != null
          ? type == "number"
              ? TextInputType.number
              : type == "email"
                  ? TextInputType.emailAddress
                  : TextInputType.text
          : TextInputType.text,
      obscureText: isPassword,
      textCapitalization: textCapitalization,
      textInputAction: showNext,
      validator: (value) {
        if (isAllowBlank) {
          return null;
        } else {
          if (value!.isEmpty) {
            // return type == "Pickup"
            //     ? "null"
            //     : '${AppStrings.pleaseEnterValidText + " " + hintText}';
            return '${AppStrings.pleaseEnterValidText + " " + hintText}';
          } else {
            if (type != null) {
              if (type == "number") {
                final number = num.tryParse(value);
                if (number == null || value.length < 10) {
                  return AppStrings.characterIsNotNumber;
                }
              } else if (type == "password") {
                if (value.length < 8) {
                  return AppStrings.mustbeatleast8characters;
                }
              } else if (type == "email") {
                Pattern pattern =
                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                    r"{0,253}[a-zA-Z0-9])?)*$";
                RegExp regex = new RegExp(pattern.toString());
                if (!regex.hasMatch(value))
                  return AppStrings.Enteravalidemailaddress;
              } else if (type == "pincode") {
                final number = num.tryParse(value);
                if (number == null) {
                  return AppStrings.characterisnotvalideinpincode;
                }
              }
            }
          }
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: (value) {
      //   onchangeCallback!(value);
      // },
      decoration: InputDecoration(
        hintText:
            "$hintText${hintText == AppStrings.cbAutherName || hintText == AppStrings.cbLandmark ? "" : "*"}",
        suffixIcon: icon != null
            ? GestureDetector(
                child: Icon(
                  icon,
                  color: ThemeClass.orangeColor.withOpacity(0.5),
                ),
                onTap: () {
                  onpress!();
                },
              )
            : null,
        errorStyle: TextStyle(color: Color(0xff76777B)),
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 20, top: 20, right: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.outlineBorderRadius),
          borderSide: BorderSide(
            color: ThemeClass.orangeColor,
          ),
        ),
      ),
    );
  }
}
