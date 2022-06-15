import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:turtle/api_helper.dart';
import 'package:turtle/auth/auth_service.dart';
import 'package:turtle/constants.dart';
import 'package:turtle/fade_route.dart';
import 'package:turtle/main.dart';
import 'package:turtle/marker_converter.dart';

import 'cache_image_helper.dart';
import 'house_photos.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userId}) : super(key: key);
  final int userId;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(navigatorKey.currentContext!);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: kDarkBlue,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 14.0),
                    child: Text(
                      "Menu",
                      style: TextStyle(
                        color: kDarkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color(0xFFA8ABAF),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: MediaQuery.of(context).size.width - 50.0,
                height: 30,
              ),
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: SelectLocationPage(userId: widget.userId),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Publish House",
                      style: TextStyle(
                        color: kDarkBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 18.0),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0xFF424C52),
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color(0xFFA8ABAF),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: MediaQuery.of(context).size.width - 50.0,
                height: 30,
              ),
              child: RawMaterialButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: MyHouses(
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "My Houses",
                      style: TextStyle(
                        color: kDarkBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 18.0),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0xFF424C52),
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color(0xFFA8ABAF),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: MediaQuery.of(context).size.width - 50.0,
                height: 30,
              ),
              child: RawMaterialButton(
                onPressed: () async {
                  await AuthService.logOut();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: kDarkBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 18.0),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0xFF424C52),
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddHousePage extends StatefulWidget {
  const AddHousePage(
      {Key? key,
      required this.userId,
      required this.latCoordinate,
      required this.longCoordinate,
      required this.countryList})
      : super(key: key);
  final int userId;
  final double latCoordinate;
  final double longCoordinate;
  final List countryList;

  @override
  State<AddHousePage> createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  final TextEditingController _monthlyRentController = TextEditingController();
  final TextEditingController _dailyRentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _doubleBedCountController =
      TextEditingController();
  final TextEditingController _singleBedCountController =
      TextEditingController();
  final TextEditingController _singleSeatCountController =
      TextEditingController();
  final TextEditingController _doubleSeatCountController =
      TextEditingController();
  final TextEditingController _tripleSeatCountController =
      TextEditingController();
  final TextEditingController _peopleStayCountController =
      TextEditingController();
  bool hasWifi = false;
  bool hasHeater = false;
  bool hasTv = false;
  bool hasKitchen = false;
  bool hasLaundry = false;
  int? countryId;
  int? cityId;
  int? districtId;

  List districtList = [];

  List cityList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(navigatorKey.currentContext!);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: kDarkBlue,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child: Text(
                        "Publish House",
                        style: TextStyle(
                          color: kDarkBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 12.0,
                  ),
                ),
                keyboardType: TextInputType.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              TextField(
                controller: _dailyRentController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  labelText: "Daily Rent",
                  labelStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 12.0,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              TextField(
                controller: _monthlyRentController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  labelText: "Monthly Rent",
                  labelStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 12.0,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              DropdownButtonFormField<int?>(
                items: widget.countryList.map((e) {
                  return DropdownMenuItem<int?>(
                    child: Text(
                      e["name"],
                      style: const TextStyle(color: Colors.black),
                    ),
                    value: e["id"],
                  );
                }).toList(),
                value: countryId,
                iconEnabledColor: const Color(0xFF998FA2),
                iconDisabledColor: const Color(0xFF998FA2),
                iconSize: 24.0,
                onTap: () {},
                onChanged: (i) async {
                  setState(() {
                    countryId = i;
                    cityId = null;
                    districtId = null;
                    ApiHelper.getCities(i).then((value) {
                      cityList = value;
                    });
                  });
                },
                dropdownColor: const Color(0xFFEEEEEE),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: "Country",
                  labelStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              DropdownButtonFormField<int?>(
                items: cityList.map((e) {
                  return DropdownMenuItem<int?>(
                    child: Text(
                      e["name"],
                      style: const TextStyle(color: Colors.black),
                    ),
                    value: e["id"],
                  );
                }).toList(),
                value: cityId,
                iconEnabledColor: const Color(0xFF998FA2),
                iconDisabledColor: const Color(0xFF998FA2),
                iconSize: 24.0,
                onTap: () {},
                onChanged: (i) async {
                  setState(() {
                    cityId = i;
                    districtId = null;
                    ApiHelper.getDistricts(i).then((value) {
                      districtList = value;
                    });
                  });
                },
                dropdownColor: const Color(0xFFEEEEEE),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: "City",
                  labelStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              DropdownButtonFormField<int?>(
                items: districtList.map((e) {
                  return DropdownMenuItem<int?>(
                    child: Text(
                      e["name"],
                      style: const TextStyle(color: Colors.black),
                    ),
                    value: e["id"],
                  );
                }).toList(),
                value: districtId,
                iconEnabledColor: const Color(0xFF998FA2),
                iconDisabledColor: const Color(0xFF998FA2),
                iconSize: 24.0,
                onTap: () {},
                onChanged: (i) async {
                  setState(() {
                    districtId = i;
                  });
                },
                dropdownColor: const Color(0xFFEEEEEE),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: "District",
                  labelStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                    child: TextField(
                      controller: _singleBedCountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Single Bed Count",
                        labelStyle: const TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 12.0,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                    child: TextField(
                      controller: _doubleBedCountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Double Bed Count",
                        labelStyle: const TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 12.0,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                    child: TextField(
                      controller: _singleSeatCountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Single Seat Count",
                        labelStyle: const TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 12.0,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                    child: TextField(
                      controller: _doubleSeatCountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Double Seat Count",
                        labelStyle: const TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 12.0,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                    child: TextField(
                      controller: _tripleSeatCountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Triple Seat Count",
                        labelStyle: const TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 12.0,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                    child: TextField(
                      controller: _peopleStayCountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: "People Stays",
                        labelStyle: const TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 12.0,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                    child: CheckboxListTile(
                      value: hasWifi,
                      onChanged: (b) {
                        setState(() {
                          hasWifi = b!;
                        });
                      },
                      title: const Text(
                        "Wifi",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                    child: CheckboxListTile(
                      value: hasHeater,
                      onChanged: (b) {
                        setState(() {
                          hasHeater = b!;
                        });
                      },
                      title: const Text(
                        "Heater",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                    child: CheckboxListTile(
                      value: hasTv,
                      onChanged: (b) {
                        setState(() {
                          hasTv = b!;
                        });
                      },
                      title: const Text(
                        "TV",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                    child: CheckboxListTile(
                      value: hasKitchen,
                      onChanged: (b) {
                        setState(() {
                          hasKitchen = b!;
                        });
                      },
                      title: const Text(
                        "Kitchen",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6.0,
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 64) / 2 - 8.0,
                child: CheckboxListTile(
                  value: hasLaundry,
                  onChanged: (b) {
                    setState(() {
                      hasLaundry = b!;
                    });
                  },
                  title: const Text(
                    "Laundry",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(const Size(40, 40)),
                  backgroundColor: MaterialStateProperty.all(
                    kPurpleBlue,
                  ),
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: () async {
                  if (await ApiHelper.addHouse(
                    title: _titleController.text,
                    priceDaily: _dailyRentController.text,
                    priceMonthly: _monthlyRentController.text,
                    latCoordinate: widget.latCoordinate,
                    longCoordinate: widget.longCoordinate,
                    hasInternet: hasWifi,
                    hasHeater: hasHeater,
                    hasTv: hasTv,
                    hasKitchen: hasKitchen,
                    hasLaundry: hasLaundry,
                    doubleBedCount: _doubleBedCountController.text,
                    singleBedCount: _singleBedCountController.text,
                    singleSeatCount: _singleSeatCountController.text,
                    doubleSeatCount: _doubleSeatCountController.text,
                    tripleSeatCount: _tripleSeatCountController.text,
                    peopleStayCount: _peopleStayCountController.text,
                    countryId: countryId!,
                    cityId: cityId!,
                    districtId: districtId!,
                    userId: widget.userId,
                  )) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "PUBLISH",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHouses extends StatefulWidget {
  const MyHouses({Key? key, required this.userId}) : super(key: key);
  final int userId;
  @override
  State<MyHouses> createState() => _MyHousesState();
}

class _MyHousesState extends State<MyHouses> {
  final picker = ImagePicker();

  Future pickImage({required ImageSource source, required int houseId}) async {
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 30,
    );
    await Navigator.push(
      context,
      FadeRoute(
        page: ApplyPhotoPage(
          houseId: houseId,
          image: File(pickedFile!.path),
        ),
      ),
    ).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        title: const Text("My Houses"),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List>(
          future: ApiHelper.getHousesViaOwner(
            userId: widget.userId,
          ),
          builder: (context, housesSnapshot) {
            if (!housesSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kDarkBlue,
                ),
              );
            }
            if (housesSnapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "You didn't publish houses yet.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: housesSnapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: (MediaQuery.of(context).size.width - 310) / 2,
                      vertical: 6.0),
                  child: InkWell(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  "Do you want to delete the house?"),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await ApiHelper.deleteHouse(
                                        houseId: housesSnapshot.data![index]
                                            ["id"]);
                                    Navigator.pop(navigatorKey.currentContext!);
                                    setState(() {});
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(navigatorKey.currentContext!);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: kDarkBlue,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      height: 134.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.90),
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.5),
                            width: 2.0,
                          )),
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
                                      future: ApiHelper.getHousePhotos(
                                        housesSnapshot.data![index]["id"],
                                      ),
                                      builder: (context, photosSnapshot) {
                                        if (!photosSnapshot.hasData) {
                                          return Container(
                                            height: 60.0,
                                            width: 110.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/defaultHousePhoto.png",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
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
                                                          photosSnapshot.data!),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 60.0,
                                            width: 110.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              image: DecorationImage(
                                                image: photosSnapshot
                                                        .data!.isEmpty
                                                    ? const AssetImage(
                                                        "assets/images/defaultHousePhoto.png",
                                                      )
                                                    : CacheImageProvider(
                                                        housesSnapshot
                                                            .data![index]["id"]
                                                            .toString(),
                                                        base64Decode(
                                                            photosSnapshot.data!
                                                                    .first[
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        housesSnapshot.data![index]["title"],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Text(
                                        "${housesSnapshot.data![index]["priceDaily"]}₺ (1 Day) / ${housesSnapshot.data![index]["priceMonthly"]}₺ ( 1 Month)",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 9.0,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        const Color(0xFF838BF8),
                                      ),
                                      elevation: MaterialStateProperty.all(0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero),
                                    ),
                                    onPressed: () async {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.camera_alt),
                                                title: const Text('Kamera'),
                                                onTap: () async {
                                                  await pickImage(
                                                    houseId: housesSnapshot
                                                        .data![index]["id"],
                                                    source: ImageSource.camera,
                                                  );
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.photo),
                                                title: const Text('Galeri'),
                                                onTap: () async {
                                                  await pickImage(
                                                      houseId: housesSnapshot
                                                          .data![index]["id"],
                                                      source:
                                                          ImageSource.gallery);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        "ADD PHOTO",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        const Color(0xFFFF7B79),
                                      ),
                                      elevation: MaterialStateProperty.all(0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero),
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        FadeRoute(
                                          page: MessagesPage(
                                            houseId: housesSnapshot.data![index]
                                                ["id"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        "MESSAGES",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
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
                );
              },
            );
          }),
    );
  }
}

class ApplyPhotoPage extends StatefulWidget {
  const ApplyPhotoPage({
    Key? key,
    required this.houseId,
    required this.image,
  }) : super(key: key);
  final int houseId;
  final File image;

  @override
  _ApplyPhotoPageState createState() => _ApplyPhotoPageState();
}

class _ApplyPhotoPageState extends State<ApplyPhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () async {
              await ApiHelper.addHousePhoto(
                image: widget.image,
                houseId: widget.houseId,
              );
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: PhotoView(
        customSize: MediaQuery.of(context).size,
        imageProvider: FileImage(widget.image),
      ),
    );
  }
}

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key, required this.houseId}) : super(key: key);
  final int houseId;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        title: const Text("Messages"),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List>(
          future: ApiHelper.getHouseMessages(
            houseId: widget.houseId,
          ),
          builder: (context, messagesSnapshot) {
            if (!messagesSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kDarkBlue,
                ),
              );
            }
            if (messagesSnapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "There is no message for this house.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: messagesSnapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: (MediaQuery.of(context).size.width - 310) / 2,
                      vertical: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        messagesSnapshot.data![index]["message"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFA8ABAF),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({Key? key, required this.userId}) : super(key: key);
  final int userId;
  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  late GoogleMapController _mapController;
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(navigatorKey.currentContext!);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 14.0),
                  child: Text(
                    "Select Location",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 84.0,
            child: GoogleMap(
              myLocationEnabled: true,
              markers: markers,
              mapType: MapType.normal,
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
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: markers.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () async {
                Navigator.push(
                  context,
                  FadeRoute(
                    page: AddHousePage(
                      userId: widget.userId,
                      latCoordinate: markers.first.position.latitude,
                      longCoordinate: markers.first.position.longitude,
                      countryList: await ApiHelper.getCountries(),
                    ),
                  ),
                );
              },
              label: const Text('Use This Location'),
            )
          : null,
    );
  }
}
