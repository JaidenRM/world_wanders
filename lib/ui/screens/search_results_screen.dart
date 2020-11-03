import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/places_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/screens/components/google_place_list_tile.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class SearchResultsScreen extends StatelessWidget {
  final Function _onBack;

  SearchResultsScreen({ Function onBackButton })
    : _onBack = onBackButton;

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
                onMapCreated: (GoogleMapController controller) async {
                  placesProvider.gController = controller;
                  
                  if(
                    placesProvider.googlePlaces != null 
                    && placesProvider.googlePlaces.length > 0
                  ) {
                    SchedulerBinding.instance.addPostFrameCallback((_) { 
                      placesProvider.selectNewPlace(placesProvider.googlePlaces[0].placeId);
                    });
                  } else {
                    var currPos = await Geolocator.getCurrentPosition();

                  if(
                    placesProvider.googlePlaces == null 
                    && placesProvider.googlePlaces.length == 0
                  ) {
                    controller.moveCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(currPos.latitude, currPos.longitude),
                        zoom: 15.0
                      )
                    ));
                  }}
                },
                markers: placesProvider.markers,
                myLocationEnabled: true,
                padding: EdgeInsets.only(top: 80.0,),
              ),
              Padding(
                padding: const EdgeInsets.all(UiConstants.PAD_BASE),
                child: Row(
                  children: [
                    if(_onBack != null)
                      Padding(
                        padding: const EdgeInsets.only(right: UiConstants.PAD_BASE),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: UiConstants.PRIMARY_COLOUR,
                          ),
                          child: BackButton(
                            color: UiConstants.TERTIARY_COLOUR,
                            onPressed: _onBack,
                          ),
                        ),
                      ),
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
                  minChildSize: 0.05,
                  initialChildSize: 0.25,
                  maxChildSize: 0.75,
                  builder: (context, controller) {
                    controller.addListener(() { 
                      if(controller.position.atEdge) {
                        if(controller.position.pixels > 0) {
                          placesProvider.tryFetchNextPage();
                        }
                      }
                    });

                    return Container(
                      child: Stack(
                        children: [
                          ListView.builder(
                            controller: controller,
                            itemCount: (placesProvider.googlePlaces.length),
                            itemBuilder: (context, idx) {
                              var gPlace = placesProvider.googlePlaces[idx];
                              return 
                                idx == (placesProvider.googlePlaces.length - 1) 
                                  && placesProvider.state == UiState.Loading
                                ?
                                  Column(
                                    children: [
                                      placesProvider.googlePlaces[idx].toListTile(context),
                                      //GooglePlaceListTile(gPlace: gPlace,),
                                      MyLoadingWidget(),
                                      // alternative if the auto/listener is too finicky or if settings options happens
                                      // DefaultButton(
                                      //   child: Text('Bottom',),
                                      //   onPressed: () => placesProvider.tryFetchNextPage(),
                                      // ),
                                    ],
                                  ) :
                                  placesProvider.googlePlaces[idx].toListTile(context);
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