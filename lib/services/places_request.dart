import 'package:logger/logger.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:world_wanders/utils/secrets.dart';

//use this as an interface instead maybe?
abstract class PlacesRequest {
  final Logger _logger;
  static const String _name = "PlacesRequest";

  String _baseUrl = "https://maps.googleapis.com/maps/api/place";
  String _requestUrl;
  String _apiKey = Secrets.GOOGLE_API_KEY;
  String _nextPageToken;
  bool _canFetchNext = true;

  String get requestUrl => _requestUrl;
  String get nextPageToken => _nextPageToken;
  bool get hasNextPageToken => _nextPageToken != null;

  PlacesRequest(String requestType, String format)
   : _logger = getLogger(_name)
  {
    _requestUrl = "$_baseUrl/$requestType/$format?${PlacesConstants.PARM_KEY}=$_apiKey";
  }

  Future<List<GooglePlace>> fetchRequest() async {
    _logger.i('Starting fetch for ($requestUrl)...');
    final resp = await http.get(requestUrl);

    if(resp.statusCode == 200) {
      //we gucci
      _logger.i('Fetch was successful');
      return _convertJsonBodyToPlaces(resp);
    } else {
      //exception? :O
      _logger.e('Fetch FAILED with code ${resp.statusCode} and reason ${resp.reasonPhrase}');
      return null;
    }
  }

  Future<List<GooglePlace>> fetchNextPageRequest() async {
    _logger.i('Starting fetch for the next page...');
    if(!hasNextPageToken) {
      _logger.w('No next page token was found');
      return null;
    } else if(!_canFetchNext) {
      _logger.w('Cannot fetch for a next request');
      return null;
    }

    _canFetchNext = false;
    final resp = await http.get('$_requestUrl&${PlacesConstants.PARM_PAGE_TOKEN}=$_nextPageToken');
    _canFetchNext = true;

    if(resp.statusCode == 200) {
      //we gucci
      _logger.i('Fetch was successful');
      return _convertJsonBodyToPlaces(resp);
    } else {
      //exception? :O
      _logger.e('Fetch FAILED with code ${resp.statusCode} and reason ${resp.reasonPhrase}');
      return null;
    }
  }

  List<GooglePlace> _convertJsonBodyToPlaces(http.Response resp) {
    _logger.i('Starting conversion from JSON to GooglePlace list');
    Map<String, dynamic> jsonBody = convert.jsonDecode(resp.body);
    List jsonPlaces;
    List<GooglePlace> gPlaces = [];
    
    if(jsonBody.containsKey('results')) {
      _logger.i('JSON response \'results\' element found');
      jsonPlaces = jsonBody['results'];
    } else if(jsonBody.containsKey('candidates')) {
      _logger.i('JSON response \'candidates\' element found');
      jsonPlaces = jsonBody['candidates'];
    } else {
      _logger.e("Json body did not contain 'results' or 'candidates' keys. These are the available keys: ${jsonBody.keys}");
      return null;
    }

    _logger.i('Found ${jsonPlaces.length} places. Starting conversion...');
    jsonPlaces.forEach((json) { 
      gPlaces.add(GooglePlace.fromJson(json));
    });

    if(jsonBody.containsKey('next_page_token')) {
      _logger.i('Next page token was found: ${jsonBody['next_page_token']}');
      _nextPageToken = jsonBody['next_page_token'];
    } else {
      _nextPageToken = null;
    }
      
    _logger.i('Conversion completed');
    return gPlaces;
  }

}