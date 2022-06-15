import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turtle/constants.dart';
import 'package:turtle/fade_route.dart';
import 'package:turtle/map_page.dart';

import 'main.dart';

class ApiHelper {
  static Future<Map> getUserByFirebaseId() async {
    return await http
        .get(
      Uri.parse(kApiUrl +
          "user/login?firebaseId=${FirebaseAuth.instance.currentUser!.uid}"),
      headers: kHeader,
    )
        .then((value) {
      if (value.statusCode == 404) {
        return {};
      } else {
        return jsonDecode(value.body)["user"];
      }
    });
  }

  static Future<Map?> createAccount({
    required String name,
    required String userName,
    required String email,
    required int countryId,
    required int cityId,
    required int districtId,
  }) async {
    return await http.post(
      Uri.parse(kApiUrl + "user/createAccount"),
      headers: kHeader,
      body: {
        "firebaseId": FirebaseAuth.instance.currentUser!.uid,
        "phoneNumber": FirebaseAuth.instance.currentUser!.phoneNumber,
        "name": name,
        "userName": userName,
        "email": email,
        "countryId": jsonEncode(countryId),
        "cityId": jsonEncode(cityId),
        "districtId": jsonEncode(districtId),
      },
    ).then((value) {
      Map registerResponse = jsonDecode(value.body);
      if (!registerResponse["success"]) {
        showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  registerResponse["message"],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(navigatorKey.currentContext!);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
        return null;
      } else {
        Navigator.push(
          navigatorKey.currentContext!,
          FadeRoute(
            page: const MapPage(),
          ),
        );
      }
    });
  }

  static Future<List> getCountries() async {
    return await http
        .get(
      Uri.parse(kApiUrl + "location/getCountries"),
      headers: kHeader,
    )
        .then((value) {
      return jsonDecode(value.body)["countries"];
    });
  }

  static Future<List> getCities(int? countryId) async {
    if (countryId == null) {
      return [];
    }
    return await http
        .get(
      Uri.parse(kApiUrl + "location/getCities?countryId=$countryId"),
      headers: kHeader,
    )
        .then((value) {
      return jsonDecode(value.body)["cities"];
    });
  }

  static Future<List> getDistricts(int? cityId) async {
    if (cityId == null) {
      return [];
    }
    return await http
        .get(
      Uri.parse(kApiUrl + "location/getDistricts?cityId=$cityId"),
      headers: kHeader,
    )
        .then((value) {
      return jsonDecode(value.body)["districts"];
    });
  }

  static Future<bool> addHouse({
    required String title,
    required String priceDaily,
    required String priceMonthly,
    required double latCoordinate,
    required double longCoordinate,
    required bool hasInternet,
    required bool hasHeater,
    required bool hasTv,
    required bool hasKitchen,
    required bool hasLaundry,
    required String doubleBedCount,
    required String singleBedCount,
    required String singleSeatCount,
    required String doubleSeatCount,
    required String tripleSeatCount,
    required String peopleStayCount,
    required int countryId,
    required int cityId,
    required int districtId,
    required int userId,
  }) {
    return http
        .post(Uri.parse(kApiUrl + "house/addHouse"), headers: kHeader, body: {
      "title": title,
      "priceDaily": priceDaily,
      "priceMonthly": priceMonthly,
      "latCoordinate": jsonEncode(latCoordinate),
      "longCoordinate": jsonEncode(longCoordinate),
      "hasInternet": jsonEncode(hasInternet ? 1 : 0),
      "hasHeater": jsonEncode(hasHeater ? 1 : 0),
      "hasTv": jsonEncode(hasTv ? 1 : 0),
      "hasKitchen": jsonEncode(hasKitchen ? 1 : 0),
      "hasLaundry": jsonEncode(hasLaundry ? 1 : 0),
      "doubleBedCount": doubleBedCount,
      "singleBedCount": singleBedCount,
      "singleSeatCount": singleSeatCount,
      "doubleSeatCount": doubleSeatCount,
      "tripleSeatCount": tripleSeatCount,
      "peopleStayCount": peopleStayCount,
      "countryId": jsonEncode(countryId),
      "cityId": jsonEncode(cityId),
      "districtId": jsonEncode(districtId),
      "userId": jsonEncode(userId),
    }).then((value) {
      return jsonDecode(value.body)["success"];
    });
  }

