import 'dart:convert';

import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/booking_model.dart';
import 'package:pass/src/shared_preferance/shared_pref_service.dart';
import 'package:pass/src/widgets/appbar_widget.dart';

import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/custom_drawer.dart';
import 'package:pass/src/widgets/full_screen_image_view.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';

import 'package:pass/themeData.dart';
import 'package:flutter/material.dart';
import 'package:pass/src/config/size_config.dart';

import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:image_picker/image_picker.dart';

import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class ShowImageScreen extends StatefulWidget {
  const ShowImageScreen({
    Key? key,
    required this.bookingId,
    required this.status,
  }) : super(key: key);
  final String bookingId;
  final String status;
  @override
  _ShowImageScreenState createState() => _ShowImageScreenState();
}

class _ShowImageScreenState extends State<ShowImageScreen> {
  bool agree = false,
      isObsecure = false,
      isVideoUploading = false,
      isVideoPlaying = true,
      isUploading = false,
      isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isCancelTrip = false;

  List<PickedFile>? images = [];

  bool isinitalpick = true;

  List<String> fileNames = [];
  VideoPlayerController? _videoPlayerController;

  var _notesController = TextEditingController();
  late Future<http.Response> future;
  @override
  void initState() {
    future = doHttpCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.bookingId);
    // SizeConfig().init(context);
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: Container(
          child: Column(
            children: [
              SimpleAppBarWidget(
                  title: widget.status == 'pickupDetails'
                      ? AppStrings.pickupDetails
                      : AppStrings.Destinationdetails),
              SizedBox(
                height: 60,
              ),
              Flexible(
                child: Container(
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
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        _buildBody(context),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot<http.Response> snapshot) {
        if (snapshot.hasData) {
          var response = BookingModel.fromJson(jsonDecode(snapshot.data!.body));
          List<String> images = [];
          String videoToPLay = "";

          if (widget.status == 'pickupDetails') {
            images = response.pickupDetails.driverImages!;
            _notesController.text = response.pickupDetails.notes!;
            if (response.pickupDetails.driverVideos! != null &&
                response.pickupDetails.driverVideos!.isNotEmpty) {
              videoToPLay = response.pickupDetails.driverVideos![0];
            }
            if (_videoPlayerController == null) {
              _videoPlayerController =
                  VideoPlayerController.network(videoToPLay)
                    ..initialize()
                        .then((value) => _videoPlayerController!.setVolume(0));
              // ..initialize().then((_) {
              //   _videoPlayerController!.setVolume(0);
              //   // _videoPlayerController!.play();
              // });
            }

            _notesController.text = response.pickupDetails.notes!;
          } else if (widget.status == 'destinationDetails') {
            _notesController.text = response.destinationDetails.notes!;
            images = response.destinationDetails.driverImages!;
            if (response.destinationDetails.driverVideos! != null &&
                response.destinationDetails.driverVideos!.isNotEmpty) {
              videoToPLay = response.destinationDetails.driverVideos![0];
              if (_videoPlayerController == null) {
                _videoPlayerController =
                    VideoPlayerController.network(videoToPLay)
                      ..initialize().then((_) {
                        _videoPlayerController!.setVolume(0);
                        // _videoPlayerController!.play();
                      });
              }
            }
          } else {
            showSnackbarMessageGlobal(AppStrings.invaliddata, context);
            throw AppStrings.invaliddata;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildTitle(AppStrings.Photosofvehicle),
              SizedBox(
                height: 15,
              ),
              _buildimageSlider(images),
              SizedBox(
                height: 15,
              ),
              Divider(
                color: ThemeClass.greyColor,
              ),

              _buildTitle(AppStrings.videoOfVehicle),
              SizedBox(
                height: 15,
              ),
              videoToPLay != "" ? _buildvideoPreviewWidget() : SizedBox(),

              SizedBox(
                height: 15,
              ),

              Divider(
                color: ThemeClass.greyColor,
              ),
              // SizedBox(
              //   height: 15,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.Notes,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ThemeClass.greyColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      _notesController.text,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 15,
              ),
              Divider(
                color: ThemeClass.greyColor,
              ),
              // SizedBox(
              //   height: 15,
              // ),
              _buildTitle(AppStrings.Authername),
              SizedBox(
                height: 10,
              ),
              widget.status == 'pickupDetails'
                  ? Text(
                      response.pickupDetails.authorName.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.w600,
                        // color: ThemeClass.greyColor,
                      ),
                    )
                  : Text(
                      response.destinationDetails.authorName.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.w600,
                        // color: ThemeClass.greyColor,
                      ),
                    ),
              SizedBox(
                height: 15,
              ),
              Divider(
                color: ThemeClass.greyColor,
              ),
              SizedBox(
                height: 10,
              ),
              _buildTitle(AppStrings.Signature),
              SizedBox(
                height: 15,
              ),
              widget.status == 'pickupDetails'
                  ? _buildimageSlider(
                      [
                        response.pickupDetails.signature.toString(),
                      ],
                    )
                  : _buildimageSlider(
                      [response.destinationDetails.signature.toString()]),
              ButtonWidget(
                title: AppStrings.continueText,
                onpress: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Center _buildvideoPreviewWidget() {
    return Center(
      child: Stack(
        children: [
          Container(
            height: 210,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                    isVideoUploading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: ThemeClass.orangeColor,
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            heightFactor: 4,
            child: IconButton(
              icon:
                  !isVideoPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              color: ThemeClass.orangeColor,
              onPressed: () {
                if (_videoPlayerController != null) {
                  if (isVideoPlaying) {
                    _videoPlayerController!.play();
                  } else {
                    _videoPlayerController!.pause();
                  }
                  setState(() {
                    isVideoPlaying = !isVideoPlaying;
                  });
                  _videoPlayerController!.setLooping(true);
                }
              },
              iconSize: 40,
            ),
          ),
        ],
      ),
    );
  }

  Future<http.Response> doHttpCall() async {
    // return HttpConfig().httpGet('booking/${widget.bookingId}');
    var pref = await SharedPrefService.getUserToken();
    return HttpConfig().httpGetRequest('booking/${widget.bookingId}', '$pref');
  }

  Widget _buildimageSlider(List<String>? images) {
    return _iamgeRow(images);
  }

  Wrap _iamgeRow(List<String>? images) {
    return Wrap(
      runSpacing: 10,
      children: [
        ...images!.map((e) => _buildIamgeButtonBox(e)).toList(),
      ],
    );
  }

  InkWell _buildIamgeButtonBox(String e) {
    print('${HttpConfig().IMAGE_URL}$e');
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenImageView(
              path: "$e",
              isFromNetwork: true,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('$e'),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(20)
            // shape: BoxShape.circle,
            ),
        height: 100,
        width: 100,
      ),
    );
  }

  Row _buildTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ThemeClass.greyColor,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_videoPlayerController != null) _videoPlayerController!.dispose();
    super.dispose();
  }
}
