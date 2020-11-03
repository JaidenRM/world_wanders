import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/models/saved_place.dart';
import 'package:world_wanders/providers/places_provider.dart';
import 'package:world_wanders/providers/user_provider.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class SavedPlaceListTile extends StatelessWidget {
  final SavedPlace _sPlace;

  SavedPlaceListTile({ @required SavedPlace savedPlace })
    : assert(savedPlace != null),
      _sPlace = savedPlace;
  
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final placesProvider = Provider.of<PlacesProvider>(context);
    final isSelected = placesProvider.currPlaceId == _sPlace.placeId;
    final textStyle = isSelected ? UiConstants.TS_DEF_SEC : UiConstants.TS_DEFAULT;

    return Card(
      color: isSelected ? UiConstants.PRIMARY_COLOUR : null,
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.PAD_BASE),
        child: Column(
          children: [
            Text(_sPlace.name, style: UiConstants.TS_SUB_HDR),
            SizedBox(height: 10.0),
            Text('Date Added: ${_sPlace.dateAdded?.toLocal()?.toString()}', style: textStyle),
            SizedBox(height: 10.0,),
            //can change colour to match text or smth but I think I prefer black atm
            _buttonRow(context, mq, placesProvider, Colors.black),
            SizedBox(height: 10.0,),
          ]         
        ),
      ),
    );
  }

  Widget _buttonRow(BuildContext context, MediaQueryData mq, PlacesProvider placesProvider, Color colour) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.directions_rounded, size: 55.0, color: colour,), 
          onPressed: () => placesProvider.selectNewPlace(_sPlace.placeId),
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.solidHeart, size: 48.0, color: colour,),
          onPressed: () => userProvider.removePlace(_sPlace.placeId),
        ),
      ],
    );
  }
}