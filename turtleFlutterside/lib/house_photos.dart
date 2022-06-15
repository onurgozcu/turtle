import 'dart:convert';

import 'package:flutter/material.dart';

import 'cache_image_helper.dart';
import 'constants.dart';

class HousePhotos extends StatefulWidget {
  const HousePhotos({Key? key, required this.housePhotos}) : super(key: key);
  final List housePhotos;

  @override
  State<HousePhotos> createState() => _HousePhotosState();
}

class _HousePhotosState extends State<HousePhotos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        title: const Text("House Photos"),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: widget.housePhotos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Image(
              image: CacheImageProvider(
                widget.housePhotos[index]["id"].toString(),
                base64Decode(widget.housePhotos[index]["photo"]),
              ),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
