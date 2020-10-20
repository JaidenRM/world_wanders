import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/places_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/screens/components/google_place_list_tile.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class SearchPlacesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
                  initialChildSize: 0.25,
                  maxChildSize: 0.75,
                  builder: (context, controller) {
                    return Container(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: placesProvider.googlePlaces.length,
                        itemBuilder: (context, idx) {
                          var gPlace = placesProvider.googlePlaces[idx];
                          return GooglePlaceListTile(gPlace: gPlace,);
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