import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pool_your_car/screens/map/components/final_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pool_your_car/constants.dart';
import 'package:pool_your_car/models/Directions.dart';
import 'package:pool_your_car/models/Steps.dart';

import 'components/direction_repo.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({this.info, Key key, this.ride}) : super(key: key);
  final Directions info;
  final String ride;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Marker _originMarker;
  Marker _destinationMarker;
  Marker _stepMarker;
  bool isRideStarted = false;

  Circle _stepCircle;
  Circle _accuracyCircle;
  Circle _locationCircle;
  Directions _info;
  Directions _routeInfo;
  Steps _currentStep;

  CameraPosition _myPosition;
  int _currentStepNum = 0;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _searchedDirections(widget.info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {
                if (_originMarker != null) _originMarker,
                if (_destinationMarker != null) _destinationMarker,
                if (_stepMarker != null) _stepMarker,
              },
              circles: {
                if (_locationCircle != null) _locationCircle,
                if (_stepCircle != null) _stepCircle,
                if (_accuracyCircle != null) _accuracyCircle,
              },
              polylines: {
                if (_info != null)
                  Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: Colors.redAccent,
                      width: 5,
                      points: _info.polylinespoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList()),
                if (_routeInfo != null)
                  Polyline(
                      polylineId: const PolylineId('distance_polyline'),
                      color: Colors.blueAccent,
                      width: 5,
                      points: _routeInfo.polylinespoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList()),
              },
            ),
          ),
          if (_info != null)
            Positioned(
              top: 10,
              child: Container(
                height: 220,
                width: MediaQuery.of(context).size.width - 20,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kPrimaryColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 2.5),
                        blurRadius: 6,
                      )
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Total Durationn: ${_info.totalDuration}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Total Distance: ${_info.totalDistance}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (_routeInfo != null)
                        Text(
                          'Duration: ${_routeInfo.totalDuration}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (_routeInfo != null)
                        Text(
                          'Distance: ${_routeInfo.totalDistance}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (_stepMarker != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Html(
                            data: _currentStep.address ?? '',
                            style: {
                              "*": Style(
                                display: Display.BLOCK,
                                whiteSpace: WhiteSpace.PRE,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                alignment: Alignment.center,
                                fontSize: FontSize.small,
                              ),
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          if (_info != null)
            Positioned(
                bottom: 10,
                right: 10,
                child: Card(
                  color: kPrimaryColor.withOpacity(0.7),
                  child: Container(
                    height: 140,
                    padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FloatingActionButton.extended(
                          backgroundColor: kPrimaryColor,
                          onPressed: () {
                            _startRide();
                          },
                          label: Text('Start Ride'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton.extended(
                          backgroundColor: kPrimaryColor,
                          onPressed: () {
                            _nextStep(index: 1);
                          },
                          label: const Text('steps'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton.extended(
                          backgroundColor: kPrimaryColor,
                          onPressed: () {
                            _nextStep(index: -1);
                          },
                          label: const Text('previous'),
                        ),
                      ],
                    ),
                  ),
                )),
          Positioned(
            bottom: 20,
            right: 20,
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_originMarker != null)
                    FloatingActionButton.extended(
                      backgroundColor: kPrimaryColor,
                      onPressed: _goToYourOrigin,
                      label: const Text('Origin'),
                    ),

                  const SizedBox(
                    width: 10,
                  ),

                  if (_destinationMarker != null)
                    FloatingActionButton.extended(
                      backgroundColor: kPrimaryColor,
                      onPressed: _goToYourDestination,
                      label: const Text('Dest'),
                    ),

                  const SizedBox(
                    width: 10,
                  ),

                  // if (isRideStarted)
                  FloatingActionButton.extended(
                    backgroundColor: kPrimaryColor,
                    onPressed: _endRide,
                    label: const Text('End Ride'),
                    icon: const Icon(Icons.directions_boat),
                  ),

                  // FloatingActionButton.extended(
                  //   backgroundColor: kPrimaryColor,
                  //   onPressed: _goToYourLocation,
                  //   label: const Text('Track Me'),
                  //   icon: const Icon(Icons.directions_boat),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String sharedprefenrenceid;

  Future<void> gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    String userid = prefs.getString("user");
    String _email = emailprefs.get("email");
    print("In home screen");
    print("User id in shared preference is " + json.decode(userid));
    print("user email in shared preference is " + json.decode(_email));
    sharedprefenrenceid = json.decode(userid);

    //GetUserDetails();
  }

  Future<void> _startRide() async {
    final String apiUrl = "$myip/api/ride/startride";
    var body =
        jsonEncode({'rideId': this.widget.ride, 'userId': sharedprefenrenceid});

    final response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"}, body: body);
    print("starting loader");

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> data = json.decode(response.body);
      print("In status 200");
      print(data['code']);
      if (data['state'] && data['code'] == 200) {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 20.0,
        );
        setState(() {
          isRideStarted = true;
        });
        _goToYourLocation();
      } else {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 20.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Failed, send request to passengers again',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 20.0,
      );
      // throw Exception('Failed to send request');
    }
  }

  Future<void> _endRide() async {
    final String apiUrl = "$myip/api/ride/endride";
    var body =
        jsonEncode({'rideId': this.widget.ride, 'userId': sharedprefenrenceid});

    final response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"}, body: body);
    print("starting loader");

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> data = json.decode(response.body);
      print("In status 200");
      print(data['code']);
      if (data['code'] == 200) {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 20.0,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FinalScreen(fare: data['deleteRide']['ridefare'] as int)));
      } else {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 20.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Server Error',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 20.0,
      );
      // throw Exception('Failed to send request');
    }
  }

  Future<void> _nextStep({int index = 0}) async {
    final GoogleMapController controller = await _controller.future;

    _currentStep = _info.steps[_currentStepNum];

    if (index == 0) {
      _currentStepNum = 0;
    } else if (index < 0) {
      if (_currentStepNum != 0) {
        _currentStepNum = _currentStepNum + index;
      }
    } else {
      if (_currentStepNum < _info.steps.length - 1) {
        _currentStepNum = _currentStepNum + index;
      }
    }

    ImageConfiguration configuration =
        createLocalImageConfiguration(context, size: Size(80, 80));
    BitmapDescriptor imageData = await BitmapDescriptor.fromAssetImage(
        configuration, 'assets/images/step.png');
    String info = Html(
            data: _info.steps[_currentStepNum].address != null
                ? _info.steps[_currentStepNum].address
                : '')
        .data;

    double rotation = Geolocator.bearingBetween(
        _info.steps[_currentStepNum].startLocation.latitude,
        _info.steps[_currentStepNum].startLocation.longitude,
        _info.steps[_currentStepNum].endLocation.latitude,
        _info.steps[_currentStepNum].endLocation.longitude);

    setState(() {
      _stepMarker = Marker(
          markerId: const MarkerId('step'),
          infoWindow: InfoWindow(title: info),
          flat: true,
          zIndex: 2,
          rotation: rotation,
          icon: imageData,
          anchor: Offset(0.5, 0.5),
          position: _info.steps[_currentStepNum].startLocation);

      _stepCircle = Circle(
          circleId: CircleId('step'),
          zIndex: 1,
          radius: 100,
          strokeWidth: 3,
          strokeColor: Colors.blue,
          center: _info.steps[_currentStepNum].startLocation,
          fillColor: Colors.blue.withAlpha(70));
    });

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _info.steps[_currentStepNum].startLocation,
        zoom: 16.2,
        tilt: 50)));
  }

  bool _isLocationClose(LatLng location, LatLng latLng) {
    bool isLatClose = (location.latitude <= latLng.latitude + 0.05) &&
        (location.latitude >= latLng.latitude - 0.05);
    bool isLonClose = (location.longitude <= latLng.longitude + 0.05) &&
        (location.longitude >= latLng.longitude - 0.05);
    return (isLatClose && isLonClose);
  }

  Future<Directions> getDirection({String origin, String destination}) async {
    Dio _dio = Dio();
    const String _url = 'https://maps.googleapis.com/maps/api/directions/json?';

    final Response response = await _dio.get(_url, queryParameters: {
      'origin': origin,
      'destination': destination,
      'key': googleApiKey
    });

    if (response.statusCode == 200) {
      return Directions.fromJson(response.data as Map<String, dynamic>);
    }

    return throw 'Error in Direction';
  }

  Future<void> _goToYourLocation() async {
    bool locationKnown = false;
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor imageData = await BitmapDescriptor.fromAssetImage(
        configuration, 'assets/images/step.png');

    Geolocator.getPositionStream().asBroadcastStream().listen((event) async {
      LatLng latLng = LatLng(event.latitude, event.longitude);

      _myPosition = CameraPosition(
        target: latLng,
        bearing: 192,
        zoom: 15.5,
        tilt: 50,
      );

      try {
        _routeInfo = await DirectionsRepo().getDirection(
            origin: LatLng(event.latitude, event.longitude),
            destination: _destinationMarker.position);
      } catch (err) {
        print(err);
      }

      if (_isLocationClose(latLng, _routeInfo.steps[0].startLocation)) {
        String info =
            Html(data: _routeInfo.steps[0].address ?? '').toStringDeep();
        setState(() {
          _stepMarker = Marker(
            markerId: const MarkerId('step'),
            infoWindow: InfoWindow(title: info),
            flat: true,
            zIndex: 1,
            icon: imageData,
            rotation: event.heading,
            anchor: Offset(0.5, 0.5),
            position: _routeInfo.steps[0].startLocation,
          );

          _stepCircle = Circle(
              circleId: CircleId('step'),
              zIndex: 2,
              radius: 180,
              strokeWidth: 3,
              strokeColor: Colors.blue,
              center: _routeInfo.steps[0].startLocation,
              fillColor: Colors.blue.withAlpha(70));
        });

        if (_currentStepNum < _info.steps.length)
          _currentStepNum = _info.steps.indexOf(_routeInfo.steps[0]);

        _currentStep = _routeInfo.steps[0];
      }

      setState(() {
        _locationCircle = Circle(
          circleId: const CircleId('location'),
          radius: 60,
          zIndex: 1,
          strokeColor: Colors.blue,
          strokeWidth: 1,
          center: latLng,
          fillColor: Colors.blue,
        );

        // _accuracyCircle= Circle(
        //   circleId: const CircleId('location'),
        //   radius: 120,
        //   strokeWidth: 3,
        //   zIndex: 2,
        //   strokeColor: Colors.blue,
        //   center: latLng,
        //   fillColor: Colors.blue.withAlpha(70)
        // );
      });

      if (!locationKnown) {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(_myPosition));
        locationKnown = true;
      }
    });
  }

  Future<void> _goToYourOrigin() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _originMarker.position, zoom: 15.5, tilt: 50)));
  }

  Future<void> _goToYourDestination() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _destinationMarker.position, zoom: 15.5, tilt: 50)));
  }

  Future<void> _searchedDirections(Directions info) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: info.startLocation,
      zoom: 14,
    )));

    controller.animateCamera(CameraUpdate.newLatLngBounds(info.bounds, 100));

    setState(() {
      _originMarker = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: InfoWindow(title: info.startAddress),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: info.startLocation);

      _destinationMarker = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: InfoWindow(title: info.endAddress),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          position: info.endLocation);
      _info = info;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
