import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Steps.dart';

class Directions{

  Directions({
    this.startAddress,
    this.endAddress,
    this.startLocation,
    this.endLocation,
    this.bounds,
    this.polylinespoints,
    this.totalDistance,
    this.totalDuration, 
    this.steps
  });

  factory Directions.fromJson (Map<String, dynamic> map){
    if ((map['routes'] as List).isEmpty) return throw 'List is Empty';

    final Map<String, dynamic> data = map['routes'][0] as Map<String, dynamic>;

    final Map<String, dynamic> northEast = data['bounds']['northeast']  as Map<String, dynamic>;
    final Map<String, dynamic> southWest = data['bounds']['southwest']  as Map<String, dynamic>;

    final  bounds = LatLngBounds(
      southwest: LatLng(southWest['lat'] as double, southWest['lng'] as double),
      northeast: LatLng(northEast['lat'] as double, northEast['lng'] as double),
    );

    final Map<String, dynamic> leg = data['legs'][0] as Map<String, dynamic>;

    final String startAddress = leg['start_address'] as String;
    final String endAddress = leg['end_address'] as String;
    final LatLng startLocation = LatLng(leg['start_location']['lat'] as double, leg['start_location']['lng'] as double);
    final LatLng endLocation = LatLng(leg['end_location']['lat'] as double, leg['end_location']['lng'] as double);

    final List<PointLatLng> polylinespoints = PolylinePoints().decodePolyline(data['overview_polyline']['points'] as String);
    final String distance = leg['distance']['text'] as String;
    final String duration = leg['duration']['text'] as String;

    final List<dynamic> stepList = leg['steps'] as List<dynamic>;

    final List<Steps> steps = stepList.map((e) => Steps.fromMap(e)).toList();

    return Directions(
      startAddress: startAddress,
      endAddress: endAddress,
      startLocation: startLocation,
      endLocation: endLocation,
      bounds: bounds,
      polylinespoints: polylinespoints,
      totalDistance: distance,
      totalDuration: duration,
      steps: steps
    );
  }


  final String startAddress;
  final String endAddress;
  final LatLng startLocation;
  final LatLng endLocation;
  final LatLngBounds bounds;
  final List<PointLatLng> polylinespoints;
  final String totalDistance;
  final String totalDuration;
  final List<Steps> steps;

}