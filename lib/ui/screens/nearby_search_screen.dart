import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/nearby_search_provider.dart';
import 'package:world_wanders/providers/places_provider.dart';
import 'package:world_wanders/services/user_service.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/screens/search_results_screen.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/ui/utils/my_error_widget.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';

class NearbySearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Nearby'),
      ),
      body: MyBackground(
        child: Container(
          child: Consumer<NearbySearchProvider>(
            builder: (context, provider, widget) {
              switch(provider.state) {
                case UiState.Loading:
                  return MyLoadingWidget();
                case UiState.Error:
                  return MyErrorWidget('Unknown error');
                case UiState.Completed:
                //TOTRY: Change to the screen instead so we dont lose the provider on pushing the route??
                  return ChangeNotifierProvider<PlacesProvider>(
                    create: (context) => PlacesProvider(
                      userService: UserService(),
                      places: provider.results,
                    ),
                    child: SearchResultsScreen(),
                  );
                default:
                  return _form(context, provider);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context, NearbySearchProvider provider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Search for',
              labelStyle: UiConstants.TS_DEFAULT,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (String val) => provider.setKeyword(val),
            style: UiConstants.TS_DEFAULT,
          ),
          DropdownButtonFormField(
            value: provider.selectedCountry,
            items: provider.countries.map((country) => 
              DropdownMenuItem(
                child: Text(country),
                value: country,
              )
            ).toList(),
            onChanged: (value) => provider.setCountry(value),
            decoration: InputDecoration(
              labelText: 'Country',
            ),
          ),
          DropdownButtonFormField(
            value: provider.selectedCity,
            items: provider.citiesInCountry.map((city) {
              final hasState = ValidationConstants.isStringNotNullOrEmpty(city.state);
              return DropdownMenuItem(
                child: Text(city.name + (hasState.hasError ? "" : ", ${hasState.value}")),
                value: city,
              );
            }).toList(), 
            onChanged: (value) => provider.setCity(value),
            decoration: InputDecoration(
              labelText: 'City',
            ),
          ),
          Slider(
            value: provider.searchRadius.toDouble(), 
            onChanged: (value) => provider.setSearchRadius(value.toInt()),
            min: 0,
            divisions: 1000,
            max: PlacesConstants.PARM_RADIUS_MAX.toDouble(),
            label: 'Search Radius of ${provider.searchRadius}m',
          ),
          DefaultButton(
            child: Text('Search'),
            onPressed: provider.submitSearch,
          ),
          //Look at adding animated icons that turn into these form fields on click, maybe a '+' button?
            //i.e.: Keyword [+]
          // TextField(
          //   decoration: InputDecoration(
          //     labelText: 'Keywords'
          //   ),
          // ),
        ]
      ),
    );
  }
}