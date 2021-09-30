// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:pass/src/config/strings.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBoxScreen extends StatefulWidget {
  const ChatBoxScreen({Key? key}) : super(key: key);

  @override
  _ChatBoxScreenState createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  // late FirebaseFirestore db;
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    initializeSharedPreference();
    // db = FirebaseFirestore.instance;
  }

  void initializeSharedPreference() async {
    pref = await SharedPreferences.getInstance();
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getChatList() {
  //   return db
  //       .collection('chatlist')
  //       .where('customerid', isEqualTo: '6139b11c5cf02b02e8855b9d')
  //       .snapshots();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: CustomScrollView(
          slivers: <Widget>[
            AppBarWidget(title: AppStrings.cbChatbox),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     shape: BoxShape.rectangle,
                  //     borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(
                  //           SizeConfig.topLeftRadiousForContainer),
                  //       topRight: Radius.circular(
                  //           SizeConfig.topRightRadiousForContainer),
                  //     ),
                  //   ),
                  //   height: MediaQuery.of(context).size.height - 130,
                  //   // padding: EdgeInsets.all(40.0),
                  //   child: StreamBuilder(
                  //       stream: getChatList(),
                  //       builder: (context, snapshot) {
                  //         if (snapshot.hasData && snapshot.data != null) {
                  //           return _buildChatLayout(
                  //               context, snapshot.requireData);
                  //         }
                  //         if (snapshot.hasData && snapshot.data == null) {
                  //           return Center(
                  //             child: Text(AppStrings.noChatFound),
                  //           );
                  //         }
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       }),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget _buildChatLayout(BuildContext context, dynamic data) {
  //   return Container(
  //     padding: EdgeInsets.all(20),
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: 10,
  //         ),
  //         TextField(
  //           decoration: InputDecoration(
  //             hintText: AppStrings.cbSearch,
  //             prefixIcon: Icon(Icons.search),
  //           ),
  //         ),
  //         SizedBox(height: 10),
  //         Divider(),
  //         Expanded(
  //           child: ListView.separated(
  //             itemCount: data.size,
  //             itemBuilder: (context, index) {
  //               var chatList = data.docs[index].data();
  //               return ListTile(
  //                 onTap: () {
  //                   Navigator.pushNamed(context, Routes.chatDetailedScreen,
  //                       arguments: {
  //                         'customerId': chatList['customerid'],
  //                         'driverId': chatList['driverid'],
  //                         'chatId': data.docs[index].id
  //                       });
  //                 },
  //                 leading: ClipRRect(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   child: Image.network(
  //                     chatList['driver_image'],
  //                     // height: 150.0,
  //                     // width: 100.0,
  //                   ),
  //                 ),
  //                 title: Text(
  //                   chatList['name'],
  //                   style: TextStyle(fontWeight: FontWeight.w600),
  //                 ),
  //                 subtitle: Text(AppStrings.driver),
  //                 trailing: Text(
  //                   '8 mins ago',
  //                   style: TextStyle(fontStyle: FontStyle.italic),
  //                 ),
  //               );
  //             },
  //             separatorBuilder: (context, index) {
  //               return Divider();
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
