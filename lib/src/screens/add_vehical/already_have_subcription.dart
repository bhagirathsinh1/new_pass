import 'package:flutter/material.dart';

import 'package:pass/src/config/dimens.dart';

import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/model/customer_register_model.dart';
import 'package:pass/src/model/vehical_list_model.dart';
import 'package:pass/src/screens/add_vehical/available_slots_screen.dart';

import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';

import 'package:pass/themeData.dart';

class AlreadyHaveSubscription extends StatefulWidget {
  const AlreadyHaveSubscription(
      {Key? key,
      required this.subscription,
      this.vehicle,
      this.pickupAddress,
      this.destinationAddress})
      : super(key: key);
  final Subscription subscription;
  final MyVehicalListModel? vehicle;
  final Address? pickupAddress;
  final Address? destinationAddress;
  @override
  _AlreadyHaveSubscriptionState createState() =>
      _AlreadyHaveSubscriptionState();
}

class _AlreadyHaveSubscriptionState extends State<AlreadyHaveSubscription> {
  var maxkm = "";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    initialize();
  }

  initialize() {
    setState(() {
      maxkm = widget.subscription.maxKm!.round().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
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
                height: size.height * 0.84,
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
                // padding: EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    SizedBox(height: 102),
                    Text(
                      AppStrings.pActiveSubscription,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Divider(
                        color: ThemeClass.greyColor.withOpacity(0.3),
                      ),
                    ),
                    Text(
                      // AppStrings.pPlan1,
                      widget.subscription.name.toString(),
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
                          height: size.width * 0.5,
                          width: size.width * 0.4,
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
                                widget.subscription.totalRides.toString(),
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
                          height: size.width * 0.5,
                          width: size.width * 0.4,
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
                                maxkm,
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
                    _buildButton(context),
                    SizedBox(height: 50)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildButton(BuildContext context) {
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
          (states) => Color(0xff1492E6),
        ),
        padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.all(15),
        ),
      ),
      onPressed: () {
        // Navigator.pushNamed(context, Routes.driverDetailsScreen);
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => AvailableSlotsScreen(
        //       vehicle: widget.vehicle,
        //       pickupAddress: widget.pickupAddress,
        //       destinationAddress: widget.destinationAddress,
        //     ),
        //   ),
        // );

        Navigator.pop(context);
      },
      child: SizedBox(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.vContinue,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
