import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/nearby_search_provider.dart';
import 'package:world_wanders/providers/places_provider.dart';
import 'package:world_wanders/providers/user_provider.dart';
import 'package:world_wanders/services/user_service.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/screens/search_results_screen.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/ui/utils/my_error_widget.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';
import 'package:world_wanders/utils/helpers.dart';
import 'package:world_wanders/utils/icon_range_rating.dart';

class NearbySearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final nearbyProvider = Provider.of<NearbySearchProvider>(context);

    return Scaffold(
      appBar: nearbyProvider.state != UiState.Completed ?
      AppBar(
        title: Text('Search Nearby'),
      ) : null,
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
                  return ChangeNotifierProvider<PlacesProvider>(
                    create: (context) => PlacesProvider(request: provider.lastRequest),
                    child: SearchResultsScreen(onBackButton: provider.reset,),
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
    final mq = MediaQuery.of(context);
    final validation = provider.isValid();

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
            isExpanded: true,
            items: provider.citiesInCountry.map((city) {
              final hasState = ValidationConstants.isStringNotNullOrEmpty(city.state);
              return DropdownMenuItem(
                child: Text(
                  city.name + (hasState.hasError ? "" : ", ${hasState.value}"),
                  //overflow: TextOverflow.ellipsis,
                ),
                value: city,
              );
            }).toList(), 
            onChanged: (value) => provider.setCity(value),
            decoration: InputDecoration(
              labelText: 'City',
            ),
          ),
          SizedBox(height: 30.0,),
          Text('Search radius of ${provider.searchRadius/1000}km'),
          Slider.adaptive(
            value: provider.searchRadius.toDouble(), 
            onChanged: (value) => provider.setSearchRadius(value.toInt()),
            min: 0,
            divisions: 10,
            max: PlacesConstants.PARM_RADIUS_MAX.toDouble(),
            label: '${provider.searchRadius/1000}km',
          ),
          if(provider.isAdvancedMenu)
            _advancedForm(context, provider),
          Container(
            width: mq.size.width - 69,
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: provider.isAdvancedMenu ? 
                Icon(Icons.keyboard_arrow_up_rounded, size: 69,) :
                Icon(Icons.keyboard_arrow_down_rounded, size: 69,),
              onPressed: provider.toggleAdvancedMenu,
            ),
          ),
          SizedBox(height: 20.0,),
          DefaultButton(
            child: Text('Search'),
            onPressed: !validation.hasError ? provider.submitSearch : null,
          ),
          if(validation.hasError)
            Text(validation.error, style: UiConstants.TS_ERR,),
        ]
      ),
    );
  }

  Widget _advancedForm(BuildContext context, NearbySearchProvider provider) {
    return Column(
      children: [
        SizedBox(height: 20.0,),
        IconRangeRating(5, FontAwesomeIcons.dollarSign, 
          onChanged: provider.setPriceRange,
        ),
        SizedBox(height: 10.0,),
        DropdownButtonFormField(
          value: provider.selectedType,
          items: PlacesConstants.PARM_TYPE_VALUES.map((type) {
            final humanisedStr = Helpers.humanise(type);
            return DropdownMenuItem(
              child: Text(humanisedStr),
              value: type,
            );
          }).toList(), 
          onChanged: (value) => provider.setType(value),
          decoration: InputDecoration(
            labelText: 'Specific type of place',
          ),
        ),
        SizedBox(height: 20.0,),
        CheckboxListTile(
          value: provider.isOpenNow, 
          onChanged: (_) => provider.toggleOpenNow(),
          title: Text('Open now only'),
        ),
        CheckboxListTile(
          value: provider.isRankedByDist, 
          onChanged: (_) => provider.toggleRankedByDist(),
          title: Text('Choose anything closeby')
        ),
        
      ],
    );
  }
}