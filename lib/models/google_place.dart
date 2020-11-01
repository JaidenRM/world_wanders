import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:world_wanders/utils/helpers.dart';
import 'package:world_wanders/utils/secrets.dart';

class GooglePlace extends Equatable {
  static const String _photoUrl = "https://maps.googleapis.com/maps/api/place/photo";
  
  final String placeId;
  
  final LatLng location;
  final bool isOpenNow;
  final bool isPermClosed;
  final List<String> photoUrls;
  final List<String> types;
  final PriceRange price;
  //bw 1.0 - 5.0
  final num rating;
  final int numOfRatings;

  final String name;
  final String plusCodeGlobal;
  final String vicinity;
  final String address;
  final String iconUrl;

  bool _isSaved;

  bool get hasUserSavedPlace => _isSaved == true ? true : false;
  set hasUserSavedPlace(bool isSaved) => _isSaved = isSaved;

  GooglePlace({
    this.placeId, this.location, this.isOpenNow, this.isPermClosed,
    this.photoUrls, this.price, this.rating, this.name, this.plusCodeGlobal,
    this.vicinity, this.address, this.types, this.iconUrl, this.numOfRatings
  });
  
  @override
  List<Object> get props => [
    this.placeId, this.location, this.isOpenNow, this.isPermClosed,
    this.photoUrls, this.price, this.rating, this.name, this.plusCodeGlobal,
    this.vicinity, this.address, this.types, this.iconUrl, this.numOfRatings
  ];

  factory GooglePlace.fromJson(Map<dynamic, dynamic> json) => _gPlaceFromJson(json);
  //Map<String, dynamic> toJson() => _gPlaceToJson(this);

  static String createPlacesPhotoRequestUrl(
    String photoRef, { 
      int maxWidth = PlacesConstants.PHOTO_MAX_WIDTH, 
      int maxHeight = PlacesConstants.PHOTO_MAX_HEIGHT,
  }) {
    if(maxWidth == null || maxWidth < 1 || maxWidth > PlacesConstants.PHOTO_MAX_WIDTH) {
      maxWidth = PlacesConstants.PHOTO_MAX_WIDTH;
    }
    if(maxHeight == null || maxHeight < 1 || maxHeight > PlacesConstants.PHOTO_MAX_HEIGHT) {
      maxHeight = PlacesConstants.PHOTO_MAX_HEIGHT;
    }

    return "$_photoUrl?${PlacesConstants.PARM_KEY}=${Secrets.GOOGLE_API_KEY}"
      + "&${PlacesConstants.PARM_MAX_HEIGHT}=$maxHeight"
      + "&${PlacesConstants.PARM_MAX_WIDTH}=$maxWidth"
      + "&${PlacesConstants.PARM_PHOTO_REF}=$photoRef";
  }

  String stringifyTypes() {
    List<String> humanisedStrings = [];

    types.forEach((element) { 
      humanisedStrings.add(Helpers.humanise(element));
    });

    return humanisedStrings.join(", ");
  }
}

//helpers
// Map<String, dynamic> _gPlaceToJson(GooglePlace gPlace) {
//   return <String, dynamic> {
//     'place_id': gPlace.placeId,
//     'geometry': { 
//       'location': { 
//         'lat': gPlace.location.latitude,
//         'lng': gPlace.location.longitude,
//       }
//     },
//     'opening_hours': {
//       'open_now': gPlace.isOpenNow,
//     },
//     ''
//   };
// }

GooglePlace _gPlaceFromJson(Map<dynamic, dynamic> json) {
  final hasLocation = json.containsKey('geometry') && (json['geometry'] as Map).containsKey('location');
  final hasOpenNow = json.containsKey('opening_hours') && (json['opening_hours'] as Map).containsKey('open_now');
  List<String> urls = [];

  if(json.containsKey('photos')) {
    (json['photos'] as List).forEach((key) {
      Map map = key;
      if(map.containsKey('photo_reference')) {
        final url = GooglePlace.createPlacesPhotoRequestUrl(map['photo_reference']);
        urls.add(url);
      }
    });
  }

  return GooglePlace(
    placeId: json.containsKey('place_id') ? json['place_id'] : null,
    location: hasLocation ?
      LatLng(json['geometry']['location']['lat'], json['geometry']['location']['lng']) :
      null,
    name: json.containsKey('name') ? json['name'] : null,
    isOpenNow: hasOpenNow ? json['opening_hours']['open_now'] : null,
    photoUrls: urls.length > 0 ? urls : null,
    price: json.containsKey('price_level') ? PriceRange.values[json['price_level']] : null,
    rating: json.containsKey('rating') ? json['rating'] : null,
    types: json.containsKey('types') ? (json['types'] as List<dynamic>).cast<String>() : null,
    vicinity: json.containsKey('vicinity') ? json['vicinity'] : null,
    address: json.containsKey('formatted_address') ? json['formatted_address'] : null,
    isPermClosed: json.containsKey('permanently_closed') ? json['permanently_closed'] : null,
    iconUrl: json.containsKey('icon') ? json['icon'] : null,
    plusCodeGlobal: json.containsKey('plus_code') ? json['plus_code']['global_code'] : null,
    numOfRatings: json.containsKey('user_ratings_total') ? json['user_ratings_total'] : null,
  );
}