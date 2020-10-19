class Helpers {
  static String mapToQueryParametersString(Map map, bool isStart) {
    var parmStr = '';
    var counter = 0;
    
    map.forEach((key, value) { 
      if(value != null && key != null) {
        var connector = counter == 0 && isStart ? "?" : "&";
        parmStr += '$connector$key=$value';
        counter++;
      }
    });

    return parmStr;
  }
}