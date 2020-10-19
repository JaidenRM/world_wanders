import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/services/places_request.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:world_wanders/utils/helpers.dart';

class TextSearchRequest extends PlacesRequest {
  final Logger _logger;
  static const String _name = "TextSearchRequest";
  Map<String, dynamic> _params = {};

  @override
  String get requestUrl {
    return super.requestUrl + Helpers.mapToQueryParametersString(_params, false);
  }

  TextSearchRequest({ @required String query })
    : assert(query != null),
      _logger = getLogger(_name),
      super(
        PlacesConstants.REQ_TYPE_TEXT, 
        PlacesConstants.FORMAT_JSON
      ) 
    {
      _params[PlacesConstants.PARM_QUERY] = query;
    }

  void addRegion(String region) {
    if(region?.length != PlacesConstants.PARM_REGION_LENGTH) {
      _logger.e(
        'Region was not equal to ${PlacesConstants.PARM_REGION_LENGTH}' +
        'characters and was ${region?.length} characters instead.'
      );
    } else {
      _params[PlacesConstants.PARM_REGION] = region;
    } 
  }

  void addLocation(LatLng latLng, double radius) {
    if(radius == null) {
      _logger.e('Radius must be provided');
      return;
    } else if(latLng == null) {
      _logger.e('LatLng must be provided');
    } else {
      _params[PlacesConstants.PARM_LOCATION] = "${latLng.latitude},${latLng.longitude}";
      addRadius(radius);
    }
  }

  void addRadius(double radiusInMetres) {
    if(radiusInMetres == null) {
      _logger.e('Radius must be provided');
    } else if(radiusInMetres > PlacesConstants.PARM_RADIUS_MAX) {
      _logger.e('Radius of $radiusInMetres cannot exceed the maximum of ${PlacesConstants.PARM_RADIUS_MAX}');
    } else {
      _params[PlacesConstants.PARM_RADIUS] = radiusInMetres;
    }
  }

  void addLanguage(String languageCode) {
    if(languageCode == null)
      _logger.e('Language code not provided');
    else
      _params[PlacesConstants.PARM_LANGUAGE] = languageCode;
  }

  //places with no price range will be excluded
  void addPriceRange(PriceRange min, { PriceRange max }) {
    if(min == null) {
      _logger.e('No min range provided');
    } else {
      _params[PlacesConstants.PARM_MIN_PRICE] = min.index;
      if(max != null)
        _params[PlacesConstants.PARM_MAX_PRICE] = max.index;
    }
  }

  //places with no opening hours will not be returned
  void addOpenNow({ bool isOpen = true }) {
    _params[PlacesConstants.PARM_OPEN_NOW] = isOpen;
  }

  void addPageToken(String token) {
    if(token == null)
      _logger.e('Page token not provided');
    else
      _params[PlacesConstants.PARM_PAGE_TOKEN] = token;
  }

  void addType(String type) {
    if(PlacesConstants.PARM_TYPE_VALUES.contains(type)) {
      _params[PlacesConstants.PARM_TYPE] = type;
    } else {
      _logger.e('Type was not provided or not supported');
    }
  }
  
}