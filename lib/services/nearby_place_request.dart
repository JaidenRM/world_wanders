import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/services/places_request.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';

import 'logger.dart';

class NearbyPlaceRequest extends PlacesRequest {
  final Logger _logger;
  static const String _name = "NearbyPlaceRequest";
  Map<String, dynamic> _params = {};

  NearbyPlaceRequest(LatLng latLng, double radius, { bool useRankBy = false, String rankBy })
    : assert(useRankBy && rankBy != null || !useRankBy && radius != null),
    _logger = getLogger(_name),
      super(
        PlacesConstants.REQ_TYPE_NEARBY,
        PlacesConstants.FORMAT_JSON
      )
    {
      useRankBy ? 
        _params[PlacesConstants.PARM_RANK_BY] = rankBy :
        _params[PlacesConstants.PARM_RADIUS] = radius;
    }

}