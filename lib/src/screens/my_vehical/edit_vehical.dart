import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/add_vehical_model.dart';
import 'package:pass/src/model/vehical_list_model.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/themeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditVehicleScreen extends StatefulWidget {
  const EditVehicleScreen({Key? key, required this.vehicle}) : super(key: key);
  final MyVehicalListModel vehicle;
  @override
  _EditVehicleScreenState createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirstSubmit = true;
  // late TextEditingController _brandController;
  // late TextEditingController _modelController;
  // late TextEditingController _licenceController;

  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _licenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.vehicle.make);
    print(widget.vehicle.model);
    print(widget.vehicle.plateNumber);

    _brandController.text = "${widget.vehicle.make}";
    _modelController.text = "${widget.vehicle.model}";
    _licenceController.text = "${widget.vehicle.plateNumber}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: CustomScrollView(
          slivers: <Widget>[
            AppBarWidget(
              title: AppStrings.aEditVehicle,
            ),
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
                    height: MediaQuery.of(context).size.height,
                    // padding: EdgeInsets.all(40.0),
                    child: _vehicleForm(context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
              height: 20,
            ),
            TextFormField(
              controller: _brandController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '${AppStrings.pleaseEnterValidText + " " + AppStrings.aEnteryourvehiclebrand}';
                }
              },
              decoration: InputDecoration(
                hintText: AppStrings.aEnteryourvehiclebrand + "*",
                errorStyle: TextStyle(color: Color(0xff76777B)),
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 20, top: 20, right: 15),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Dimens.outlineBorderRadius),
                  borderSide: BorderSide(
                    color: ThemeClass.orangeColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _modelController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '${AppStrings.pleaseEnterValidText + " " + AppStrings.aEnteryourmodelnumber}';
                }
              },
              decoration: InputDecoration(
                hintText: AppStrings.aEnteryourmodelnumber + "*",
                errorStyle: TextStyle(color: Color(0xff76777B)),
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 20, top: 20, right: 15),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Dimens.outlineBorderRadius),
                  borderSide: BorderSide(
                    color: ThemeClass.orangeColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _licenceController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '${AppStrings.pleaseEnterValidText + " " + AppStrings.aLicensePlate}';
                }
              },
              decoration: InputDecoration(
                hintText: AppStrings.aLicensePlate + "*",
                errorStyle: TextStyle(color: Color(0xff76777B)),
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 20, top: 20, right: 15),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Dimens.outlineBorderRadius),
                  borderSide: BorderSide(
                    color: ThemeClass.orangeColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ButtonWidget(
                isLoading: isLoading,
                title: AppStrings.aEditVehicle,
                onpress: () {
                  editVehical();
                }),
          ],
        ),
      ),
    );
  }

  void editVehical() {
    setState(() {
      isFirstSubmit = false;
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      showAlertDialogGlobal(
          AppStrings.Confirmation, AppStrings.Areyousuretoedit, context, () {
        editVehicalToApi();
      });
    }
  }

  void editVehicalToApi() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    var data = AddVehicalModel(
        make: _brandController.text,
        model: _modelController.text,
        plateNumber: _licenceController.text,
        customerId: prefs.getString("customer_id"));

    String url = "vehicle/" + "${widget.vehicle.id}";
    try {
      var response = await HttpConfig().httpPatchRequestWithToken(
          url, data, prefs.getString("customer_accessToken").toString());
      print("response ===> ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        showSnackbarMessageGlobal(
            AppStrings.VehicleUpdatedSucessfully, context);
        Navigator.pushReplacementNamed(context, Routes.homeRoute);
      } else if (response.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.Vehiclenotupdated, context);
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
