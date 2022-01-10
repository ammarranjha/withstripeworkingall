import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pool_your_car/constants.dart';
import 'package:pool_your_car/models/Directions.dart';


class DirectionsRepo {
  final Dio _dio = Dio();

  Future<Directions> getDirection({LatLng origin, LatLng destination}) async {
    const String _url = 'https://maps.googleapis.com/maps/api/directions/json?';
    try{
      final Response response = await _dio.get(
        _url,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': googleApiKey
        }
      ).onError((error, stackTrace){
        return throw 'Error in Direction';
      });

      if (response.statusCode == 200){
        return Directions.fromJson(response.data as Map<String, dynamic>);
      }
      return throw 'Error in Direction';
    }catch(err){
      return throw 'Error in Direction';
    }    
  }
}
