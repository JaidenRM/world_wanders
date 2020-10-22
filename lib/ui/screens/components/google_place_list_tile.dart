import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/providers/places_provider.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/star_rating.dart';

class GooglePlaceListTile extends StatelessWidget {
  final GooglePlace _gPlace;

  GooglePlaceListTile({ @required GooglePlace gPlace})
    : assert(gPlace != null),
      _gPlace = gPlace;
  
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final placesProvider = Provider.of<PlacesProvider>(context);
    final isSelected = placesProvider.currPlaceId == _gPlace.placeId;
    final textStyle = isSelected ? UiConstants.TS_DEF_SEC : UiConstants.TS_DEFAULT;

    return Card(
      color: isSelected ? UiConstants.PRIMARY_COLOUR : null,
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.PAD_BASE),
        child: Column(
          //leading: Image.network(_gPlace.iconUrl, width: mq.size.width * 0.2,),
          children: [
            Text(_gPlace.name, style: UiConstants.TS_SUB_HDR,),
            SizedBox(height: 10.0),
            Row(
              children: [
                _body(mq, placesProvider, textStyle),
                _trailing(mq, placesProvider),
              ],
            ),
            SizedBox(height: 10.0,),
            IconButton(
              icon: Icon(Icons.directions_rounded, size: 48.0), 
              onPressed: () => placesProvider.selectNewPlace(_gPlace.placeId),
            ),
            SizedBox(height: 10.0,),
          ]         
        ),
      ),
    );
  }

  Widget _body(MediaQueryData mq, PlacesProvider placesProvider, TextStyle textStyle) {
    return Container(
      width: mq.size.width * 0.6,
      child: Column(
        children: [
          SizedBox(height: 10.0),
          Row(
            children: [
              Text(_gPlace.rating?.toString(), style: textStyle,),
              SizedBox(width: 5.0,),
              StarRating(_gPlace.rating?.toDouble(), PlacesConstants.PLACE_RATING_MAX),
              SizedBox(width: 5.0,),
              Text("(${_gPlace.numOfRatings})", style: textStyle,),
              Expanded(child: SizedBox()),
            ],
          ),
          SizedBox(height: 5.0),
          Text(_gPlace.stringifyTypes(), style: textStyle),
          SizedBox(height: 5.0,),
          Text(_gPlace.address ?? _gPlace.vicinity, style: textStyle,),
        ]         
      ),
    );
  }

  Widget _trailing(MediaQueryData mq, PlacesProvider placesProvider) {
    
    return _gPlace.photoUrls != null 
    ?
      Container(
        padding: EdgeInsets.only(left: UiConstants.PAD_BASE),
        width: mq.size.width * 0.3,
        child: Image.network(
          _gPlace.photoUrls[0],
        ),
      )
    :
      SizedBox();
            
  }
}