import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class PlacesWidget extends Equatable {
  final String placeId;
  final LatLng location;

  PlacesWidget(this.placeId, this.location);
  
  Widget toListTile(BuildContext context);
}