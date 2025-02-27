import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exchange_rate.dart';

class ExchangeController {
  final String _baseUrl = "http://api.exchangeratesapi.io/v1";
  final String _accessKey = "b60ea55f5d015429ea731983e1feadc5";

  Future<ExchangeRate?> fetchExchangeRate({String base = "EUR", String symbols = "USD"}) async {
    final url = Uri.parse("$_baseUrl/latest?access_key=$_accessKey&base=$base&symbols=$symbols");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse["success"] == true || jsonResponse["rates"] != null) {
          return ExchangeRate.fromJson(jsonResponse);
        }
      }
    } catch (e) {
      print("Error Fetching Data: $e");
    }
    return null;
  }
}

