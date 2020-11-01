import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/services/places_request.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:world_wanders/utils/helpers.dart';

import 'logger.dart';

class NearbyPlaceRequest extends PlacesRequest {
  final Logger _logger;
  static const String _name = "NearbyPlaceRequest";
  Map<String, dynamic> _params = {};

  @override
  String get requestUrl {
    return super.requestUrl + Helpers.mapToQueryParametersString(_params, false);
  }

  NearbyPlaceRequest(LatLng latLng, int radiusInMeters) 
    : assert(radiusInMeters != null && radiusInMeters > 0 && radiusInMeters <= PlacesConstants.PARM_RADIUS_MAX),
    _logger = getLogger(_name),
      super(
        PlacesConstants.REQ_TYPE_NEARBY,
        PlacesConstants.FORMAT_JSON
      )
    {
      _params[PlacesConstants.PARM_RADIUS] = radiusInMeters;
      _params[PlacesConstants.PARM_LOCATION] = "${latLng.latitude},${latLng.longitude}";
    }

  void addKeyword(String keyword) {
    _params[PlacesConstants.PARM_KEYWORD] = keyword;
  }

  void addLanguageCode(String langCode) {
    _params[PlacesConstants.PARM_LANGUAGE] = langCode;
  }

  void addPriceRange(PriceRange min, { PriceRange max }) {
    if(min == null) {
      _logger.e('No min range provided');
    } else {
      _params[PlacesConstants.PARM_MIN_PRICE] = min.index;
      if(max != null)
        _params[PlacesConstants.PARM_MAX_PRICE] = max.index;
    }
  }

  void addOpenNow({ bool isOpen = true }) {
    _params[PlacesConstants.PARM_OPEN_NOW] = isOpen;
  }

  void addRankBy(RankBy ranking) {
    switch(ranking) {
      case RankBy.Prominence:
        _params[PlacesConstants.PARM_RANK_BY] = ranking.parseToString().toLowerCase();
        break;
      case RankBy.Distance:
        _params[PlacesConstants.PARM_RANK_BY] = ranking.parseToString().toLowerCase();
        //radius cannot exist with the above key,value combo
        _params[PlacesConstants.PARM_RADIUS] = null;
        break;
      default:
        _logger.e("Could not act on $ranking because it was not found in the switch");
        break;
    }
  }

  void addType(String type) {
    if(PlacesConstants.PARM_TYPE_VALUES.contains(type)) {
      _params[PlacesConstants.PARM_TYPE] = type;
    } else {
      _logger.e('Type was not provided or not supported');
    }
  }
}