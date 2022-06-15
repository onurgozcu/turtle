import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:turtle/api_helper.dart';
import 'package:turtle/cache_image_helper.dart';
import 'package:turtle/constants.dart';
import 'package:turtle/fade_route.dart';
import 'package:turtle/filter_page.dart';
import 'package:turtle/house_photos.dart';
import 'package:turtle/main.dart';
import 'package:turtle/profile_page.dart';
import 'package:turtle/qr_page.dart';

import 'marker_converter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key, this.initialFilters}) : super(key: key);
  final Map? initialFilters;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;

  Map? selectedHouseDetails;
  Map? filters;
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
        future: ApiHelper.getUserByFirebaseId(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              backgroundColor: kDarkBlue,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
          selectedHouseDetails ??= snapshot.data!["rentedHouse"];
          filters = widget.initialFilters ??
              {
                "countryId": snapshot.data!["countryId"],
                "cityId": snapshot.data!["cityId"],
                "districtId": snapshot.data!["districtId"],
                "minPriceDaily": "",
                "maxPriceDaily": "",
                "minPriceMonthly": "",
                "maxPriceMonthly": "",
                "minPeopleStay": "",
                "hasInternet": false,
                "hasLaundry": false,
                "hasKitchen": false,
                "hasHeater": false,
                "hasTV": false,
              };

          print(selectedHouseDetails);
          return FutureBuilder<List>(
              future: ApiHelper.getHouses(
                filters: filters!,
                rentedHouse: snapshot.data!["rentedHouse"],
              ),
              builder: (context, housesSnapshot) {
                if (!housesSnapshot.hasData) {
                  return const Scaffold(
                    backgroundColor: kDarkBlue,
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                print(housesSnapshot.data);
                Set<Marker> markers = {};

                for (var element in housesSnapshot.data!) {
                  markers.add(
                    Marker(
                      position: LatLng(
                          element["latCoordinate"], element["longCoordinate"]),
                      markerId: MarkerId(element["title"]),
                      icon: MarkerConverter().getMarker(),
                      onTap: () {
                        setState(() {
                          selectedHouseDetails = element;
                        });
                        _mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(element["latCoordinate"],
                                element["longCoordinate"]),
                            18,
                          ),
                        );
                      },
                    ),
                  );
                }
                return Scaffold(
                  bottomNavigationBar: Container(
                    height: kBottomNavigationBarHeight,
                    color: kDarkBlue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            ApiHelper.getCountries().then((countryList) {
                              ApiHelper.getCities(snapshot.data!["countryId"])
                                  .then((cityList) {
                                ApiHelper.getDistricts(snapshot.data!["cityId"])
                                    .then((districtList) {
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: FilterPage(
                                          filters: filters!,
                                          countryList: countryList,
                                          cityList: cityList,
                                          districtList: districtList),
                                    ),
                                  ).then((value) {
                                    setState(() {
                                      filters = value;
                                    });
                                  });
                                });
                              });
                            });
                          },
                          child: const Text(
                            "Filtre",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Text(
                          "Harita",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            PermissionStatus cameraPermission =
                                await Permission.camera.request();
                            if (cameraPermission.isGranted ||
                                cameraPermission.isLimited) {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: QrPage(
                                    userId: snapshot.data!["id"],
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "QR Tara",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              FadeRoute(
                                page: ProfilePage(
                                  userId: snapshot.data!["id"],
                                ),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: const Text(
                            "Hesap",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        onMapCreated: (c) {
                          _mapController = c;
                        },
                        initialCameraPosition: kCameraLocation,
                        onTap: (newLocation) {
                          setState(() {
                            markers.clear();
                            markers.add(
                              Marker(
                                position: newLocation,
                                markerId: const MarkerId("House Location"),
                                icon: MarkerConverter().getMarker(),
                              ),
                            );
                            _mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(newLocation, 18));
                          });
                        },
                        markers: markers,
                      ),
                      if (selectedHouseDetails != null)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 44.0),
                            child: InkWell(
                              onTap: () {
                                if (snapshot.data!["rentedHouse"] == null) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "House Details",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (selectedHouseDetails![
                                                      "singleBedCount"] !=
                                                  0)
                                                Text(
                                                  "${selectedHouseDetails!["singleBedCount"]}x Single Bed",
                                                  textAlign: TextAlign.center,
                                                ),
                                              if (selectedHouseDetails![
                                                      "doubleBedCount"] !=
                                                  0)
                                                Text(
                                                  "${selectedHouseDetails!["doubleBedCount"]}x Double Bed",
                                                  textAlign: TextAlign.center,
                                                ),
                                              if (selectedHouseDetails![
                                                      "singleSeatCount"] !=
                                                  0)
                                                Text(
                                                  "${selectedHouseDetails!["singleSeatCount"]}x Single Seat",
                                                  textAlign: TextAlign.center,
                                                ),
                                              if (selectedHouseDetails![
                                                      "doubleSeatCount"] !=
                                                  0)
                                                Text(
                                                  "${selectedHouseDetails!["doubleSeatCount"]}x Double Seat",
                                                  textAlign: TextAlign.center,
                                                ),
                                              if (selectedHouseDetails![
                                                      "tripleSeatCount"] !=
                                                  0)
                                                Text(
                                                  "${selectedHouseDetails!["tripleSeatCount"]}x Triple Seat",
                                                  textAlign: TextAlign.center,
                                                ),
                                              if (selectedHouseDetails![
                                                      "peopleStayCount"] !=
                                                  0)
                                                Text(
                                                  "${selectedHouseDetails!["peopleStayCount"]} People can stay",
                                                  textAlign: TextAlign.center,
                                                ),
                                              Text(
                                                "Internet ${selectedHouseDetails!["hasInternet"] != 0 ? "✅" : "❌"}",
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "Laundry ${selectedHouseDetails!["hasLaundry"] != 0 ? "✅" : "❌"}",
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "Kitchen ${selectedHouseDetails!["hasKitchen"] != 0 ? "✅" : "❌"} ",
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "TV ${selectedHouseDetails!["hasTV"] != 0 ? "✅" : "❌"}",
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "Heather ${selectedHouseDetails!["hasHeater"] != 0 ? "✅" : "❌"}",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                }
                              },
                              child: Container(
                                height: snapshot.data!["rentedHouse"] != null
                                    ? 126.0
                                    : 80.0,
                                width: 300.0,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.90),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 60.0,
                                        width: 280.0,
                                        child: Row(
                                          children: [
                                            FutureBuilder<List>(
                                                future:
                                                    ApiHelper.getHousePhotos(
                                                        selectedHouseDetails![
                                                            "id"]),
                                                builder:
                                                    (context, photosSnapshot) {
                                                  if (!photosSnapshot.hasData) {
                                                    return Container(
                                                      height: 60.0,
                                                      width: 110.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        color: const Color(
                                                            0xFFB0B0B0),
                                                      ),
                                                    );
                                                  }
                                                  return InkWell(
                                                    onTap: () {
                                                      if (photosSnapshot
                                                          .data!.isNotEmpty) {
                                                        Navigator.push(
                                                          context,
                                                          FadeRoute(
                                                            page: HousePhotos(
                                                                housePhotos:
                                                                    photosSnapshot
                                                                        .data!),
                                                          ),
                                                        ).then((value) {
                                                          setState(() {});
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 60.0,
                                                      width: 110.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        image: DecorationImage(
                                                          image: photosSnapshot
                                                                  .data!.isEmpty
                                                              ? const AssetImage(
                                                                  "assets/images/defaultHousePhoto.png",
                                                                )
                                                              : CacheImageProvider(
                                                                  selectedHouseDetails![
                                                                          "id"]
                                                                      .toString(),
                                                                  base64Decode(
                                                                      photosSnapshot
                                                                              .data![0]
                                                                          [
                                                                          "photo"]),
                                                                ) as ImageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                            const SizedBox(
                                              width: 12.0,
                                            ),
                                            snapshot.data!["rentedHouse"] ==
                                                    null
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        selectedHouseDetails![
                                                            "title"],
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${selectedHouseDetails!["priceDaily"]}₺ (1 Day) / ${selectedHouseDetails!["priceMonthly"]}₺ (1 Month)",
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 10.0,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        (DateTime.parse(selectedHouseDetails![
                                                                        "rentEnd"])
                                                                    .difference(
                                                                        DateTime.parse(
                                                                            selectedHouseDetails!["rentStart"]))
                                                                    .inDays
                                                                    .abs() >
                                                                2)
                                                            ? "${selectedHouseDetails!["priceMonthly"]}₺ / 1 month"
                                                            : "${selectedHouseDetails!["priceDaily"]}₺ / 1 day",
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17.0,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return StatefulBuilder(
                                                                  builder: (context,
                                                                      setState) {
                                                                    return WillPopScope(
                                                                      onWillPop:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          _messageController
                                                                              .clear();
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                        return true;
                                                                      },
                                                                      child:
                                                                          AlertDialog(
                                                                        backgroundColor:
                                                                            kDarkBlue,
                                                                        title:
                                                                            const Text(
                                                                          'Send Message',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        content:
                                                                            Wrap(
                                                                          alignment:
                                                                              WrapAlignment.center,
                                                                          crossAxisAlignment:
                                                                              WrapCrossAlignment.center,
                                                                          children: [
                                                                            TextField(
                                                                              textCapitalization: TextCapitalization.characters,
                                                                              style: const TextStyle(color: Colors.white),
                                                                              cursorColor: Colors.white,
                                                                              autofocus: true,
                                                                              textAlign: TextAlign.center,
                                                                              decoration: const InputDecoration(
                                                                                enabledBorder: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.white),
                                                                                ),
                                                                                focusedBorder: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.white),
                                                                                ),
                                                                                border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              controller: _messageController,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 32.0),
                                                                              child: ElevatedButton(
                                                                                onPressed: () async {
                                                                                  if (_messageController.text != "") {
                                                                                    ApiHelper.sendMessages(message: _messageController.text, houseId: snapshot.data!["rentedHouse"]!["id"], userId: snapshot.data!["id"]).then((value) {
                                                                                      if (value) {
                                                                                        showDialog(
                                                                                            context: navigatorKey.currentContext!,
                                                                                            builder: (context) {
                                                                                              return AlertDialog(
                                                                                                title: const Text('Your message sended to owner successfully'),
                                                                                                actions: [
                                                                                                  TextButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(navigatorKey.currentContext!);
                                                                                                      Navigator.pop(navigatorKey.currentContext!);
                                                                                                    },
                                                                                                    child: const Text('Ok'),
                                                                                                  ),
                                                                                                ],
                                                                                              );
                                                                                            });
                                                                                      } else {
                                                                                        showDialog(
                                                                                            context: navigatorKey.currentContext!,
                                                                                            builder: (context) {
                                                                                              return AlertDialog(
                                                                                                title: const Text('Something went wrong while sending your message. Please try again.'),
                                                                                                actions: [
                                                                                                  TextButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(navigatorKey.currentContext!);
                                                                                                      Navigator.pop(navigatorKey.currentContext!);
                                                                                                    },
                                                                                                    child: const Text('Ok'),
                                                                                                  ),
                                                                                                ],
                                                                                              );
                                                                                            });
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                },
                                                                                child: const Text(
                                                                                  'Okay',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                                style: ButtonStyle(
                                                                                  shape: MaterialStateProperty.all(
                                                                                    RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(32.0),
                                                                                    ),
                                                                                  ),
                                                                                  backgroundColor: MaterialStateProperty.all(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: kDarkBlue,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Icon(
                                                              Icons
                                                                  .message_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 18.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                      ),
                                      if (snapshot.data!["rentedHouse"] != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    const Color(0xFF838BF8),
                                                  ),
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          0),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          EdgeInsets.zero),
                                                ),
                                                onPressed: () async {
                                                  await ApiHelper.handleLock(
                                                          houseId: snapshot
                                                                      .data![
                                                                  "rentedHouse"]
                                                              ["id"],
                                                          newLockStatus: snapshot
                                                                              .data![
                                                                          "rentedHouse"]
                                                                      [
                                                                      "isLocked"] ==
                                                                  1
                                                              ? 0
                                                              : 1)
                                                      .then((value) {
                                                    setState(() {});
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Text(
                                                    snapshot.data!["rentedHouse"]
                                                                ["isLocked"] ==
                                                            1
                                                        ? "OPEN LOCK"
                                                        : "LOCK DOOR",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    const Color(0xFFFF7B79),
                                                  ),
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          0),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          EdgeInsets.zero),
                                                ),
                                                onPressed: () async {
                                                  if (snapshot.data![
                                                              "rentedHouse"]
                                                          ["isLocked"] ==
                                                      1) {
                                                    showDialog(
                                                        context: navigatorKey
                                                            .currentContext!,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "You need to take the door's photo which is closed and locked. Please be sure the sticker and the door can seems easily at the photo"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      navigatorKey
                                                                          .currentContext!);
                                                                  final picker =
                                                                      ImagePicker();
                                                                  final pickedFile =
                                                                      await picker
                                                                          .pickImage(
                                                                    source: ImageSource
                                                                        .camera,
                                                                    imageQuality:
                                                                        30,
                                                                  );
                                                                  ApiHelper
                                                                      .leaveHouse(
                                                                    houseId: snapshot
                                                                            .data![
                                                                        "rentedHouse"]!["id"],
                                                                    userId: snapshot
                                                                            .data![
                                                                        "id"],
                                                                    image: File(
                                                                        pickedFile!
                                                                            .path),
                                                                  ).then(
                                                                      (value) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                child: const Text(
                                                                    'Take Photo'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    showDialog(
                                                        context: navigatorKey
                                                            .currentContext!,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Please lock the door before you leave house.'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      navigatorKey
                                                                          .currentContext!);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                                  child: Text(
                                                    "LEAVE HOME",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              });
        });
  }
}
