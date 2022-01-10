import 'package:dio/dio.dart';
import 'package:pool_your_car/constants.dart';
import 'package:pool_your_car/models/Directions.dart';


class DirectionsRepoSearch {
  final Dio _dio = Dio();

  Future<Directions> getDirection({String origin, String destination}) async {
    const String _url = 'https://maps.googleapis.com/maps/api/directions/json?';

    final Response response = await _dio.get(
      _url,
      queryParameters: {
        'origin': origin,
        'destination': destination,
        'key': googleApiKey
      }
    );

    if (response.statusCode == 200){
      return Directions.fromJson(response.data as Map<String, dynamic>);
    }

    return throw 'Error in Direction';
  }
}
