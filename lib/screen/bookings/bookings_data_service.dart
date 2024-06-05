import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_model.dart';

class DataRepository {
  Future<void> fetchBookings(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      Fluttertoast.showToast(msg: 'Access token is missing');
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('https://api.cabryder.com/v1/api/Booking/GetBookings'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "pageNo": 1,
          "pageSize": 10,
          "from_date": '',
          "to_date": '',
          "searchValue": '',
          "status": status
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> items = data['items'];
        List<BookingData> bookings = items
            .map<BookingData>((json) => BookingData.fromJson(json))
            .toList();
        // Handle the fetched bookings, you might want to return them or set them in a state.
      } else {
        Fluttertoast.showToast(msg: 'Failed to load bookings');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred');
    }
  }
}
