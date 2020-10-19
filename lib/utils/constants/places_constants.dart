enum PriceRange {
  Free,
  Cheap,
  Moderate,
  Expensive,
  VeryExpensive
}

class PlacesConstants {
  static const String REQ_TYPE_FIND = "findplacefromtext";
  static const String REQ_TYPE_TEXT = "textsearch";
  static const String REQ_TYPE_NEARBY = "nearbysearch";

  static const String FORMAT_JSON = "json";
  static const String FORMAT_XML = "xml";

  static const int PHOTO_MAX_WIDTH = 1600;
  static const int PHOTO_MAX_HEIGHT = 1600;
  static const int PLACE_RATING_MAX = 5;

  static const String GOOGLE_API_KEY = "AIzaSyBVJS3scal30ALC3dAROjxJO2UAs5waNbU";
  
  static const int PARM_REGION_LENGTH = 2;
  static const int PARM_RADIUS_MAX = 50000;
  static const String PARM_QUERY = "query";
  static const String PARM_KEY = "key";
  static const String PARM_REGION = "region";
  static const String PARM_LOCATION = "location";
  static const String PARM_RADIUS = "radius";
  static const String PARM_LANGUAGE = "language";
  static const String PARM_MIN_PRICE = "minprice";
  static const String PARM_MAX_PRICE = "maxprice";
  static const String PARM_OPEN_NOW = "opennow";
  static const String PARM_PAGE_TOKEN = "pagetoken";
  static const String PARM_RANK_BY = "rankby";
  static const String PARM_TYPE = "type";
  static const String PARM_PHOTO_REF = "photoreference";
  static const String PARM_MAX_HEIGHT = "maxheight";
  static const String PARM_MAX_WIDTH = "maxwidth";

  static const List<String> PARM_TYPE_VALUES = [
    "amusement_park", "aquarium", "art_gallery",
    "bakery", "bar", "book_store", "bowling_alley", "cafe",
    "casino", "clothing_store", "convenience_store", "department_store",
    "electronics_store", "embassy", "library", "movie_theater", "museum",
    "night_club", "park", "restaurant", "shopping_mall", "spa", "stadium",
    "tourist_attraction", "zoo" 
  ];
}