import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/model/vehical_list_model.dart';

import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/themeData.dart';

class ConfirmBookingAddressScreen extends StatefulWidget {
  const ConfirmBookingAddressScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ConfirmBookingAddressScreenState createState() =>
      _ConfirmBookingAddressScreenState();
}

class _ConfirmBookingAddressScreenState
    extends State<ConfirmBookingAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  late Future<List<MyVehicalListModel>> vehicleList;
  late MyVehicalListModel _vehicle;
  @override
  void initState() {
    super.initState();
    // _vehicle = widget.vehicle;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
              onPress: true,
              onpress: () {
                Navigator.pushReplacementNamed(context, Routes.homeRoute);
              },
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
                padding: EdgeInsets.all(size.height * 0.03),
                child: SingleChildScrollView(
                  child: _vehicleForm(context, size),
                ),
              ),
            ),
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
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  AppStrings.cbBookyourridenow,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(flex: 1, child: _buildAddVehicalbutton(context))
            ],
          ),
          SizedBox(height: size.height * 0.03),
          _buildTextBoxEdit(),
          SizedBox(height: size.height * 0.02),
          Divider(),
          SizedBox(height: size.height * 0.02),
          Row(
            children: [
              Icon(
                Icons.home,
                color: Colors.black,
                size: 25,
              ),
              SizedBox(width: 10),
              Text(
                AppStrings.cbPickupaddresss,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(height: size.height * 0.02),
          _buildPickupAddress(),
          Divider(),
          SizedBox(height: size.height * 0.02),
          Row(
            children: [
              Icon(
                Icons.settings,
                color: Colors.black,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                AppStrings.cbDestinationaddress,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(height: size.height * 0.025),
          _buildDestinationAddress(),
          SizedBox(height: size.height * 0.025),
          ButtonWidget(
              icon: Icons.arrow_forward,
              title: AppStrings.cbProceed,
              onpress: () {
                setState(() {
                  isFirstSubmit = false;
                });
                if (_formKey.currentState!.validate()) {
                  Navigator.pushNamed(context, Routes.activateBookingScreen);
                }
              }),
          SizedBox(height: size.height * 0.025),
        ],
      ),
    );
  }

  Container _buildPickupAddress() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeClass.orangeColor,
        ),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Text(
                      'Address line 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Text(
                      'Address line 2',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Text(
                      'Land Mark',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Text(
                      'City',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Text(
                      'Pincode',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: ThemeClass.orangeColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.pickupAddressScreen);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _buildDestinationAddress() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeClass.orangeColor,
        ),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Text(
                      'Address line 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Text(
                      'Address line 2',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Text(
                      'Land Mark',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Text(
                      'City',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Text(
                      'Pincode',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: ThemeClass.orangeColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.destinationAddressScreen);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _buildTextBoxEdit() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeClass.orangeColor,
        ),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
      child: InkWell(
        onTap: () {
          // changeVehicle();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_vehicle.make} ${_vehicle.model} ",
                    // "asdasd",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${_vehicle.plateNumber}",
                    // "asdasd",
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: ThemeClass.orangeColor,
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildAddVehicalbutton(BuildContext context) {
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
          (states) => EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        ),
        elevation: MaterialStateProperty.resolveWith(
          (states) => 0,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, Routes.addVehicleScreen);
      },
      child: Center(
        child: Text(
          AppStrings.cbAddVehicle,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: ThemeClass.orangeColor,
              fontSize: 15),
        ),
      ),
    );
  }

  // changeVehicle() async {
  //   var result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SelectVehicleScreen()),
  //   );
  //   if (result != null) {
  //     setState(() {
  //       _vehicle = result;
  //     });
  //   }
  //   // print(result);
  // }
}
