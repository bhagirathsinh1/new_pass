import 'dart:convert';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  CustomerModel({
    this.password,
    this.subscription,
    this.email,
    this.name,
    this.mobileNumber,
    this.profilePicture,
    this.uploadedDocuments,
    this.vehicleId,
    this.pickupAddress,
    this.destinationAddress,
    this.pickupToDestinationKm,
    this.tripTime,
    this.role,
    this.openTime,
    this.closeTime,
    this.otp,
    this.passInactive,
    this.passActive,
    this.fcmToken,
    this.emailVerified,
    this.verifyToken,
  });

  String? password;
  Subscription? subscription;
  String? email;
  String? name;
  int? mobileNumber;
  String? profilePicture;
  List<String>? uploadedDocuments;
  List<String>? vehicleId;
  Address? pickupAddress;
  Address? destinationAddress;
  double? pickupToDestinationKm;
  int? tripTime;
  String? role;
  int? openTime;
  int? closeTime;
  int? otp;
  int? passInactive;
  int? passActive;
  String? fcmToken;
  bool? emailVerified;
  String? verifyToken;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        password: json["password"] == null ? null : json["password"],
        subscription: json["subscription"] == null
            ? null
            : Subscription.fromJson(json["subscription"]),
        email: json["email"] == null ? null : json["email"],
        name: json["name"] == null ? null : json["name"],
        mobileNumber:
            json["mobileNumber"] == null ? null : json["mobileNumber"],
        profilePicture:
            json["profilePicture"] == null ? null : json["profilePicture"],
        uploadedDocuments: json["uploadedDocuments"] == null
            ? null
            : List<String>.from(json["uploadedDocuments"].map((x) => x)),
        vehicleId: json["vehicleId"] == null
            ? null
            : List<String>.from(json["vehicleId"].map((x) => x)),
        pickupAddress: json["pickupAddress"] == null
            ? null
            : Address.fromJson(json["pickupAddress"]),
        destinationAddress: json["destinationAddress"] == null
            ? null
            : Address.fromJson(json["destinationAddress"]),
        pickupToDestinationKm: json["pickupToDestinationKm"] == null
            ? null
            : double.parse(json["pickupToDestinationKm"].toString()),
        tripTime: json["tripTime"] == null ? null : json["tripTime"],
        role: json["role"] == null ? null : json["role"],
        openTime: json["openTime"] == null ? null : json["openTime"],
        closeTime: json["closeTime"] == null ? null : json["closeTime"],
        otp: json["otp"] == null ? null : json["otp"],
        passInactive:
            json["passInactive"] == null ? null : json["passInactive"],
        passActive: json["passActive"] == null ? null : json["passActive"],
        fcmToken: json["fcmToken"] == null ? null : json["fcmToken"],
        emailVerified:
            json["emailVerified"] == null ? null : json["emailVerified"],
        verifyToken: json["verifyToken"] == null ? null : json["verifyToken"],
      );

  Map<String, dynamic> toJson() => {
        "password": password == null ? null : password,
        "subscription": subscription == null ? null : subscription?.toJson(),
        "email": email == null ? null : email,
        "name": name == null ? null : name,
        "mobileNumber": mobileNumber == null ? null : mobileNumber,
        "profilePicture": profilePicture == null ? null : profilePicture,
        "uploadedDocuments": uploadedDocuments == null
            ? null
            : List<dynamic>.from(uploadedDocuments!.map((x) => x)),
        "vehicleId": vehicleId == null
            ? null
            : List<dynamic>.from(vehicleId!.map((x) => x)),
        "pickupAddress": pickupAddress == null ? null : pickupAddress!.toJson(),
        "destinationAddress":
            destinationAddress == null ? null : destinationAddress!.toJson(),
        "pickupToDestinationKm":
            pickupToDestinationKm == null ? null : pickupToDestinationKm,
        "tripTime": tripTime == null ? null : tripTime,
        "role": role == null ? null : role,
        "openTime": openTime == null ? null : openTime,
        "closeTime": closeTime == null ? null : closeTime,
        "otp": otp == null ? null : otp,
        "passInactive": passInactive == null ? null : passInactive,
        "passActive": passActive == null ? null : passActive,
        "fcmToken": fcmToken == null ? null : fcmToken,
        "emailVerified": emailVerified == null ? null : emailVerified,
        "verifyToken": verifyToken == null ? null : verifyToken,
      };
}

class Address {
  Address({
    this.originalAddress,
    this.addressLine2,
    this.landmark,
    this.city,
    this.pincode,
    this.long,
    this.lat,
    this.authorName,
    this.authorMobileNumber,
  });

  String? originalAddress;
  String? addressLine2;
  String? landmark;
  String? city;
  String? pincode;
  String? long;
  String? lat;
  String? authorName;
  String? authorMobileNumber;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        originalAddress:
            json["originalAddress"] == null ? null : json["originalAddress"],
        addressLine2:
            json["addressLine2"] == null ? null : json["addressLine2"],
        landmark: json["landmark"] == null ? null : json["landmark"],
        city: json["city"] == null ? null : json["city"],
        pincode: json["pincode"] == null ? null : json["pincode"].toString(),
        long: json["long"] == null ? null : json["long"].toString(),
        lat: json["lat"] == null ? null : json["lat"].toString(),
        authorName: json["authorName"] == null ? null : json["authorName"],
        authorMobileNumber: json["authorMobileNumber"] == null
            ? null
            : json["authorMobileNumber"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "originalAddress": originalAddress == null ? null : originalAddress,
        "addressLine2": addressLine2 == null ? null : addressLine2,
        "landmark": landmark == null ? null : landmark,
        "city": city == null ? null : city,
        "pincode": pincode == null ? null : pincode,
        "long": long == null ? null : long,
        "lat": lat == null ? null : lat,
        "authorName": authorName == null ? null : authorName,
        "authorMobileNumber":
            authorMobileNumber == null ? null : authorMobileNumber,
      };
}

class Subscription {
  Subscription({
    this.name,
    this.totalRides,
    this.maxKm,
    this.maxkmExceededRate,
  });

  String? name;
  int? totalRides;
  double? maxKm;
  int? maxkmExceededRate;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        name: json["name"] == null ? null : json["name"],
        totalRides: json["totalRides"] == null ? null : json["totalRides"],
        maxKm: json["maxKm"] == null
            ? null
            : double.parse(json["maxKm"].toString()),
        maxkmExceededRate: json["maxkmExceededRate"] == null
            ? null
            : json["maxkmExceededRate"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "totalRides": totalRides == null ? null : totalRides,
        "maxKm": maxKm == null ? null : maxKm,
        "maxkmExceededRate":
            maxkmExceededRate == null ? null : maxkmExceededRate,
      };
}
