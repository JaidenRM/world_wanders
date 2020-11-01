import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/providers/places_provider.dart';
import 'package:world_wanders/providers/user_provider.dart';
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
          children: [
            Text(_gPlace.name, style: UiConstants.TS_SUB_HDR),
            SizedBox(height: 10.0),
            Row(
              children: [
                _body(mq, placesProvider, textStyle),
                _trailing(mq, placesProvider),
              ],
            ),
            SizedBox(height: 10.0,),
            //can change colour to match text or smth but I think I prefer black atm
            _buttonRow(context, mq, placesProvider, Colors.black),
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
          if(_gPlace.rating != null)
            Row(
              children: [
                Text(_gPlace.rating.toString(), style: textStyle,),
                SizedBox(width: 5.0,),
                StarRating(_gPlace.rating.toDouble(), PlacesConstants.PLACE_RATING_MAX),
                SizedBox(width: 5.0,),
                Text("(${_gPlace.numOfRatings})", style: textStyle,),
                Expanded(child: SizedBox()),
              ],
            ),
          SizedBox(height: 5.0),
          Align(alignment: Alignment.centerLeft, child: Text(_gPlace.stringifyTypes(), style: textStyle)),
          SizedBox(height: 5.0,),
          Align(alignment: Alignment.centerLeft, child: Text(_gPlace.address ?? _gPlace.vicinity, style: textStyle,)),
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

  Widget _buttonRow(BuildContext context, MediaQueryData mq, PlacesProvider placesProvider, Color colour) {
    final userProvider = Provider.of<UserProvider>(context);
    final isSaved = userProvider?.savedPlaces?.any((place) => place.placeId == _gPlace.placeId) ?? false;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.directions_rounded, size: 55.0, color: colour,), 
          onPressed: () => placesProvider.selectNewPlace(_gPlace.placeId),
        ),
        IconButton(
          icon: isSaved ? 
            Icon(FontAwesomeIcons.solidHeart, size: 48.0, color: colour,) : 
            Icon(FontAwesomeIcons.heart, size: 48.0, color: colour,),
          onPressed: () => isSaved ? userProvider.removePlace(_gPlace.placeId) : userProvider.savePlace(_gPlace),
        ),
      ],
    );
  }
}