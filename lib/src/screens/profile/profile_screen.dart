import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';

import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/customer_register_model.dart';
import 'package:pass/src/screens/add_vehical/edit_pickup_address_screen.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/edit_phone_number_dialog.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/themeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNumberEdit = false;
  bool isAddressEdit = false;

  TextEditingController numberController = TextEditingController();

  PickedFile? images;

  String? name;
  String? email;
  String? number;
  Address? address;

  String? imageurl;
  String addressToDisplay = "";
  bool isPassAvailable = false;

  late Subscription subscription;
  bool loader = false;
  togglewidget() {}

  @override
  void initState() {
    super.initState();
    getdata();
    checkSubscirption();
  }

  var maxkm = "";
  checkSubscirption() async {
    var pref = await SharedPreferences.getInstance();
    var customerId = pref.getString("customer_id").toString();
    var token = pref.getString("customer_accessToken").toString();
    var url = "customer/$customerId";

    var response = await HttpConfig().httpGetRequest(url, token.toString());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      subscription = Subscription.fromJson(body['subscription']);

      if (subscription.name == "Free Pass") {
        setState(() {
          isPassAvailable = false;
        });
      } else {
        if (subscription.totalRides! <= 0 || subscription.maxKm! <= 0) {
          setState(() {
            isPassAvailable = false;
          });
        } else {
          setState(() {
            isPassAvailable = true;
          });
        }
      }
    }
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // String addressTemp = prefs.getString("customer_pickupAddress").toString();
    name = prefs.getString("customer_username");
    email = prefs.getString("customer_email");
    number = prefs.getString("customer_mobile");
    imageurl = prefs.getString("customer_profilePicture");

    address = Address.fromJson(
        jsonDecode(prefs.getString("customer_pickupAddress").toString()));

    // print(address!.addressLine1);
    addressToDisplay =
        "${address!.originalAddress} ${address!.addressLine2} ${address!.landmark} ${address!.city} ${address!.pincode}";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: Container(
          child: Column(
            children: [
              SimpleAppBarWidget(title: AppStrings.pprofile),
              SizedBox(
                height: 60,
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF6F6F6),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          SizeConfig.topLeftRadiousForContainer),
                      topRight: Radius.circular(
                          SizeConfig.topRightRadiousForContainer),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height,
                  child:
                      SingleChildScrollView(child: _buildProfileView(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildProfileView(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Container(
                  height: 100,
                  width: 100,
                  child:
                      (imageurl == null || imageurl == "null" || imageurl == "")
                          ? Image.network(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: imageurl.toString(),
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: ThemeClass.orangeColor,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: ThemeClass.orangeColor,
                              ),
                            ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 35,
                width: 35,
                child: Card(
                  child: Center(
                    child: loader
                        ? Container(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ThemeClass.orangeColor)),
                          )
                        : IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {
                              _showPicker(context);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: ThemeClass.orangeColor,
                              size: 15,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Text(
          name ?? "",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(
          '$email',
          style: TextStyle(
            fontSize: 20,
            color: ThemeClass.orangeColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: ThemeClass.greyColor.withOpacity(0.3),
          ),
        ),
        _buildnumberwidget(),
        _buildaddressWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(context, Routes.changePassWordScreen);
            },
            minLeadingWidth: 30,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock),
              ],
            ),
            title: Text(
              AppStrings.pManagePassword,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Divider(
            color: ThemeClass.greyColor.withOpacity(0.3),
          ),
        ),
        // SizedBox(
        //   height: 200,
        // ),
        // isPassAvailable
        //     ? _buildSubscriptionWidget()
        //     : Text("please buy subscription")
      ],
    );
  }

  Column _buildSubscriptionWidget() {
    return Column(
      children: [
        Text(
          AppStrings.pActiveSubscription,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Divider(
            color: ThemeClass.greyColor.withOpacity(0.3),
          ),
        ),
        Text(
          AppStrings.pPlan1,
          // " widget.subscription.name.toString()",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Color(0x33FD6B22),
                image: DecorationImage(
                  image: AssetImage('assets/images/mask_group.png'),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Icon(
                    Icons.timer,
                    color: ThemeClass.orangeColor,
                    size: 36,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    subscription.totalRides.toString(),
                    // "as",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: ThemeClass.orangeColor,
                      fontSize: 48,
                    ),
                  ),
                  Text(
                    // AppStrings.pDaysleft,
                    AppStrings.TotalRides,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Container(
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Color(0x334EBF66),
                image: DecorationImage(
                  image: AssetImage('assets/images/speed.png'),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Icon(
                    Icons.speed,
                    color: Color(0xff4EBF66),
                    size: 36,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    subscription.maxKm!.round().toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: ThemeClass.greenColor,
                      fontSize: 48,
                    ),
                  ),
                  Text(
                    // AppStrings.pKMsleft,
                    AppStrings.TotalKm,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        // _buildButton(context),
        SizedBox(height: 50)
      ],
    );
  }

  Container _buildnumberwidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          trailing: GestureDetector(
              onTap: () {
                _editNumberPressed();
              },
              child: Icon(Icons.edit)),
          minLeadingWidth: 30,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.call),
            ],
          ),
          title: Text(
            AppStrings.pMobileNumber,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text('$number'),
        ),
      ),
    );
  }

  Container _buildaddressWidget() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          trailing: GestureDetector(
              onTap: () {
                _editAddressPressed();
              },
              child: Icon(Icons.edit)),
          minLeadingWidth: 30,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on),
            ],
          ),
          title: Text(
            AppStrings.pAddress,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(addressToDisplay != "     "
              ? addressToDisplay
              : AppStrings.pleaseenteraddress),
        ),
      ),
    );
  }

  _editNumberPressed() async {
    numberController.text = "$number";

    var result = await showDialog(
        context: context,
        builder: (context) {
          return ShowAlertDialogEditNumber(
            controller: numberController,
          );
        });

    if (result != null) {
      if (result) {
        getdata();
      }
    }
  }

  _editAddressPressed() async {
    // Navigator.pushNamed(context, Routes.pickupAddressScreen);

    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPickupAddressScreen(
                adr1: "${address!.originalAddress}",
                adr2: "${address!.addressLine2}",
                land: "${address!.landmark}",
                city: "${address!.city}",
                pincode: "${address!.pincode}",
              )),
    );
    if (result != null) {
      if (result) {
        getdata();
      }
    }
  }

  _imgFrom(ImageSource imgSource) async {
    images = await ImagePicker.platform.pickImage(
      source: imgSource,
    );

    if (images != null) {
      loader = true;
      setState(() {});
      // uploadImage();
      uploadImageToFireStore();
    }

    // setState(() {});
  }

  Future uploadImageToFireStore() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("image1" +
          DateTime.now().toString() +
          "." +
          images!.path.split(".").last);
      UploadTask uploadTask = ref.putFile(File(images!.path));

      uploadTask.then((e) async {
        var name = await e.ref.getDownloadURL();
        updateImageNameInDB(name);
      });
      // var response = await Future.wait(future);

      // var response = await Future.wait(futures);
      // var fileNamesFuture =
      //     response.map((x) => x.ref.getDownloadURL()).toList();

      // // print("response $response");
      // var filenames = await Future.wait(fileNamesFuture);
      // // print("filenames $filenames");
      // return filenames;
    } catch (err) {
      showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
    }
  }

  uploadImage() async {
    try {
      // String imageulr = await HttpConfig().httpUplaodImage(images, "image");
      String imageulr = await HttpConfig().uploadFileToFirestore(
        images!.path.toString(),
      );

      if (imageulr != "false") {
        updateImageNameInDB(imageulr);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      showSnackbarMessageGlobal(e.toString(), context);
    }
  }

  updateImageNameInDB(String imageName) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    var mapData = new Map<String, dynamic>();
    mapData['profilePicture'] = imageName;
    String custid = prefs.getString("customer_id").toString();
    String url = "customer/$custid";

    try {
      var response = await HttpConfig().httpPatchRequestWithToken(
          url, mapData, prefs.getString("customer_accessToken").toString());
      print(response);
      loader = false;
      setState(() {});
      if (response.statusCode == 201 || response.statusCode == 200) {
        showSnackbarMessageGlobal(
            AppStrings.profilesucessfullyupdated, context);
        // Navigator.pushNamed(context, Routes.homeRoute);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("customer_profilePicture", imageName);
        setState(() {
          imageurl = imageName;
        });
        // Navigator.pop(context, true);
        // Navigator.pushNamed(context, Routes.profileScreen);
      } else if (response.statusCode == 409) {
        showSnackbarMessageGlobal(AppStrings.profilenotupdated, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(AppStrings.PhotoLibrary),
                      onTap: () {
                        _imgFrom(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(AppStrings.Camera),
                    onTap: () {
                      _imgFrom(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
