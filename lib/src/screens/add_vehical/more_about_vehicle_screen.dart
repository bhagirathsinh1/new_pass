import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:pass/routes.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/customer_register_model.dart';
import 'package:pass/src/model/vehical_list_model.dart';
import 'package:pass/src/screens/add_vehical/activate_booking_screen.dart';
import 'package:pass/src/screens/add_vehical/booking_exceed_buy_subscription_screen.dart';
import 'package:pass/src/shared_preferance/shared_pref_service.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/full_screen_image_view.dart';

import 'package:pass/src/widgets/snack_bar_widget.dart';

import 'package:pass/themeData.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreAboutVehicle extends StatefulWidget {
  MoreAboutVehicle({Key? key}) : super(key: key);

  @override
  _MoreAboutVehicleState createState() => _MoreAboutVehicleState();
}

class _MoreAboutVehicleState extends State<MoreAboutVehicle> {
  bool firstCheck1 = false;
  bool firstCheck2 = false;

  bool secCheck1 = false;
  bool secCheck2 = false;

  bool thirdCheck1 = false;
  bool thirdCheck2 = false;

  bool forthCheck1 = false;
  bool forthCheck2 = false;

  bool isLoading = false;

  late MyVehicalListModel? vehicle;
  late Address? pickupAddress;
  late Address? destinationAddress;

  List<PickedFile>? images = [];
  List<String> _imageNameToUPload = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _notesController = TextEditingController();
  bool isFirstSubmit = true;

  void _togglecheck1(bool? val, String type) {
    if (val != null) {
      if (type == "yes") {
        setState(() {
          firstCheck1 = !firstCheck1;
          firstCheck2 = false;
        });
      } else {
        setState(() {
          firstCheck1 = false;
          firstCheck2 = !firstCheck2;
        });
      }
    }
  }

  void _togglecheck2(bool? val, String type) {
    if (val != null) {
      if (type == "yes") {
        setState(() {
          secCheck1 = !secCheck1;
          secCheck2 = false;
        });
      } else {
        setState(() {
          secCheck1 = false;
          secCheck2 = !secCheck2;
        });
      }
    }
  }

  void _togglecheck3(bool? val, String type) {
    if (val != null) {
      if (type == "yes") {
        setState(() {
          thirdCheck1 = !thirdCheck1;
          thirdCheck2 = false;
        });
      } else {
        setState(() {
          thirdCheck1 = false;
          thirdCheck2 = !thirdCheck2;
        });
      }
    }
  }

  void _togglecheck4(bool? val, String type) {
    if (val != null) {
      if (type == "yes") {
        setState(() {
          forthCheck1 = !forthCheck1;
          forthCheck2 = false;
        });
      } else {
        // images = [];
        setState(() {
          forthCheck1 = false;
          forthCheck2 = !forthCheck2;
        });
      }
    }
  }

