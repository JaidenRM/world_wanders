import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/models/city.dart';
import 'package:world_wanders/providers/create_trip_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/ui/utils/my_error_widget.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class CreateTripForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New trip'),
      ),
      body: MyBackground(
        child: _viewBasedOnState(context)
      ),
    );
  }
  
  Widget _viewBasedOnState(BuildContext context) {
    final newTripProvider = Provider.of<CreateTripProvider>(context);
    final mq = MediaQuery.of(context);
    final btnWidth = mq.size.width * 0.75;

    if(newTripProvider.state == UiState.Loading) {
      return MyLoadingWidget();
    } else {
      return Padding(
        padding: EdgeInsets.all(UiConstants.PAD_BASE),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Trip Name',
                  labelStyle: UiConstants.TS_DEFAULT,
                ),
                onChanged: (String val) => newTripProvider.setTripName(val)
              ),
              SizedBox(height: 10.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: UiConstants.TS_DEFAULT,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (String val) => newTripProvider.setTripDescription(val)
              ),
              SizedBox(height: 10.0),
              Container(
                child: Column(
                  children: [
                    Text(newTripProvider.startDate, style: UiConstants.TS_HDR,),
                    SizedBox(height: 5.0),
                    DefaultButton(
                      child: Text('Start Date'),
                      onPressed: () => newTripProvider.setStartDate(context),
                      width: btnWidth,
                    )
                  ]
                )
              ),
              SizedBox(height: 10.0),
              Container(
                child: Column(
                  children: [
                    Text(newTripProvider.endDate, style: UiConstants.TS_HDR,),
                    SizedBox(height: 5.0),
                    DefaultButton(
                      child: Text('End Date'),
                      onPressed: () => newTripProvider.setEndDate(context),
                      width: btnWidth,
                    )
                  ]
                )
              ),
              SizedBox(height: 30.0),
              MultiSelect(
                titleText: 'Countries to Visit',
                dataSource: newTripProvider
                  .getSortedCountries()
                  .map((country) => <String, String> { 'name': country })
                  .toList(),
                textField: "name",
                valueField: "name",
                clearButtonColor: Colors.white,
                change: (List<dynamic> countries) => newTripProvider.setCountries(countries.cast<String>()),
              ),
              SizedBox(height: 10.0),
              if(newTripProvider.hasCountries)
                MultiSelect(
                  titleText: 'Cities to Visit',
                  dataSource: newTripProvider
                    .getSortedCitiesInCountries(newTripProvider.countries)
                    .map((city) => <String, dynamic> {
                      'name': city.name,
                      'val': city,
                    })
                    .toList(),
                  textField: "name",
                  valueField: "val",
                  clearButtonColor: Colors.white,
                  change: (List<dynamic> cities) => newTripProvider.setCities(cities.cast<City>()),
                ),
              SizedBox(height: 20.0),
              DefaultButton(
                child: Text('Create'),
                onPressed: newTripProvider.isValid ? newTripProvider.submitData : null,
              ),
              if(newTripProvider.state == UiState.Error)
                MyErrorWidget('Unknown error'),
            ],
          ),
        ),
      );
    }
  }
}