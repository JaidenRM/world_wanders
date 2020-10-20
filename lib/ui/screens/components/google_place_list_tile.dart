import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/star_rating.dart';

class GooglePlaceListTile extends StatelessWidget {
  final GooglePlace _gPlace;

  GooglePlaceListTile({ @required GooglePlace gPlace })
    : assert(gPlace != null),
      _gPlace = gPlace;
  
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.PAD_BASE),
        child: ListTile(
          //leading: Image.network(_gPlace.iconUrl, width: mq.size.width * 0.2,),
          title: Text(_gPlace.name, style: UiConstants.TS_SUB_HDR,),
          subtitle: Column(
            children: [
              SizedBox(height: 10.0),
              Row(
                children: [
                  Text(_gPlace.rating?.toString(), style: UiConstants.TS_DEFAULT,),
                  SizedBox(width: 5.0,),
                  if(_gPlace.rating > 0) StarRating(_gPlace.rating.toDouble(), PlacesConstants.PLACE_RATING_MAX),
                  SizedBox(width: 5.0,),
                  if(_gPlace.numOfRatings > 0) Text("(${_gPlace.numOfRatings})", style: UiConstants.TS_DEFAULT,),
                  Expanded(child: SizedBox()),
                ],
              ),
              SizedBox(height: 5.0),
              Text(_gPlace.stringifyTypes(), style: UiConstants.TS_DEFAULT,),
              SizedBox(height: 5.0,),
              Text(_gPlace.address ?? _gPlace.vicinity, style: UiConstants.TS_DEFAULT,)
            ]
          ),
          trailing: _gPlace.photoUrls != null ? 
            Container(
              width: mq.size.width * 0.2,
              child: Image.network(
                _gPlace.photoUrls[0],
              ),
            ) 
            : null,
        ),
      ),
    );
  }
}