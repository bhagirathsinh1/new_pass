import 'dart:convert';

import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/screens/authentication/login_screen/login_screen.dart';
import 'package:pass/src/service/navigator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpConfig {
  // String API_BASE_URL = "http://srv.passmoto.com/api/";
  // String PAYMENT_GATWAY_URL = "http://3.125.255.60:3333/";

  String API_BASE_URL = "http://3.125.255.60:3210/api/";
  String PAYMENT_GATWAY_URL = "http://3.125.255.60:3333/";

  // static const String API_BASE_URL = "http://192.168.1.7:3210/api/";

  // String API_BASE_URL = "http://192.168.1.18:3210/api/";
  // String PAYMENT_GATWAY_URL = "http://192.168.1.18:4200/";
  String IMAGE_URL = "";

  static Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  Client http = InterceptedClient.build(interceptors: [
    Interceptor(),
  ]);

  Future<String> uploadFileToFirestore(String path) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      var fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          '.' +
          path.split(".").last;
      Reference ref = storage.ref().child("file" + fileName);
      var uploadTask = await ref.putFile(File(path));
      var firebaseFileName = await uploadTask.ref.getDownloadURL();
      return firebaseFileName;
    } catch (e) {
      debugPrint("e $e");
      throw e;
    }
  }

  // static Future<String> httpuploadFile(PlatformFile imageFile, url) async {
  //   bool connected = await isConnected();
  //   if (connected) {
  //     Map<String, String> headers = {
  //       "Accept": "application/json",
  //     };
  //     var request3 =
  //         http.MultipartRequest('POST', Uri.parse(API_BASE_URL + url));
  //     request3.headers.addAll(headers);
  //     request3.files.add(await http.MultipartFile.fromPath(
  //       'document',
  //       "${imageFile.path}",
  //       contentType: MediaType(
  //         'image',
  //         'jpg',
  //       ),
  //     ));

  //     StreamedResponse res3 = await request3.send();

  //     return getSmsStatus(res3);
  //   } else {
  //     throw "Please connect to internet";
  //   }
  // }

  // static Future<String> ,(PickedFile? imageFile, url) async {
  //   bool connected = await isConnected();
  //   if (connected) {
  //     Map<String, String> headers = {
  //       "Accept": "application/json",
  //     };
  //     var request3 =
  //         http.MultipartRequest('POST', Uri.parse(API_BASE_URL + url));
  //     request3.headers.addAll(headers);
  //     request3.files.add(await http.MultipartFile.fromPath(
  //       'image',
  //       "${imageFile!.path}",
  //       contentType: MediaType(
  //         'image',
  //         'jpg',
  //       ),
  //     ));
  //     StreamedResponse res3 = await request3.send();

  //     return getSmsStatus(res3);
  //   } else {
  //     throw "Please connect to internet";
  //   }
  // }

  Future<String> getSmsStatus(StreamedResponse stream) async {
    try {
      await for (var value in stream.stream.transform(utf8.decoder)) {
        return value.toString();
        // }
      }
    } catch (e) {
      return "false";
    }
    return "false";
  }

  static Future<bool?> whenTrue(Stream<bool> source) async {
    await for (bool value in source) {
      if (value) {
        return value;
      }
    }
  }

  // all single http request method

  // ! http post request without token
  Future<Response> httpPostRequest(String url, dynamic data) async {
    bool connected = await isConnected();
    if (connected) {
      var dataEncoded = jsonEncode(data);
      return http.post(
        Uri.parse(API_BASE_URL + url),
        body: dataEncoded,
        headers: requestHeaders,
      );
    } else {
      throw "Please connect to internet";
    }
  }

  // ! http post request with token

  Future<Response> httpPostRequestWithToken(
    String url,
    dynamic data,
    String token,
  ) async {
    print(Uri.parse(API_BASE_URL + url));
    bool connected = await isConnected();
    if (connected) {
      var dataEncoded = jsonEncode(data);
      return http.post(
        Uri.parse(API_BASE_URL + url),
        body: dataEncoded,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );
    } else {
      throw "Please connect to internet";
    }
  }

  // ! http get request with token

  Future<Response> httpGetRequest(String url, String token) async {
    bool connected = await isConnected();
    if (connected) {
      return http.get(
        Uri.parse(API_BASE_URL + url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );
    } else {
      throw "Please connect to internet";
    }
  }

  Future<dynamic> httpDeleteRequest(String url) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    bool connected = await isConnected();
    if (connected) {
      return http.delete(
        Uri.parse(API_BASE_URL + url),
        headers: {},
      );
    } else {
      throw "Please connect to internet";
    }
  }

  Future<dynamic> httpDeleteRequestWithToken(String url) async {
    print("URL $url");
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("customer_accessToken").toString();

    bool connected = await isConnected();
    if (connected) {
      return http.delete(
        Uri.parse(API_BASE_URL + url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );
    } else {
      throw "Please connect to internet";
    }
  }

// http patch request with token
  Future<dynamic> httpPatchRequestWithToken(
    String url,
    dynamic data,
    String token,
  ) async {
    bool connected = await isConnected();
    print(Uri.parse(API_BASE_URL + url));
    if (connected) {
      var dataEncoded = jsonEncode(data);
      return http.patch(
        Uri.parse(API_BASE_URL + url),
        body: dataEncoded,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );
    } else {
      throw "Please connect to internet";
    }
  }

  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

// !imp commented code
// static httpRegisterUploadFiles(String url, Map data) async {
//   final response = await http.post(Uri.parse(API_BASE_URL + url), body: data);
// }

// httpPostRequest(String Url,Map data){
//  return  http.post(url,header)

// }

// httpPostFileUpload(String url ){
//   return http.post(url,header)
// }

// httpPatchRequest(String Url,Map Data){
//   return http.patch(url,data);
//   //for update records
// }

// httpDeleteRequest(String Url,Map Data){
//   return http.patch(url,data);;
//   // for delete
// }
}

class Interceptor implements InterceptorContract {
  late SharedPreferences prefs;

  @override
  Future<RequestData> interceptRequest({RequestData? data}) async {
    return data!;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print(" body ${data.body}");
    print(" url ${data.url}");

    // check if route is auth then dont do anything
    if (data.url!.contains('auth')) {
      return data;
    }

    if (data.statusCode == 401) {
      SharedPreferences.getInstance().then((value) => value.clear());

      // remove all routes then add login route
      Navigator.pushNamedAndRemoveUntil(
        navigationService.navigationKey.currentContext!,
        Routes.logingRoute,
        (Route<dynamic> route) => false,
      );
    }
    return data;
  }
}
