import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMap extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(-37, 144)));
  }

}