  static Future<List> getHousePhotos(int houseId) async {
    return await http
        .get(
      Uri.parse(kApiUrl + "house/getPhotos?houseId=$houseId"),
      headers: kHeader,
    )
        .then((value) {
      return jsonDecode(value.body)["photos"];
    });
  }

  static Future<List> getHouses(
      {required Map filters, Map? rentedHouse}) async {
    if (rentedHouse != null) {
      return [rentedHouse];
    }
    Map tempFilter = {};
    filters.forEach((key, value) {
      if (value is bool && value == true) {
        tempFilter.addAll({key: jsonEncode(1)});
      } else if (value is String && value.isNotEmpty) {
        tempFilter.addAll({
          key: value,
        });
      } else if (value is int) {
        tempFilter.addAll({
          key: value,
        });
      }
    });
    print(tempFilter);
    return await http.patch(Uri.parse(kApiUrl + "house/searchHouse"),
        headers: kHeader,
        body: {
          "searchCriterias": jsonEncode(tempFilter),
        }).then((value) {
      return jsonDecode(value.body)["houses"];
    });
  }

  static Future<List> getHousesViaOwner({required int userId}) async {
    return await http
        .get(
      Uri.parse(kApiUrl + "house/getOwnerHouses?userId=$userId"),
      headers: kHeader,
    )
        .then((value) {
      return jsonDecode(value.body)["houses"];
    });
  }

  static Future<List> getHouseMessages({required int houseId}) async {
    return await http
        .get(
      Uri.parse(kApiUrl + "house/getHouseMessages?houseId=$houseId"),
      headers: kHeader,
    )
        .then((value) {
      return jsonDecode(value.body)["messages"];
    });
  }

  static Future sendMessages(
      {required String message,
      required int houseId,
      required int userId}) async {
    return await http.post(
      Uri.parse(kApiUrl + "user/sendMessage"),
      headers: kHeader,
      body: {
        "houseId": jsonEncode(houseId),
        "message": message,
        "userId": jsonEncode(userId),
      },
    ).then((value) {
      return jsonDecode(value.body)["success"];
    });
  }

  static Future<bool> deleteHouse({required int houseId}) async {
    return await http
        .delete(
      Uri.parse(kApiUrl + "house/deleteHouse?houseId=$houseId"),
      headers: kHeader,
    )
        .then((value) {
      return jsonDecode(value.body)["success"];
    });
  }

  static Future addHousePhoto(
      {required File image, required int houseId}) async {
    await image.readAsBytes().then((bytes) async {
      return await http.post(
        Uri.parse(kApiUrl + "house/addPhoto"),
        headers: kHeader,
        body: {
          "houseId": jsonEncode(houseId),
          "photo": base64Encode(bytes).toString(),
        },
      ).then((value) {
        return jsonDecode(value.body)["success"];
      });
    });
  }

  static Future<bool> rentHouse(
      {required int userId,
      required int houseId,
      required String rentType}) async {
    return await http
        .post(
      Uri.parse(kApiUrl +
          "user/rentHouse?userId=$userId&houseId=$houseId&rentType=$rentType"),
      headers: kHeader,
    )
        .then((value) {
      return jsonDecode(value.body)["success"];
    });
  }

  static Future<bool> handleLock({
    required int houseId,
    required int newLockStatus,
  }) async {
    return await http
        .get(
      Uri.parse(kApiUrl +
          "house/changeLockStatus?houseId=$houseId&lockStatus=$newLockStatus"),
      headers: kHeader,
    )
        .then((value) {
      return jsonDecode(value.body)["success"];
    });
  }

  static Future<bool> leaveHouse({
    required int houseId,
    required int userId,
    required File image,
  }) async {
    return await image.readAsBytes().then((bytes) async {
      return await http.patch(
        Uri.parse(kApiUrl + "user/leaveHouse"),
        headers: kHeader,
        body: {
          "houseId": jsonEncode(houseId),
          "userId": jsonEncode(userId),
          "photo": base64Encode(bytes).toString(),
        },
      ).then((value) {
        print(jsonDecode(value.body));
        return jsonDecode(value.body)["success"];
      });
    });
  }
}
