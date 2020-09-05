import 'dart:convert';
import 'package:http/http.dart' as http;

class Url {
  static const String baseUrl = "https://firebasestorage.googleapis.com/v0/b/vesatogofleet.appspot.com/o/androidTaskApp%2F";
}

class ApiService {
  static Future getApi(String url, String type) async {
      switch (type) {
        case "get":
          {
            print('rohit');
            final http.Response response =
            await http.get(Url.baseUrl+url);
            if (response.statusCode == 200) {
//              print(response.body);
              return json.decode(response.body);
            } else {
//              print(response.body);
              throw Exception('Failed to load response of get request');
            }
          }
          break;

        default:
          {
            print('wrong choice dude!!!');
          }
      }
  }
}
