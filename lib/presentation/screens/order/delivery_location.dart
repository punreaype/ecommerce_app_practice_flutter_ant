import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:practice_7/utils/extension.dart';

class DeliveryLocation extends StatefulWidget {
  const DeliveryLocation({super.key});

  @override
  State<DeliveryLocation> createState() => _DeliveryLocationState();
}

class _DeliveryLocationState extends State<DeliveryLocation> {
  var initialCameraPosition = const CameraPosition(
    target: LatLng(11.572543, 104.893275),
    zoom: 20,
  );

  var address = '';
  Timer? _timer;
  int _start = 2;

  void delayTwoSecondToGetAddress(LatLng location) {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          getLocationAddress(location);
        } else {
          _start--;
        }
      },
    );
  }

  void getLocationAddress(LatLng location) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          address =
              ' ${place.street ?? ''} ${place.subLocality ?? ''} ${place.locality ?? ''} ${place.subAdministrativeArea ?? ''} ${place.administrativeArea ?? ''} ${place.postalCode ?? ''} ${place.country ?? ''}'
                  .trim()
                  .replaceAll(RegExp(r'\n+'), '\n');
        });
      }
    } catch (e) {
      setState(() {
        address = 'Unable to fetch address';
      });
      print('Error fetching address: $e');
    }
  }

  // var initialCameraPosition = const CameraPosition(
  //   target: LatLng(11.572543, 104.893275),
  //   zoom: 20,
  // );

  // var address = '';
  // Timer? _timer;
  // int _start = 2;

  // void delayTwoSecondToGetAddress(LatLng location) {
  //   _timer?.cancel();
  //   _timer = Timer.periodic(
  //     const Duration(seconds: 1),
  //     (Timer timer) {
  //       if (_start == 0) {
  //         timer.cancel();
  //         getLocationAddress(location);
  //       } else {
  //         _start--;
  //       }
  //     },
  //   );
  // }

  // void getLocationAddress(LatLng location) {
  //   placemarkFromCoordinates(location.latitude, location.longitude)
  //       .then((value) {
  //     var _address = '';
  //     var mark = value.first;

  //     _address += '${mark.thoroughfare ?? ''}, ';

  //     _address += '${mark.subLocality ?? ''}, ';
  //     _address += mark.locality ?? '';
  //     setState(() {
  //       address = _address;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Delivery Location',
          style: TextStyle(
            color: Colors.black,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: initialCameraPosition,
                    onCameraMove: (position) async {
                      setState(() {
                        address = 'Loading ...';
                      });
                      delayTwoSecondToGetAddress(
                        position.target,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: (context.scrnHeight) / 2 - 64,
                  child: SizedBox(
                      height: 64,
                      child: Image.asset(
                        'assets/icons/pin.png',
                        width: 64,
                      )),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            height: context.scrnHeight * .15,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.scrnWidth * .05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                      ),
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.scrnHeight * .015,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        address,
                      );
                    },
                    child: Container(
                      height: context.scrnHeight * .05,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "SELECT THIS LOCATION",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
