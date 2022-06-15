import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const Color kPurpleBlue = Color(0xFF6277D7);
const Color kDarkBlue = Color(0xFF2B5E86);
const Color kPink = Color(0xFFFE9ECC);

const String kApiUrl = "https://onurgozcu.com/turtle/api/";
const Map<String, String> kHeader = {
  "Authorization": "Bearer xxx",
  "Accept": "application/json",
  "Content-Type": "application/x-www-form-urlencoded"
};
const CameraPosition kCameraLocation = CameraPosition(
  target: LatLng(39.7839137, 30.5084524),
  zoom: 10,
);
