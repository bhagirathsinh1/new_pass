import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/vehical_list_model.dart';
import 'package:pass/src/screens/home_screen.dart';
import 'package:pass/src/service/vehicle_service.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/themeData.dart';
import 'package:provider/provider.dart';

class MyVehicalListScreen extends StatefulWidget {
  const MyVehicalListScreen({Key? key}) : super(key: key);

  @override
  _MyVehicalListScreenState createState() => _MyVehicalListScreenState();
}

class _MyVehicalListScreenState extends State<MyVehicalListScreen> {
  late VehicleService vehicleService;

  late Future<List<MyVehicalListModel>> vehicleList;
  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      vehicleService = Provider.of<VehicleService>(context);
      vehicleList = vehicleService.setVehicleList();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  _buildVehicalList() {
    return FutureBuilder(
      future: vehicleList,
      builder: (context, AsyncSnapshot<List<MyVehicalListModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              return Column(
                children: [
                  Center(
                    child: Text(
                      AppStrings.mvlSwipelefttoseeoptions,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _buildSlidable(
                        snapshot.data![index],
                        context,
                        snapshot.data![index].make.toString(),
                        snapshot.data![index].plateNumber.toString(),
                        snapshot.data![index].id.toString(),
                      );
                    },
                  ),
                ],
              );
            } else
              return Center(
                child: Text(
                  AppStrings.vehiclenotavailable,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: ThemeClass.orangeColor,
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: ThemeClass.orangeColor,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: Container(
          child: Column(
            children: [
              SimpleAppBarWidget(title: AppStrings.mvlMyVehicles),
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
                      topLeft: Radius.circular(
                          SizeConfig.topLeftRadiousForContainer),
                      topRight: Radius.circular(
                          SizeConfig.topRightRadiousForContainer),
                    ),
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: 40),
                        // Center(
                        //   child: Text(
                        //     AppStrings.mvlSwipelefttoseeoptions,
                        //     style: TextStyle(
                        //       fontSize: 15,
                        //     ),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        SizedBox(height: 30),
                        _buildVehicalList()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          Navigator.pushNamed(context, Routes.addVehicleScreen);
        },
      ),
    );
  }

  Padding _buildSlidable(MyVehicalListModel vehicalListModel,
      BuildContext context, String title, String subtitle, String id) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.15,
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: 75,
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
                Container(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFA6400),
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: ThemeClass.greyColor,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: ThemeClass.orangeColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        secondaryActions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          vehicle: vehicalListModel,
                        )),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Container(
                height: 70,
                width: 30,
                decoration: BoxDecoration(
                  color: Color(0xff1492E6).withOpacity(0.2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              deleteDialog(id);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Container(
                height: 70,
                width: 30,
                decoration: BoxDecoration(
                  color: Color(0xffFD5E4D).withOpacity(0.2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  deleteDialog(String id) async {
    showAlertDialogGlobal(
        AppStrings.Confirmation, AppStrings.Areyousuretodelete, context,
        () async {
      deleteVehicle(id);
    });
  }

  deleteVehicle(String id) async {
    String url = "vehicle/" + id;
    try {
      var response = await HttpConfig().httpDeleteRequestWithToken(url);
      if (response.statusCode == 200) {
        getData();

        setState(() {});

        showSnackbarMessageGlobal(
            AppStrings.VehicleSuccessfullyDeleted, context);
        // final body = json.decode(response.body);
      } else if (response.statusCode == 500) {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
      }
    } catch (e) {
      if (mounted) showSnackbarMessageGlobal(e.toString(), context);
    } finally {}
  }

  getData() {
    vehicleService = Provider.of<VehicleService>(context, listen: false);
    vehicleList = vehicleService.setVehicleList();
    setState(() {});
  }
}
