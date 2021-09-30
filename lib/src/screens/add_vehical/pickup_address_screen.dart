import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/customer_register_model.dart';
import 'package:pass/src/widgets/appbar_widget.dart';

import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';

import 'package:pass/src/widgets/text_form_field_widget.dart';
import 'package:pass/themeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickupAddressScreen extends StatefulWidget {
  const PickupAddressScreen({Key? key, this.address}) : super(key: key);
  final Address? address;
  @override
  _PickupAddressScreenState createState() => _PickupAddressScreenState();
}

class _PickupAddressScreenState extends State<PickupAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  bool isLoading = false;
  String long = "0";
  String latt = "0";

  TextEditingController _poriginalController = TextEditingController();

  TextEditingController _padd2Controller = TextEditingController();
  TextEditingController _plandmarkController = TextEditingController();
  TextEditingController _pcityController = TextEditingController();
  TextEditingController _ppincodeController = TextEditingController();

  TextEditingController _pAutherNameController = TextEditingController();
  TextEditingController _pAutherNumberController = TextEditingController();
  String country = "";

  @override
  void initState() {
    super.initState();
    if (widget.address!.originalAddress != null) {
      _poriginalController.text = widget.address!.originalAddress.toString();
    }
    _padd2Controller.text = widget.address!.addressLine2.toString();
    _plandmarkController.text = widget.address!.landmark.toString();
    _pcityController.text = widget.address!.city.toString();
    _ppincodeController.text = widget.address!.pincode.toString();

    if (widget.address!.authorName != null) {
      _pAutherNameController.text = widget.address!.authorName.toString();
    }
    if (widget.address!.authorMobileNumber != null) {
      _pAutherNumberController.text =
          widget.address!.authorMobileNumber.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
          child: Container(
        child: Column(
          children: [
            SimpleAppBarWidget(
              title: AppStrings.hAppTitle,
            ),
            SizedBox(
              height: 60,
            ),
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(SizeConfig.topLeftRadiousForContainer),
                    topRight:
                        Radius.circular(SizeConfig.topRightRadiousForContainer),
                  ),
                ),
                padding: EdgeInsets.all(size.height * 0.03),
                child: SingleChildScrollView(
                  child: _vehicleForm(context, size),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Form _vehicleForm(BuildContext context, Size size) {
    return Form(
      key: _formKey,
      autovalidateMode:
          !isFirstSubmit ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // SizedBox(height: size.height * 0.02),
          Row(
            children: [
              Icon(
                Icons.add_location_alt,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Text(
                AppStrings.cbPickupaddresss,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(height: size.height * 0.02),
          _buildButtonAddress(context),
          SizedBox(height: size.height * 0.025),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              _padd2Controller.text +
                  ", " +
                  _plandmarkController.text +
                  ", " +
                  _pcityController.text +
                  ", " +
                  _ppincodeController.text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          // TextFormFieldWdiget(
          //   isReadOnly: true,
          //   hintText: AppStrings.cbAddressline2,
          //   controller: _padd2Controller,
          // ),
          // SizedBox(height: size.height * 0.025),
          // TextFormFieldWdiget(
          //   type: "Pickup",
          //   hintText: AppStrings.cbLandmark,
          //   controller: _plandmarkController,
          // ),
          // SizedBox(height: size.height * 0.025),
          // Row(
          //   children: [
          //     Flexible(
          //       child: TextFormFieldWdiget(
          //         isAllowBlank: true,
          //         hintText: AppStrings.cbCity,
          //         controller: _pcityController,
          //         isReadOnly: true,
          //       ),
          //     ),
          //     SizedBox(
          //       width: 15,
          //     ),
          //     Flexible(
          //       child: TextFormFieldWdiget(
          //         isAllowBlank: true,
          //         hintText: AppStrings.cbPincode,
          //         type: "pincode",
          //         isReadOnly: true,
          //         controller: _ppincodeController,
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 40),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              AppStrings.cbAuther + ":",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          TextFormFieldWdiget(
            type: "Pickup",
            hintText: AppStrings.cbAutherName,
            controller: _pAutherNameController,
          ),
          SizedBox(height: size.height * 0.025),
          TextFormFieldWdiget(
            type: "number",
            hintText: AppStrings.cbAutherNumber,
            controller: _pAutherNumberController,
          ),

          SizedBox(height: size.height * 0.03),
          ButtonWidget(
              // isDisable: checkIsDisable(),
              isLoading: isLoading,
              icon: Icons.arrow_forward,
              title: AppStrings.cbProceed,
              onpress: () {
                setState(() {
                  isFirstSubmit = false;
                });
                if (_formKey.currentState!.validate()) {
                  updatePickupAddress();
                }
              }),
          SizedBox(height: size.height * 0.025),
        ],
      ),
    );
  }

  bool checkIsDisable() {
    return _padd2Controller.text == '' ||
        _pcityController.text == '' ||
        _plandmarkController.text == '' ||
        _ppincodeController.text == '' ||
        // _poriginalController.text == '' ||
        _pAutherNameController.text == '' ||
        _pAutherNumberController.text == '';
  }

  ElevatedButton _buildButtonAddress(
    BuildContext context,
  ) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.outlineBorderRadius,
            ),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => Color(0xffFEDED4),
        ),
        padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.only(left: 13, right: 13, top: 5, bottom: 5),
        ),
        elevation: MaterialStateProperty.resolveWith(
          (states) => 0,
        ),
      ),
      onPressed: handleOnTapSearch,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: TextFormField(
              enabled: false,
              controller: _poriginalController,
              // validator: (value) {
              //   if (value == "") {
              //     return "Please select address.";
              //   }
              // },
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.location_on,
                  color: ThemeClass.orangeColor,
                ),
                hintText: AppStrings.cbChooseaddress,
                hintStyle: TextStyle(fontSize: 16),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 15, top: 15, right: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  extractDetails(Prediction prediction) async {
    GoogleMapsPlaces _places =
        GoogleMapsPlaces(apiKey: AppStrings.kGoogleApiKey);
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId.toString());

    _padd2Controller.text = detail.result.name;
    detail.result.addressComponents.forEach((element) {
      debugPrint(
          "::ADDRESS COMPONENTS::: ${element.longName}::::${element.types}");
      if (element.types.contains('country')) {
        country = element.longName.toLowerCase();
      }
      if (element.types.contains('landmark')) {
        _plandmarkController.text = element.longName;
      }

      if (element.types.contains('locality') &&
          element.types.contains('political')) {
        _pcityController.text = element.longName;
      }
      if (element.types.contains('postal_code')) {
        _ppincodeController.text = element.longName;
      }
    });
    _poriginalController.text = detail.result.formattedAddress!;
    debugPrint(":::::::lat ${detail.result.geometry!.location.lat.toString()}");
    debugPrint(":::::::lng ${detail.result.geometry!.location.lng.toString()}");
    long = detail.result.geometry!.location.lng.toString();
    latt = detail.result.geometry!.location.lat.toString();
    setState(() {});
  }

  Future<void> handleOnTapSearch() async {
    Locale myLocale = Localizations.localeOf(context);
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      strictbounds: false,
      region: "IN", //myLocale.countryCode.toString()
      apiKey: AppStrings.kGoogleApiKey,
      mode: Mode.overlay,
      language: "en",
      types: [],
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "IN")],

      ///myLocale.countryCode.toString()
    );
    if (p != null) {
      extractDetails(p);
    }
  }

  void updatePickupAddress() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    var mapData = new Map<String, dynamic>();

    var address = Address(
        addressLine2: _padd2Controller.text,
        landmark: _plandmarkController.text,
        city: _pcityController.text,
        pincode: _ppincodeController.text,
        authorName: _pAutherNameController.text,
        authorMobileNumber: _pAutherNumberController.text,
        lat: latt,
        long: long,
        country: country,
        originalAddress: _poriginalController.text);
    mapData['pickupAddress'] = address;
    String custid = prefs.getString("customer_id").toString();
    String url = "customer/$custid";

    // print("object $mapData");
    // print("customer id : ${prefs.getString("customer_id").toString()}");

    try {
      var response = await HttpConfig().httpPatchRequestWithToken(
          url, mapData, prefs.getString("customer_accessToken").toString());
      if (response.statusCode == 201 || response.statusCode == 200) {
        showSnackbarMessageGlobal(
            AppStrings.Addresssucessfullyupdated, context);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('customer_pickupAddress', jsonEncode(address));
        // Navigator.pushNamed(context, Routes.profileScreen);
        Navigator.pop(context, true);
      } else if (response.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.Addressnotupdated, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      setState(() => isLoading = false);
    }
  }
}
