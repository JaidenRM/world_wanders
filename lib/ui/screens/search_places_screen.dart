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
              GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
                onMapCreated: (GoogleMapController controller) => placesProvider.gController = controller,
                markers: placesProvider.markers,
              ),
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
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        placesProvider.search();
                      }
                    ),
                  ],
                ),
              ),
              if(placesProvider.googlePlaces.length > 0)
                DraggableScrollableSheet(
                  minChildSize: 0.15,
                  initialChildSize: 0.25,
                  maxChildSize: 0.75,
                  builder: (context, controller) {
                    return Container(
                      child: Stack(
                        children: [
                          ListView.builder(
                            controller: controller,
                            itemCount: placesProvider.googlePlaces.length,
                            itemBuilder: (context, idx) {
                              var gPlace = placesProvider.googlePlaces[idx];
                              return GooglePlaceListTile(gPlace: gPlace,);
                            }
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Material(
                              elevation: 1,
                              type: MaterialType.transparency,
                              child: GestureDetector(
                                child: Icon(Icons.arrow_circle_up_rounded, size: 80,),
                                onTap: () => controller.animateTo(0, duration: Duration(seconds: 1), curve: Curves.decelerate),
                              )
                            ),
                          ),
                        ],
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