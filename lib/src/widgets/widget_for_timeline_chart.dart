import 'package:flutter/material.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/model/booking_model.dart';
import 'package:pass/src/widgets/show_image_screen.dart';
import 'package:pass/themeData.dart';

class IndicatorExample extends StatelessWidget {
  const IndicatorExample({Key? key, required this.color}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0,
      height: 0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // border: Border.all(width: 1),
        color: color,
      ),
    );
  }
}

class RowExample extends StatelessWidget {
  const RowExample({
    Key? key,
    this.showView = false,
    this.bookingDetails,
    required this.title,
    required this.bookingId,
    required this.index,
  }) : super(key: key);

  final String title;
  final bool showView;
  final int index;
  final String bookingId;
  final BookingModel? bookingDetails;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              // style: GoogleFonts.jura(
              //   color: Colors.white,
              //   fontSize: 18,
              // ),
            ),
          ),
          Spacer(),
          showView
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowImageScreen(
                          bookingId: bookingId,
                          status: index == 2
                              ? 'pickupDetails'
                              : 'destinationDetails',
                        ),
                      ),
                    );
                    // Navigator.pushNamed(context, Routes.pickUporder);
                  },
                  child: Text(
                    AppStrings.ViewDetails,
                    style: TextStyle(
                      fontSize: 18,
                      color: ThemeClass.orangeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : SizedBox()
          // TextButton(onPressed: () {}, child: Text("data"))
          // const Icon(
          //   Icons.remove_red_eye,
          //   color: Colors.red,
          //   size: 26,
          // ),
        ],
      ),
    );
  }
}
