import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
// import 'package:pass/src/model/customer_model.dart';

import 'package:pass/src/model/customer_register_model.dart';
import 'package:pass/src/model/vehical_list_model.dart';
import 'package:pass/src/notification_service/notification_service.dart';
import 'package:pass/src/screens/add_vehical/activate_booking_screen.dart';
import 'package:pass/src/screens/add_vehical/already_have_subcription.dart';
import 'package:pass/src/screens/add_vehical/available_slots_screen.dart';

import 'package:pass/src/screens/add_vehical/destination_address_screen.dart';
import 'package:pass/src/screens/add_vehical/pickup_address_screen.dart';
import 'package:pass/src/screens/add_vehical/select_vehical_screen.dart';
import 'package:pass/src/service/navigator_service.dart';

import 'package:pass/src/service/vehicle_service.dart';
import 'package:pass/src/shared_preferance/shared_pref_service.dart';
import 'package:pass/src/widgets/appbar_with_icon_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';

import 'package:pass/themeData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, this.vehicle}) : super(key: key);
  final MyVehicalListModel? vehicle;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late VehicleService vehicleService;

  // late Future<List<MyVehicalListModel>> vehicleList;
  var isInit = true;

  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  bool isloading = false;

  Address? pickupAddressObject;
  Address? destinationAddressObject;
  MyVehicalListModel? _vehicle;
  late List<MyVehicalListModel> vehicleList;
  getaddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temppickAddress =
        jsonDecode(prefs.getString('customer_pickupAddress').toString());

    var tempdestiAddress =
        jsonDecode(prefs.getString('customer_destinationAddress').toString());
    setState(() {
      pickupAddressObject = Address.fromJson(temppickAddress);
      destinationAddressObject = Address.fromJson(tempdestiAddress);
    });
  }

  @override
  void initState() {
    if (widget.vehicle != null) {
      _vehicle = widget.vehicle;
    }
    super.initState();
    getaddress();
  }

  iniateNotificaiton(BuildContext context) {
    try {
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        navigationService.navigationKey.currentState!.pushNamed(
          Routes.bookingDetailsScreen,
          arguments: {
            'bookingId': message.data["bookingId"],
            'foromHomePage': true,
          },
        );
      });
      SharedPreferences.getInstance().then((prefs) {
        PushNotificationsHandler.initializeNotification(
            prefs.get('customer_id').toString(), context);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    iniateNotificaiton(context);
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
          child: Container(
        child: Column(
          children: [
            SimpleAppBar(
              title: AppStrings.hAppTitle,
              globalScafoldKey: _scaffoldKey,
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
                padding: EdgeInsets.all(20.0),
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  // physics: ScrollPhysics(),
                  child: _buildVehicalList(size),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Column _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 150,
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            // width: MediaQuery.of(context).size.width * 0.5,
            child: Image.asset(
              'assets/images/bike.png',
              fit: BoxFit.fill,
            )),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Text(
            AppStrings.hPleaseaddyour,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ButtonWidget(
              title: AppStrings.hAddVehicle, onpress: navigateTonew),
        ),
      ],
    );
  }

  _buildVehicalList(size) {
    return Consumer<VehicleService>(
        builder: (BuildContext context, model, child) {
      return FutureBuilder(
        future: model.getVehicleList(),
        builder: (context, AsyncSnapshot<List<MyVehicalListModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.length > 0) {
                vehicleList = snapshot.data!;
                if (_vehicle == null) {
                  _vehicle = snapshot.data!.first;
                }

                return _vehicleForm(context, size);
              } else {
                return _buildBody(context);
              }
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(
                    color: ThemeClass.orangeColor,
                  ),
                ),
              );
            }
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(
                  color: ThemeClass.orangeColor,
                ),
              ),
            );
          }
        },
      );
    });
  }

  bool enableProceedButton() {
    return pickupAddressObject != null &&
        pickupAddressObject!.originalAddress == '' &&
        destinationAddressObject != null &&
        destinationAddressObject!.originalAddress == '' &&
        _vehicle != null &&
        _vehicle!.id == '';
  }

  Form _vehicleForm(BuildContext context, Size size) {
    return Form(
      key: _formKey,
      autovalidateMode:
          !isFirstSubmit ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                AppStrings.cbBookyourridenow,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Expanded(flex: 1, child: _buildAddVehicalbutton(context))
            ],
          ),
          SizedBox(height: size.height * 0.03),
          Row(
            children: [
              Icon(
                Icons.two_wheeler,
                color: Colors.black,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                AppStrings.cbSelectVehicle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(height: size.height * 0.02),
          _buildTextBoxEdit(),
          !isFirstSubmit
              ? _vehicle == null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(AppStrings.pleaseselectvehicle)),
                    )
                  : SizedBox()
              : SizedBox(),
          SizedBox(height: size.height * 0.02),
          Row(
            children: [
              Icon(
                Icons.home,
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
          _buildPickupAddress(),
          SizedBox(height: size.height * 0.02),
          Row(
            children: [
              Icon(
                Icons.location_on,
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
          SizedBox(height: size.height * 0.020),
          _buildDestinationPickupAddress(),
          SizedBox(height: size.height * 0.025),
          ButtonWidget(
              isLoading: isloading,
              icon: Icons.arrow_forward,
              title: AppStrings.cbProceed,
              onpress: () {
                isFirstSubmit = false;

                if (_formKey.currentState!.validate()) {
                  _formSubmiting();
                }
              }),
          SizedBox(height: size.height * 0.025),
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
        onTap: changeVehicle,
        child: _vehicle == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.pleaseselectvehicle,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: ThemeClass.orangeColor,
                    ),
                    onPressed: changeVehicle,
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_vehicle!.make} ${_vehicle!.model}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${_vehicle!.plateNumber}",
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
      child: (pickupAddressObject == null ||
              pickupAddressObject!.originalAddress == "")
          ? _pickupAddressTextBoxIsEmpty()
          : _pickupAddressTextBox(pickupAddressObject),
    );
  }

  Container _buildDestinationPickupAddress() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeClass.orangeColor,
        ),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
      child: (destinationAddressObject == null ||
              destinationAddressObject!.originalAddress == "")
          ? _destinationAddressTextBoxIsEmpty()
          : _desitnationAddressTextBox(destinationAddressObject),
    );
  }

  InkWell _pickupAddressTextBoxIsEmpty() {
    return InkWell(
      onTap: () {
        getpickupAddress(pickupAddressObject);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppStrings.Pleaseselectpickupaddress,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: ThemeClass.orangeColor,
            ),
            onPressed: () {
              getpickupAddress(pickupAddressObject);
            },
          )
        ],
      ),
    );
  }

  Row _destinationAddressTextBoxIsEmpty() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // "${_vehicle.make} ${_vehicle.model} ",
                  AppStrings.Pleaseselectdestinationaddress,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: ThemeClass.orangeColor,
          ),
          onPressed: () {
            getdestinationAddress(destinationAddressObject);
          },
        )
      ],
    );
  }

  Row _pickupAddressTextBox(Address? address) {
    return Row(
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
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Text(
                    "${address!.addressLine2}",
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
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 3),
                  child: Text(
                    "${address.landmark}",
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
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 3),
                  child: Text(
                    "${address.city}, ${address.pincode}",
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
                getpickupAddress(address);
              },
            ),
          ],
        )
      ],
    );
  }

  Row _desitnationAddressTextBox(Address? address) {
    return Row(
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
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Text(
                    "${address!.addressLine2}",
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
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 3),
                  child: Text(
                    "${address.landmark}",
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
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 3),
                  child: Text(
                    "${address.city}, ${address.pincode}",
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
                getdestinationAddress(address);
              },
            ),
          ],
        )
      ],
    );
  }

  // ElevatedButton _buildAddVehicalbutton(BuildContext context) {
  //   return ElevatedButton(
  //     style: ButtonStyle(
  //       shape: MaterialStateProperty.resolveWith(
  //         (states) => RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(
  //             Dimens.outlineBorderRadius,
  //           ),
  //         ),
  //       ),
  //       backgroundColor: MaterialStateProperty.resolveWith(
  //         (states) => Color(0xffFEDED4),
  //       ),
  //       padding: MaterialStateProperty.resolveWith(
  //         (states) => EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
  //       ),
  //       elevation: MaterialStateProperty.resolveWith(
  //         (states) => 0,
  //       ),
  //     ),
  //     onPressed: () {
  //       Navigator.pushNamed(context, Routes.addVehicleScreen);
  //     },
  //     child: Center(
  //       child: Text(
  //         AppStrings.cbAddVehicle,
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //             fontWeight: FontWeight.w600,
  //             color: ThemeClass.orangeColor,
  //             fontSize: 15),
  //       ),
  //     ),
  //   );
  // }

  navigateTonew() {
    Navigator.pushNamed(context, Routes.addVehicleScreen);
  }

  changeVehicle() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectVehicleScreen(
                vehicleList: vehicleList,
              )),
    );
    if (result != null) {
      setState(() {
        _vehicle = result;
      });
    }
  }

  getpickupAddress(address) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PickupAddressScreen(address: address),
      ),
    );

    if (result != null) {
      getaddress();
    }
  }

  getdestinationAddress(address) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DestinationAddressScreen(address: address),
      ),
    );

    if (result != null) {
      getaddress();
    }
  }

  _formSubmiting() async {
    setState(() {
      isloading = true;
    });

    if (_vehicle == null) {
      showSnackbarMessageGlobal(AppStrings.pleaseselectvehicle, context);
    } else if (pickupAddressObject == null ||
        pickupAddressObject!.originalAddress == "") {
      showSnackbarMessageGlobal(AppStrings.Invalidpickupaddress, context);
    } else if (destinationAddressObject == null ||
        destinationAddressObject!.originalAddress == "") {
      showSnackbarMessageGlobal(AppStrings.InvalidDestinationaddress, context);
    } else if (pickupAddressObject!.authorName == null ||
        destinationAddressObject!.authorName == "") {
      showSnackbarMessageGlobal(AppStrings.pleaseSelectAutherName, context);
    } else if (pickupAddressObject!.authorMobileNumber == null ||
        destinationAddressObject!.authorMobileNumber == "") {
      showSnackbarMessageGlobal(AppStrings.pleaseSelectAutherNumber, context);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AvailableSlotsScreen(
            vehicle: _vehicle,
            // pickupAddress: pickupAddressObject,
            // destinationAddress: destinationAddressObject,
          ),
        ),
      );

      // var pref = await SharedPreferences.getInstance();
      // var customerId = pref.getString("customer_id").toString();
      // var token = pref.getString("customer_accessToken").toString();
      // var url = "customer/$customerId";

      // var response = await HttpConfig().httpGetRequest(url, token.toString());

      // if (response.statusCode == 200) {
      //   // List<CustomerModel> =[];
      //   final body = json.decode(response.body);
      //   // body['s']

      // var subscription = Subscription.fromJson(body['subscription']);

      //   await SharedPrefService.setSubscription(subscription);

      //   if (subscription.name == "Free Pass") {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) => ActivateBookingScreen(
      //           vehicle: _vehicle,
      //           pickupAddress: pickupAddressObject,
      //           destinationAddress: destinationAddressObject,
      //         ),
      //       ),
      //     );
      //   } else {
      //     if (subscription.totalRides! <= 0 || subscription.maxKm! <= 0) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => ActivateBookingScreen(
      //             vehicle: _vehicle,
      //             pickupAddress: pickupAddressObject,
      //             destinationAddress: destinationAddressObject,
      //           ),
      //         ),
      //       );
      //     } else {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => AlreadyHaveSubscription(
      //             subscription: subscription,
      //             vehicle: _vehicle,
      //             pickupAddress: pickupAddressObject,
      //             destinationAddress: destinationAddressObject,
      //           ),
      //         ),
      //       );
      //     }
      //   }
      // }
    }
    setState(() {
      isloading = false;
    });
  }
}
