import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late Future<List<dynamic>> bookings;
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _bookingsList = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    fromDateController = TextEditingController();
    toDateController = TextEditingController();
    bookings = fetchBookings();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchBookings({int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      Fluttertoast.showToast(msg: 'Access token is missing');
      return [];
    }

    String fromDate = fromDateController.text;
    String toDate = toDateController.text;

    try {
      var response = await http.post(
        Uri.parse('https://api.cabryder.com/v1/api/Booking/GetBookings'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "pageNo": page,
          "pageSize": 10,
          "from_date": fromDate,
          "to_date": toDate,
          "searchValue": "",
          "status": "All"
        }),
      );

      print('status code ${response.statusCode}');
      print('body: ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['items'];
      } else {
        Fluttertoast.showToast(msg: 'Failed to load bookings');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'An error occurred');
      return [];
    }
  }

  void showBookingDetailsDialog(BuildContext context, dynamic booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Booking Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildBookingDetailRow(
                    Icons.assignment, 'ID', booking['id'].toString()),
                _buildBookingDetailRow(Icons.date_range, 'Rental Date',
                    booking['rentalDate'].toString()),
                _buildBookingDetailRow(Icons.access_time, 'Reporting Datetime',
                    booking['reportingDatetime'].toString()),
                _buildBookingDetailRow(
                    Icons.work, 'Duty Type', booking['dutyType'].toString()),
                _buildBookingDetailRow(Icons.person, 'Vendor Name',
                    booking['vendor_name'].toString()),
                _buildBookingDetailRow(Icons.phone, 'Vendor Mobile',
                    booking['vendor_mobile'].toString()),
                _buildBookingDetailRow(
                    Icons.people, 'Party', booking['party'].toString()),
                _buildBookingDetailRow(Icons.phone_android, 'Party Mobile No',
                    booking['party_mobileNo'].toString()),
                _buildBookingDetailRow(Icons.flight, 'Flight/Train No',
                    booking['flight_train_No'].toString()),
                _buildBookingDetailRow(Icons.directions_car, 'Car Type',
                    booking['carType'].toString()),
                _buildBookingDetailRow(Icons.attachment, 'Attachment',
                    booking['attachment'].toString()),
                _buildBookingDetailRow(Icons.directions_car, 'Car Type Send',
                    booking['carTypeSend'].toString()),
                _buildBookingDetailRow(
                    Icons.location_on, 'Drop At', booking['dropAt'].toString()),
                _buildBookingDetailRow(Icons.mode_of_travel, 'Booking Mode',
                    booking['bookingMode'].toString()),
                _buildBookingDetailRow(Icons.person_pin, 'Booked By',
                    booking['bookedBy'].toString()),
                _buildBookingDetailRow(Icons.attach_money, 'Rate Type',
                    booking['rateType'].toString()),
                _buildBookingDetailRow(Icons.notes, 'Booking Summary',
                    booking['bookingummery'].toString()),
                _buildBookingDetailRow(Icons.car_repair, 'Vehicle No',
                    booking['vehicleNo'].toString()),
                _buildBookingDetailRow(Icons.local_shipping, 'Supplier',
                    booking['supplier'].toString()),
                _buildBookingDetailRow(
                    Icons.person, 'Driver', booking['driver'].toString()),
                _buildBookingDetailRow(Icons.check_circle, 'Booking Status',
                    booking['bookingStatus'].toString()),
                _buildBookingDetailRow(
                    Icons.phone, 'Contact No', booking['contactNo'].toString()),
                _buildBookingDetailRow(Icons.phone_android, 'Driver Contact',
                    booking['driverContact'].toString()),
                _buildBookingDetailRow(Icons.date_range, 'Entry Date',
                    booking['entryDate'].toString()),
                _buildBookingDetailRow(Icons.access_time, 'Entry Time',
                    booking['entryTime'].toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookingDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null)
      setState(() {
        fromDateController.text = pickedDate.toIso8601String();
      });
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null)
      setState(() {
        toDateController.text = pickedDate.toIso8601String();
      });
  }

  void refreshBookings() {
    setState(() {
      _currentPage = 1;
      _bookingsList.clear();
      bookings = fetchBookings();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500 && !_isLoadingMore) {
      _loadMoreBookings();
    }
  }

  Future<void> _loadMoreBookings() async {
    setState(() {
      _isLoadingMore = true;
    });

    List<dynamic> moreBookings = await fetchBookings(page: _currentPage + 1);
    setState(() {
      _currentPage++;
      _bookingsList.addAll(moreBookings);
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    controller: fromDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'From Date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => selectFromDate(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: toDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'To Date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => selectToDate(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: refreshBookings,
                  child: Text('Fetch Bookings'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: bookings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No bookings found'));
                } else {
                  _bookingsList.addAll(snapshot.data!);
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: _bookingsList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _bookingsList.length) {
                        return _isLoadingMore
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox.shrink();
                      }
                      var booking = _bookingsList[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text('Booking ID: ${booking['id']}'),
                          subtitle:
                              Text('Rental Date: ${booking['rentalDate']}'),
                          trailing: Chip(
                            label: Text(
                              booking['bookingStatus'],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor:
                                _getStatusColor(booking['bookingStatus']),
                          ),
                          onTap: () =>
                              showBookingDetailsDialog(context, booking),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
