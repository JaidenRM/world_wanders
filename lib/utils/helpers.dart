enum CaseType {
  SnakeCase
}

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

  static String humanise(String str, { CaseType cType = CaseType.SnakeCase }) {
    var humanStr = "";
    var isUnderscore = false;
    str = str.trim();

    for(int i = 0; i < str.length; i++) {
      if(i == 0)
        humanStr += str[i].toUpperCase();
      else if(str[i] == '_') {
        humanStr += ' ';
        isUnderscore = true;
      } else if(isUnderscore) {
        humanStr += str[i].toUpperCase();
        isUnderscore = false;
      } else {
        humanStr += str[i];
      }
    }

    return humanStr;
  }
}