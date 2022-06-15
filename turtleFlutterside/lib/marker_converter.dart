import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerConverter {
  static final MarkerConverter _singleton = MarkerConverter._internal();
  MarkerConverter._internal();
  late BitmapDescriptor marker;
  factory MarkerConverter() {
    return _singleton;
  }
  Future convertMarker() async {
    MarkerConverter().marker = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)),
            'assets/images/houseMarker.png')
        .then((onValue) {
      return onValue;
    });
  }

  BitmapDescriptor getMarker() {
    return MarkerConverter().marker;
  }
}
