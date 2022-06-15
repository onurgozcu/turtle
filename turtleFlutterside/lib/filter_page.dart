import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtle/fade_route.dart';
import 'package:turtle/main.dart';
import 'package:turtle/map_page.dart';

import 'api_helper.dart';
import 'constants.dart';

class FilterPage extends StatefulWidget {
  const FilterPage(
      {Key? key,
      required this.filters,
      required this.countryList,
      required this.cityList,
      required this.districtList})
      : super(key: key);
  final Map filters;
  final List countryList;
  final List cityList;
  final List districtList;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final TextEditingController _minPriceMonthlyController =
      TextEditingController();
  final TextEditingController _maxPriceMonthlyController =
      TextEditingController();
  final TextEditingController _minPriceDailyController =
      TextEditingController();
  final TextEditingController _maxPriceDailyController =
      TextEditingController();
  final TextEditingController _minPeopleStayController =
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
  void initState() {
    cityList = widget.cityList;
    districtList = widget.districtList;
    _minPriceMonthlyController.text = widget.filters["minPriceMonthly"];
    _maxPriceMonthlyController.text = widget.filters["maxPriceMonthly"];
    _minPriceDailyController.text = widget.filters["minPriceDaily"];
    _maxPriceDailyController.text = widget.filters["maxPriceDaily"];
    _minPeopleStayController.text = widget.filters["minPeopleStay"];
    hasWifi = widget.filters["hasInternet"];
    hasHeater = widget.filters["hasHeater"];
    hasTv = widget.filters["hasTV"];
    hasKitchen = widget.filters["hasKitchen"];
    hasLaundry = widget.filters["hasLaundry"];
    countryId = widget.filters["countryId"];
    cityId = widget.filters["cityId"];
    districtId = widget.filters["districtId"];
    super.initState();
  }

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
                        "Filter Houses",
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
                controller: _minPeopleStayController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  labelText: "Min People Can Stay",
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
                controller: _minPriceDailyController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  labelText: "Min Daily Rent",
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
                controller: _maxPriceDailyController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  labelText: "Max Daily Rent",
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
                controller: _minPriceMonthlyController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  labelText: "Min Monthly Rent",
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
                controller: _maxPriceMonthlyController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  labelText: "Max Monthly Rent",
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
                width: (MediaQuery.of(context).size.width - 64) / 2,
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
                  Navigator.pushReplacement(
                    context,
                    FadeRoute(
                      page: MapPage(
                        initialFilters: {
                          "countryId": countryId,
                          "cityId": cityId,
                          "districtId": districtId,
                          "minPriceDaily": _minPriceDailyController.text,
                          "maxPriceDaily": _maxPriceDailyController.text,
                          "minPriceMonthly": _minPriceMonthlyController.text,
                          "maxPriceMonthly": _maxPriceMonthlyController.text,
                          "minPeopleStay": _minPeopleStayController.text,
                          "hasInternet": hasWifi,
                          "hasLaundry": hasLaundry,
                          "hasKitchen": hasKitchen,
                          "hasHeater": hasHeater,
                          "hasTV": hasTv,
                        },
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "FILTER",
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
