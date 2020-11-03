import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/history_provider.dart';
import 'package:world_wanders/providers/places_provider.dart';
import 'package:world_wanders/providers/user_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/screens/search_results_screen.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/ui/utils/my_error_widget.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class HistoryScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      appBar: historyProvider.selectedScreen == HistScreen.Main ?
      AppBar(
        title: Text('History'),
      ) : null,
      body: _viewBasedOnState(context, historyProvider),
    );
  }

  Widget _viewBasedOnState(BuildContext context, HistoryProvider historyProvider) {
    final userProvider = Provider.of<UserProvider>(context);

    if(historyProvider.state == UiState.Loading) {
      return MyLoadingWidget();
    } else if(historyProvider.state == UiState.Error) {
      return MyErrorWidget('Unknown error');
    } else {
      switch(historyProvider.selectedScreen) {
        case HistScreen.Places:
          return ChangeNotifierProvider<PlacesProvider>(
            create: (_) => PlacesProvider(
              preloadedPlaces: userProvider.savedPlaces,
            ),
            builder: (context, widget) {
              return SearchResultsScreen(
                onBackButton: () => historyProvider.setScreen(HistScreen.Main),
              );
            },
          );
        default:
          return _mainScreen(context, historyProvider);
      }
    }
  }

  Widget _mainScreen(BuildContext context, HistoryProvider historyProvider) {
    final mq = MediaQuery.of(context);
    final btnWidth = mq.size.width * 0.55;

    return MyBackground(
      child: Padding(
        padding: EdgeInsets.all(UiConstants.PAD_BASE),
        child: Container(
          width: mq.size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultButton(
                  child: Text('Planned Trips'),
                  onPressed: null,
                  width: btnWidth,
                ),
                SizedBox(height: 10.0,),
                //SavedPlace => GooglePlace ?? New page or store as GPlace?
                DefaultButton(
                  child: Text('Saved Places'),
                  onPressed: () => historyProvider.setScreen(HistScreen.Places),
                  width: btnWidth,
                ),
                SizedBox(height: 10.0,),
                DefaultButton(
                  child: Text('Posts'),
                  onPressed: null,
                  width: btnWidth,
                ),
              ]
            ),
          ),
        ),
      )
    );
  }

}