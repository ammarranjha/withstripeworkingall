import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Steps {
  Steps({
    this.endLocation,
    this.startLocation,
    this.distance,
    this.duration,
    this.address,
    this.explanation,
    this.polylinepoints,
    this.travelMode,
  });

  factory Steps.fromMap(Map<String, dynamic> map) {
    return Steps(
      endLocation: LatLng(map['end_location']['lat'] as double, map['end_location']['lng'] as double),
      startLocation: LatLng(map['start_location']['lat'] as double ,map['start_location']['lng'] as double),
      distance: map['distance']['text'] as String,
      duration: map['duration']['text'] as String,
      address: map['html_instructions'] as String,
      explanation: map['maneuver']  as String,
      polylinepoints: PolylinePoints().decodePolyline(map['polyline']['points'] as String),
      travelMode: map['travel_mode'] as String,
    );
  }

  factory Steps.fromJson(String source) => Steps.fromMap(json.decode(source) as Map<String, dynamic>);


  final LatLng endLocation;
  final LatLng startLocation;
  final String distance;
  final String duration;
  final String address;
  final String explanation;
  final List<PointLatLng> polylinepoints;
  final String travelMode;
}
