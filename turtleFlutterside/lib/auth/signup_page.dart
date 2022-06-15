import 'package:flutter/material.dart';
import 'package:turtle/api_helper.dart';

import '../constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _realNameController = TextEditingController();

  int? selectedCountry;
  int? selectedCity;
  int? selectedDistrict;

  List cityList = [];

  List districtList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          color: kDarkBlue,
          child: FutureBuilder<List>(
              future: ApiHelper.getCountries(),
              builder: (context, countriesSnapshot) {
                if (!countriesSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 36.0,
                                top: 4.0,
                              ),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _realNameController,
                                decoration: InputDecoration(
                                  hintText: "Name Surname",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFDEDEDE),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: kPurpleBlue,
                                  focusColor: const Color(0xFF89AEFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 12.0,
                                  ),
                                ),
                                keyboardType: TextInputType.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                controller: _mailController,
                                decoration: InputDecoration(
                                  hintText: "E-mail",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFDEDEDE),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: kPurpleBlue,
                                  focusColor: const Color(0xFF89AEFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 12.0,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: "Username",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFDEDEDE),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: kPurpleBlue,
                                  focusColor: const Color(0xFF89AEFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 12.0,
                                  ),
                                ),
                                keyboardType: TextInputType.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              DropdownButtonFormField<int?>(
                                items: countriesSnapshot.data!.map((e) {
                                  return DropdownMenuItem<int?>(
                                    child: Text(
                                      e["name"],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    value: e["id"],
                                  );
                                }).toList(),
                                value: selectedCountry,
                                iconEnabledColor: const Color(0xFF998FA2),
                                iconDisabledColor: const Color(0xFF998FA2),
                                iconSize: 24.0,
                                onTap: () {},
                                onChanged: (i) async {
                                  setState(() {
                                    selectedCountry = i;
                                    selectedCity = null;
                                    selectedDistrict = null;
                                  });
                                  ApiHelper.getCities(i).then((value) {
                                    cityList = value;
                                  });
                                },
                                dropdownColor: kDarkBlue,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Country",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFDEDEDE),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: kPurpleBlue,
                                  focusColor: const Color(0xFF89AEFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 12.0,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              DropdownButtonFormField<int?>(
                                items: cityList.map((e) {
                                  return DropdownMenuItem<int?>(
                                    child: Text(
                                      e["name"],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    value: e["id"],
                                  );
                                }).toList(),
                                value: selectedCity,
                                iconEnabledColor: const Color(0xFF998FA2),
                                iconDisabledColor: const Color(0xFF998FA2),
                                iconSize: 24.0,
                                onTap: () {},
                                onChanged: (i) async {
                                  setState(() {
                                    selectedCity = i;
                                    selectedDistrict = null;
                                  });
                                  ApiHelper.getDistricts(i).then((value) {
                                    districtList = value;
                                  });
                                },
                                dropdownColor: kDarkBlue,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: "City",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFDEDEDE),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: kPurpleBlue,
                                  focusColor: const Color(0xFF89AEFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 12.0,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              DropdownButtonFormField<int?>(
                                items: districtList.map((e) {
                                  return DropdownMenuItem<int?>(
                                    child: Text(
                                      e["name"],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    value: e["id"],
                                  );
                                }).toList(),
                                value: selectedDistrict,
                                iconEnabledColor: const Color(0xFF998FA2),
                                iconDisabledColor: const Color(0xFF998FA2),
                                iconSize: 24.0,
                                onTap: () {},
                                onChanged: (i) async {
                                  setState(() {
                                    selectedDistrict = i;
                                  });
                                },
                                dropdownColor: kDarkBlue,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: "District",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFDEDEDE),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: kPurpleBlue,
                                  focusColor: const Color(0xFF89AEFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 12.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder()),
                                      minimumSize: MaterialStateProperty.all(
                                        const Size(
                                          60,
                                          60,
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xFFFE9ECC)),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    onPressed: () async {
                                      if (selectedCity != null &&
                                          selectedDistrict != null &&
                                          selectedCountry != null &&
                                          _nameController.text.isNotEmpty &&
                                          _realNameController.text.isNotEmpty &&
                                          _mailController.text.isNotEmpty) {
                                        await ApiHelper.createAccount(
                                          name: _realNameController.text,
                                          userName: _nameController.text,
                                          email: _mailController.text,
                                          countryId: selectedCountry!,
                                          cityId: selectedCity!,
                                          districtId: selectedDistrict!,
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 32.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