  _imgFromGallery(ImageSource imageSource) async {
    List<PickedFile>? imagesTemp = [];
    if (imageSource == ImageSource.gallery) {
      // ignore: invalid_use_of_visible_for_testing_member
      imagesTemp = await ImagePicker.platform.pickMultiImage();
    } else {
      PickedFile? pickedFile =
          // ignore: invalid_use_of_visible_for_testing_member
          await ImagePicker.platform.pickImage(source: ImageSource.camera);
      imagesTemp.add(pickedFile!);
    }

    setState(() {
      if (imagesTemp != null) {
        imagesTemp.forEach((element) {
          images!.add(element);
        });
      }

      // images!.addAll(imagesTemp);
    });
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
                        _imgFromGallery(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(AppStrings.Camera),
                    onTap: () {
                      _imgFromGallery(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _removeImageFromList(index) {
    setState(() {
      images!.removeAt(index);
    });
  }

  dynamic selectedSlot;

  @override
  Widget build(BuildContext context) {
    // final _vehicle =
    //     ModalRoute.of(context)!.settings.arguments as MyVehicalListModel;

    var resData = ModalRoute.of(context)!.settings.arguments as dynamic;
    final slotdata = resData[0];
    // vehicle = resData[1];
    // pickupAddress = resData[2];
    // destinationAddress = resData[3];

    // vehicle = _vehicle;
    selectedSlot = slotdata;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: Container(
          child: Column(
            children: [
              SimpleAppBarWidget(title: AppStrings.maTellUsMoreAboutBike),
              SizedBox(
                height: 60,
              ),
              Flexible(
                child: _buildSliverList(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isButtonDisabled() {
    if ((firstCheck1 || firstCheck2) &&
        (secCheck1 || secCheck2) &&
        (thirdCheck1 || thirdCheck2)) {
      if (forthCheck1 && images != null && images!.length > 0) {
        return false;
      } else if (forthCheck2) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  _buildSliverList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.84,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.topLeftRadiousForContainer),
          topRight: Radius.circular(SizeConfig.topRightRadiousForContainer),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            _buildForm(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ButtonWidget(
                  isLoading: isLoading,
                  isDisable: isButtonDisabled(),
                  title: AppStrings.maContinue,
                  icon: Icons.arrow_forward,
                  onpress: () {
                    setState(() {
                      isFirstSubmit = false;
                    });
                    if (_formKey.currentState!.validate()) {
                      // Navigator.pushNamed(
                      //     context, Routes.confirmationScreen);
                      // createBooking(context);
                      checkSubscirption(context);
                      // checkDriverAvailableOrNot(context);
                    }
                  }),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
        autovalidateMode: !isFirstSubmit
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.maSelectaoption,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          AppStrings.maRegisteredmotorbike,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppStrings.maInsuredmotorbike,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppStrings.maWorkingmotorbike,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppStrings.maDamagedmotorbike,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          AppStrings.maYes,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _buildCheckBox(firstCheck1, (vale) {
                          _togglecheck1(vale, "yes");
                        }),
                        SizedBox(
                          height: 14,
                        ),
                        _buildCheckBox(secCheck1, (vale) {
                          _togglecheck2(vale, "yes");
                        }),
                        SizedBox(
                          height: 14,
                        ),
                        _buildCheckBox(thirdCheck1, (vale) {
                          _togglecheck3(vale, "yes");
                        }),
                        SizedBox(
                          height: 14,
                        ),
                        _buildCheckBox(forthCheck1, (vale) {
                          _togglecheck4(vale, "yes");
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          AppStrings.maNo,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _buildCheckBox(firstCheck2, (vale) {
                          _togglecheck1(vale, "no");
                        }),
                        SizedBox(
                          height: 14,
                        ),
                        _buildCheckBox(secCheck2, (vale) {
                          _togglecheck2(vale, "no");
                        }),
                        SizedBox(
                          height: 14,
                        ),
                        _buildCheckBox(thirdCheck2, (vale) {
                          _togglecheck3(vale, "no");
                        }),
                        SizedBox(
                          height: 14,
                        ),
                        _buildCheckBox(forthCheck2, (vale) {
                          _togglecheck4(vale, "no");
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            forthCheck1 == true
                ? Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.maIfyesthenuploadaphoto,
                          style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: 15),
                      forthCheck2 == true
                          ? Text("")
                          : images != null
                              ? images!.length > 0
                                  ? Column(
                                      children: images!.map((e) {
                                        var index = images!.indexOf(e);

                                        return _buildimageName(index, context);
                                      }).toList(),
                                    )
                                  : Text("")
                              : Text(""),
                      ButtonWidget(
                        // isDisable: firstCheck1 == true ||
                        //         secCheck1 == true ||
                        //         thirdCheck1 == true ||
                        //         forthCheck1 == true
                        //     ? false
                        //     : true,
                        isDisable: false,
                        title: AppStrings.maUploadPhoto,

                        onpress: () {
                          _showPicker(context);
                          // Navigator.pushNamed(context, Routes.confirmationScreen);
                        },
                      ),
                      SizedBox(height: 10),
                      Divider(),
                    ],
                  )
                : Container(),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.maNote,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _notesController,
              maxLines: 8,
              // validator: (value) {
              //   if (forthCheck1) {
              //     if (value == "") {
              //       return "Please enter notes";
              //     }
              //   }
              // },
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                errorStyle: TextStyle(color: Color(0xff76777B)),
                hintText: AppStrings.maGiveussomeinformation,
                hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
                contentPadding: EdgeInsets.all(20.0),
                fillColor: Color(0x22FD6B22),
                filled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildimageName(int index, BuildContext context) {
    var fileName = basename(images![index].path);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                fileName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: ThemeClass.orangeColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        Center(
          child: IconButton(
            onPressed: () {
              // _removeImageFromList(index);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImageView(path: images![index].path),
                ),
              );
            },
            icon: Icon(Icons.remove_red_eye),
            color: ThemeClass.greyColor,
          ),
        ),
        Center(
          child: IconButton(
            onPressed: () {
              _removeImageFromList(index);
            },
            icon: Icon(
              Icons.cancel,
            ),
            color: ThemeClass.orangeColor,
          ),
        )
      ],
    );
  }

  SizedBox _buildCheckBox(bool value, Function onchange) {
    return SizedBox(
      height: 30,
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: ThemeClass.orangeColor,
          accentColor: ThemeClass.orangeColor,
        ),
        child: Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          tristate: false,
          onChanged: (vale) {
            onchange(vale);
          },
          value: value,
        ),
      ),
    );
  }

  checkSubscirption(context) async {
    setState(() {
      isLoading = true;
    });
    // await uploadImage(context);

    var uploadedImages = await uploadImageToFireStore(context);
    selectedSlot['registeredMotorbike'] =
        firstCheck1 ? firstCheck1 : firstCheck2;
    selectedSlot['insuredMotorbike'] = secCheck1 ? secCheck1 : secCheck2;
    selectedSlot['workingMotorbike'] = thirdCheck1 ? thirdCheck1 : thirdCheck2;
    selectedSlot['damagedMotorbike'] = forthCheck1 ? forthCheck1 : forthCheck2;
    selectedSlot['notes'] = _notesController.text;
    selectedSlot['customerImages'] = uploadedImages;

    var pref = await SharedPreferences.getInstance();
    var customerId = pref.getString("customer_id").toString();
    var token = pref.getString("customer_accessToken").toString();
    var url = "customer/$customerId";

    var response = await HttpConfig().httpGetRequest(url, token.toString());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      var subscription = Subscription.fromJson(body['subscription']);
      var isUnlimited = body['unlimitedRides'];

      // await SharedPrefService.setSubscription(subscription);
      if (isUnlimited == true || isUnlimited == "true") {
        checkDriverAvailableOrNot(context);
      } else {
        if (subscription.name == "Free Pass") {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ActivateBookingScreen(selectedSlot: selectedSlot),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          if (subscription.totalRides! <= 0 || subscription.maxKm! <= 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ActivateBookingScreen(selectedSlot: selectedSlot),
              ),
            );
          } else {
            // createBooking(context);
            checkDriverAvailableOrNot(context);
          }
        }
      }
    }
  }

  checkDriverAvailableOrNot(BuildContext context) async {
    var pref = await SharedPreferences.getInstance();

    // ! check driver available or not api

    print(selectedSlot);
    var response = await HttpConfig().httpPostRequestWithToken(
      'booking/check-driver-available',
      selectedSlot,
      pref.getString("customer_accessToken").toString(),
    );

    if (response.statusCode == 201) {
      // checkSubscirption(context);
      createBooking(context);
    } else if (response.statusCode == 400) {
      setState(() {
        isLoading = false;
      });
      showSnackbarMessageGlobal(AppStrings.Invaliddateformate, context);
    } else if (response.statusCode == 404) {
      setState(() {
        isLoading = false;
      });
      showSnackbarMessageGlobal(
          AppStrings.noDriverAvailablePleaseselect, context);
    } else if (response.statusCode == 402) {
      setState(() {
        isLoading = false;
      });
      showSnackbarMessageGlobal(
          AppStrings.InvalidPickupOrDestinationaddress, context);
    } else if (response.statusCode == 403) {
      setState(() {
        isLoading = false;
      });
      showSnackbarMessageGlobal(
          AppStrings.BookingexceedssubscriptionKM, context);

      var data = jsonDecode(response.body);

      String tempAmount = data['amount'].toString();
      String extraKms = data['extraKms'].toString();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookingExceedBuySubscription(
            paymentAmount: tempAmount,
            extraKms: extraKms,
            selectedSlot: selectedSlot,
          ),
        ),
      );
    } else if (response.statusCode == 405) {
      setState(() {
        isLoading = false;
      });
      showSnackbarMessageGlobal(AppStrings.Bookingexceeds50km, context);
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
    }
  }

  void createBooking(BuildContext context) async {
    try {
      await uploadImageToFireStore(context);

      var prefs = await SharedPreferences.getInstance();

      var response = await HttpConfig().httpPostRequestWithToken(
        'booking',
        selectedSlot,
        prefs.getString("customer_accessToken").toString(),
      );

      var booking = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        showSnackbarMessageGlobal(AppStrings.Bookingsuccessfullydone, context);
        Navigator.pushReplacementNamed(
          context,
          Routes.confirmationScreen,
          arguments: booking['_id'],
        );
      } else if (response.statusCode == 409) {
        showSnackbarMessageGlobal(
            AppStrings.noDriverAvailablePleaseselect, context);
      } else if (response.statusCode == 411) {
        showSnackbarMessageGlobal(
            AppStrings.noDriverAvailablePleaseselect, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.Errorinbooking, context);
      }
    } catch (e) {
      print("errror ============ $e");
      // debugPrint("error $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future uploadImageToFireStore(BuildContext context) async {
    try {
      // var futures =
      //     images!.map((image) => HttpConfig().httpUplaodImage(image, 'image'));
      var futures = images!
          .map((image) => HttpConfig().uploadFileToFirestore(image.path));
      var response = await Future.wait(futures);

      _imageNameToUPload = response;
    } catch (err) {
      showSnackbarMessageGlobal(AppStrings.Erroruploadingimages, context);
      debugPrint("error uploading images $err");
    }
  }

  // Future uploadImage(BuildContext context) async {
  //   try {
  //     var futures =
  //         images!.map((image) => HttpConfig().httpUplaodImage(image, 'image'));
  //     var response = await Future.wait(futures);
  //     _imageNameToUPload = response.map((e) {
  //       var jsonData = jsonDecode(e);
  //       return jsonData[0]['filename'].toString();
  //     }).toList();
  //   } catch (err) {
  //     showSnackbarMessageGlobal(AppStrings.Erroruploadingimages, context);
  //   }
  // }
}
