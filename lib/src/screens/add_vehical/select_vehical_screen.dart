import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pass/routes.dart';

import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';

import 'package:pass/src/model/vehical_list_model.dart';
import 'package:pass/src/service/vehicle_service.dart';
import 'package:pass/src/widgets/appbar_widget.dart';

import 'package:pass/src/widgets/background_gradiant.dart';

import 'package:pass/themeData.dart';
import 'package:provider/provider.dart';

class SelectVehicleScreen extends StatefulWidget {
  late List<MyVehicalListModel> vehicleList;

  SelectVehicleScreen({Key? key, required this.vehicleList}) : super(key: key);

  @override
  _SelectVehicleScreenState createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  late VehicleService vehicleService;

  late List<MyVehicalListModel> vehicleList;
  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      vehicleService = Provider.of<VehicleService>(context);
      vehicleList = widget.vehicleList;
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    vehicleList = widget.vehicleList;
    isInit = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          Navigator.pushNamed(context, Routes.addVehicleScreen);
        },
      ),
      body: BackgraoundGradient(
          child: Container(
        child: Column(
          children: [
            SimpleAppBarWidget(title: AppStrings.cbSelectVehicle),
            SizedBox(
              height: 60,
            ),
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height,
                // height: double.infinity,
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
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [SizedBox(height: 30), _buildVehicalList()],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  _buildVehicalList() {
    return Container(
      child: vehicleList.length > 0
          ? ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: vehicleList.length,
              itemBuilder: (context, index) {
                return _buildSlidable(context, vehicleList[index]);
              },
            )
          : Center(
              child: Text(
                AppStrings.vehiclenotavailable,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Padding _buildSlidable(BuildContext context, MyVehicalListModel vehicle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.15,
        child: InkWell(
          onTap: () {
            Navigator.pop(context, vehicle);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 75,
            decoration: BoxDecoration(
              color: Color(0xffF2F2F2),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          child: Text(
                            "${vehicle.make}  ${vehicle.model}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFFA6400),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      // Flexible(
                      //   child: Container(
                      //     child: Text(
                      //       "${vehicle.model}",
                      //       style: TextStyle(
                      //           fontSize: 20,
                      //           overflow: TextOverflow.fade,
                      //           color: Color(0xFFFA6400),
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "${vehicle.plateNumber}",
                          style: TextStyle(
                            fontSize: 14,
                            color: ThemeClass.greyColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // getData() {
  //   vehicleService = Provider.of<VehicleService>(context, listen: false);
  //   vehicleList = vehicleService.setVehicleList();
  //   setState(() {});
  // }
}
