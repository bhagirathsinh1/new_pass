import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/themeData.dart';

class ChatDetailedScreen extends StatefulWidget {
  const ChatDetailedScreen({Key? key}) : super(key: key);

  @override
  _ChatDetailedScreenState createState() => _ChatDetailedScreenState();
}

class _ChatDetailedScreenState extends State<ChatDetailedScreen> {
  // late FirebaseFirestore db;
  late String customerid;
  late String chatid;
  late String driverid;
  TextEditingController sendMessageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // db = FirebaseFirestore.instance;
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getChatList() {
  //   return db
  //       .collection('chat')
  //       .orderBy('dateTime', descending: false)
  //       .where('chatid', isEqualTo: chatid)
  //       .snapshots();
  // }

  void sendMessage(String text) {
    // sendMessageController.text = '';
    // db.collection('chat').add({
    //   'chat': text,
    //   'chatid': chatid,
    //   'dateTime': FieldValue.serverTimestamp(),
    //   'id': customerid
    // });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    customerid = arguments['customerId'] ?? '';
    driverid = arguments['driverId'] ?? '';
    chatid = arguments['chatId'] ?? '';
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: CustomScrollView(
          slivers: <Widget>[
            AppBarWidget(title: "Abramo"),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
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
                    height: MediaQuery.of(context).size.height - 130,
                    // padding: EdgeInsets.all(40.0),
                    // child: StreamBuilder<Object>(
                    //     stream: getChatList(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData && snapshot.data != null) {
                    //         return _buildChatLayout(
                    //             context, snapshot.requireData);
                    //       }
                    //       if (snapshot.hasData && snapshot.data == null) {
                    //         return Center(
                    //           child: Text(AppStrings.noChatFound),
                    //         );
                    //       }
                    //       return Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChatLayout(BuildContext context, dynamic data) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildChatWidget(data),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: TextField(
            controller: sendMessageController,
            decoration: InputDecoration(
              hintText: AppStrings.cbSearch,
              suffixIcon: IconButton(
                  onPressed: () => sendMessageController.text.length > 0
                      ? sendMessage(sendMessageController.text)
                      : null,
                  icon: Icon(
                    Icons.send,
                    color: ThemeClass.orangeColor,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatWidget(dynamic data) {
    return ListView.separated(
      itemCount: data.size,
      itemBuilder: (context, index) {
        var chatDetails = data.docs[index].data();
        if (chatDetails['id'] == customerid) {
          return _myChat(chatDetails['chat']);
        } else {
          return _otherChat(chatDetails['chat']);
        }
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
    // return Container(
    //   child: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         SizedBox(height: 20),
    //         Text('Wednesday 15:18 PM'),
    //         SizedBox(height: 20),
    //         _otherChat(),
    //         SizedBox(
    //           height: 15,
    //         ),
    //         _myChat(),
    //         _myChatSeenTime(),
    //         SizedBox(height: 15),
    //         _otherChat(),
    //         SizedBox(
    //           height: 15,
    //         ),
    //         _myChat(),
    //         _myChatSeenTime(),
    //         SizedBox(height: 15),
    //         _otherChat(),
    //         SizedBox(
    //           height: 15,
    //         ),
    //         _myChat(),
    //         _myChatSeenTime(),
    //         SizedBox(height: 15),
    //       ],
    //     ),
    //   ),
    // );
  }

  Align _myChat(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.centerLeft,
        width: 200,
        child: Text(
          message,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        decoration: BoxDecoration(
          color: Color(0x33FD6B22),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }

  Align _myChatSeenTime() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment.centerRight,
        child: Text(
          AppStrings.cdRead + ' ' + '16:25',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Align _otherChat(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.centerLeft,
        width: 200,
        child: Text(
          message,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        decoration: BoxDecoration(
          color: Color(0x33FD6B22),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }
}
