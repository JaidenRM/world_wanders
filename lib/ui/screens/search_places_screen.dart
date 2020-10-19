import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/providers/places_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/ui/utils/my_error_widget.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/star_rating.dart';

class SearchPlacesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final placesProvider = Provider.of<PlacesProvider>(context);

    return Scaffold(
      body: MyBackground(
        child: SafeArea(
          child: Stack(
            children: [
              //hook this up with the provider to issue updates :)
              GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(0, 0))),
              Padding(
                padding: const EdgeInsets.all(UiConstants.PAD_BASE),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Search for',
                          labelStyle: UiConstants.TS_DEFAULT,
                        ),
                        onChanged: (String val) => placesProvider.changeSearchText(val),
                      ),
                    ),
                    DefaultButton(
                      child: Text('Go'),
                      onPressed: placesProvider.search,
                    ),
                  ],
                ),
              ),
              if(placesProvider.googlePlaces.length > 0)
                DraggableScrollableSheet(
                  minChildSize: 0.1,
                  builder: (context, controller) {
                    return Container(
                      color: Colors.white,
                      child: ListView.builder(
                            itemCount: placesProvider.googlePlaces.length,
                            itemBuilder: (context, idx) {
                              var gPlace = placesProvider.googlePlaces[idx];
                              return ListTile(
                                leading: Image.network(gPlace.iconUrl, width: mq.size.width * 0.2,),
                                title: Text(gPlace.name),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: Text(gPlace.rating?.toString())),
                                        if(gPlace.rating > 0) Expanded(child: StarRating(gPlace.rating, PlacesConstants.PLACE_RATING_MAX)),
                                        if(gPlace.numOfRatings > 0) Expanded(child: Text("(${gPlace.numOfRatings})")),
                                        Text(' · '),
                                        Expanded(child: Text(gPlace.types?.join(","))),
                                      ],
                                    ),
                                    Text(gPlace.address ?? gPlace.vicinity)
                                  ]
                                ),
                                trailing: Image.network(gPlace.photoUrls[0]),
                              );
                            }
                          ),
                   
                    );
                  }
                ),
            ],
          ),
        ),
      ),
    );
  }

}