import 'package:logger/logger.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

//use this as an interface instead maybe?
abstract class PlacesRequest {
  final Logger _logger;
  static const String _name = "PlacesRequest";

  String _baseUrl = "https://maps.googleapis.com/maps/api/place";
  String _requestUrl;
  String _apiKey = PlacesConstants.GOOGLE_API_KEY;

  String get requestUrl => _requestUrl;

  PlacesRequest(String requestType, String format)
   : _logger = getLogger(_name)
  {
    _requestUrl = "$_baseUrl/$requestType/$format?${PlacesConstants.PARM_KEY}=$_apiKey";
  }

  Future<List<GooglePlace>> fetchRequest() async {
    final resp = await http.get(requestUrl);

    if(resp.statusCode == 200) {
      //we gucci
      Map<String, dynamic> jsonBody = convert.jsonDecode(resp.body);
      List jsonPlaces;
      List<GooglePlace> gPlaces = [];
      
      if(jsonBody.containsKey('results')) {
        jsonPlaces = jsonBody['results'];
      } else if(jsonBody.containsKey('candidates')) {
        jsonPlaces = jsonBody['candidates'];
      } else {
        _logger.e("Json body did not contain 'results' or 'candidates' keys. These are the available keys: ${jsonBody.keys}");
        return null;
      }

      jsonPlaces.forEach((json) { 
        gPlaces.add(GooglePlace.fromJson(json));
      });

      return gPlaces;
    } else {
      //exception? :O
      return null;
    }
  }

  bool foo() {
    return true;
  }
}