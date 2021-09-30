import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/add_vehical_model.dart';
import 'package:pass/src/widgets/appbar_widget.dart';

import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/src/widgets/text_form_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({Key? key}) : super(key: key);

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirstSubmit = true;
  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _licenceController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
          child: Container(
        child: Column(
          children: [
            SimpleAppBarWidget(
              title: AppStrings.aAddVehicle,
            ),
            SizedBox(
              height: 60,
            ),
            Flexible(
              child: Container(
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
                height: MediaQuery.of(context).size.height,
                // padding: EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: _vehicleForm(context),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget _vehicleForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Form(
        key: _formKey,
        autovalidateMode: !isFirstSubmit
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  AppStrings.aEnteryourvehicledetails,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            TextFormFieldWdiget(
              controller: _brandController,
              textCapitalization: TextCapitalization.words,
              hintText: AppStrings.aEnteryourvehiclebrand,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormFieldWdiget(
              textCapitalization: TextCapitalization.words,
              controller: _modelController,
              hintText: AppStrings.aEnteryourmodelnumber,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormFieldWdiget(
              textCapitalization: TextCapitalization.words,
              controller: _licenceController,
              hintText: AppStrings.aLicensePlate,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormFieldWdiget(
              textCapitalization: TextCapitalization.words,
              controller: _colorController,
              hintText: AppStrings.aColor,
            ),
            SizedBox(
              height: 20,
            ),
            ButtonWidget(
              isLoading: isLoading,
              title: AppStrings.aAddVehicle,
              onpress: () {
                addVehical();
              },
            ),
          ],
        ),
      ),
    );
  }

  void addVehical() {
    setState(() {
      isFirstSubmit = false;
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      addVehicalToApi();
    }
  }

  void addVehicalToApi() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    var data = AddVehicalModel(
      make: _brandController.text.trim(),
      model: _modelController.text.trim(),
      plateNumber: _licenceController.text.trim(),
      color: _colorController.text.trim(),
      customerId: prefs.getString("customer_id"),
    );

    String url = "vehicle";
    try {
      var response = await HttpConfig().httpPostRequestWithToken(
        url,
        data,
        prefs.getString("customer_accessToken").toString(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        showSnackbarMessageGlobal(
            AppStrings.Newvehicleaddedsuccessfully, context);
        Navigator.pushReplacementNamed(context, Routes.homeRoute);
      } else if (response.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
