import 'dart:convert';

import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_model.dart';
import 'custom_status_colors.dart';

class DataGrid extends StatefulWidget {
  const DataGrid({super.key});

  @override
  State<DataGrid> createState() => _DataGridState();
}

class _DataGridState extends State<DataGrid>
    with SingleTickerProviderStateMixin {
  List<BookingData> _bookings = [];
  List<BookingData> _filteredBookings = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  DateTime? _fromDate;
  DateTime? _toDate;
  late TextEditingController fromDateController;
  late TextEditingController toDateController;

  bool _isSearching = false; // Add this variable

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fromDateController = TextEditingController();
    toDateController = TextEditingController();
    _tabController =
        TabController(length: CustomColors.statusColors.length, vsync: this);
    _tabController.addListener(() {
      fetchBookings(
          status:
              CustomColors.statusColors.keys.toList()[_tabController.index]);
    });

    fetchBookings(status: "All");

    // fetchBookings().then((bookings) {
    //   setState(() {
    //     _bookings = bookings;
    //     _filteredBookings = bookings;
    //     _isLoading = false;
    //   });
    // });

    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        _isSearching = false; // Reset searching flag if search text is empty
      }
    });
  }

  void filterBookings() {
    String searchValue = _searchController.text.toLowerCase();
    if (!_isSearching) {
      fetchBookings(searchValue: searchValue);
    }
  }

  // Future<List<BookingData>> fetchBookings(
  //     {int page = 1, String status = "All"}) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? accessToken = prefs.getString('accessToken');
  //
  //   if (accessToken == null) {
  //     Fluttertoast.showToast(msg: 'Access token is missing');
  //     return [];
  //   }
  //
  //   try {
  //     var response = await http.post(
  //       Uri.parse('https://api.cabryder.com/v1/api/Booking/GetBookings'),
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         "pageNo": page,
  //         "pageSize": 10,
  //         "from_date": _fromDate != null
  //             ? DateFormat('yyyy-MM-dd').format(_fromDate!)
  //             : "",
  //         "to_date":
  //             _toDate != null ? DateFormat('yyyy-MM-dd').format(_toDate!) : "",
  //         "searchValue": "",
  //         "status": "All"
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       List<dynamic> items = data['items'];
  //       return items
  //           .map<BookingData>((json) => BookingData.fromJson(json))
  //           .toList();
  //     } else {
  //       Fluttertoast.showToast(msg: 'Failed to load bookings');
  //       return [];
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'An error occurred');
  //     return [];
  //   }
  // }

  Future<void> fetchBookings({
    String status = "All",
    String searchValue = "",
  }) async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      Fluttertoast.showToast(msg: 'Access token is missing');
      setState(() {
        _isLoading = false;
      });
      return;
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
          "pageNo": 1,
          "pageSize": 10,
          "from_date": fromDate ?? "",
          "to_date": toDate ?? "",
          "searchValue": searchValue,
          "status": status
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> items = data['items'];
        List<BookingData> bookings = items
            .map<BookingData>((json) => BookingData.fromJson(json))
            .toList();
        setState(() {
          _bookings = bookings;
          _filteredBookings = bookings;
          _isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: 'Failed to load bookings');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void refreshBookings() {
    setState(() {
      fetchBookings();
    });
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Filter Using Date"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
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
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    refreshBookings;
                    Navigator.pop(context);
                  },
                  child: Text('Fetch Bookings'),
                ),
              ],
            ),
          );
        });
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("All Bookings", style: TextStyle(fontFamily: FontFamily.europaBold),),
          ),
      body:

      // _isLoading
      //     ? const Center(
      //         child: CircularProgressIndicator(
      //           color: Colors.brown,
      //         ),
      //       )
      //     :


      Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (value){
                      _isSearching = true;
                      filterBookings();
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Type Something to Search",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.filter_list_outlined,
                          ),
                          onPressed: () {
                            _showFilterDialog(context);
                          },
                        )),
                  ),
                ),
                TabBar(
                  labelColor: Colors.black,
                  isScrollable: true,
                  controller: _tabController,
                  tabs: CustomColors.statusColors.keys
                      .map((status) => Tab(
                            text: status,
                          ))
                      .toList(),
                ),


                Expanded(
                  child:

                  _isLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  )
                      :


                  ListView.builder(
                    itemCount: _filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = _filteredBookings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${booking.id}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              CustomColors.statusColors[
                                                      booking.bookingStatus] ??
                                                  Colors.grey),
                                      onPressed: () {},
                                      child: Text(booking.bookingStatus))
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1.2,
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Driver:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.driver,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Party:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.party,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Supplier:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.supplier,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Duty Type:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.dutyType,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Booking Mode:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.bookingMode,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Driver Contact:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.driverContact,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Rental Date:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        booking.rentalDate,
                                        style: TextStyle(
                                            color: Colors.green), // Green color
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Reporting DateTime:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        booking.reportingDatetime,
                                        style: TextStyle(
                                            color: Colors.green), // Green color
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Entry Date:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        booking.entryDate,
                                        style: TextStyle(
                                            color: Colors.green), // Green color
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Entry Time:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        booking.entryTime,
                                        style: TextStyle(
                                            color: Colors.green), // Green color
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Car Type:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        booking.carType,
                                        style: TextStyle(
                                            color: Colors.green), // Green color
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Vehicle No:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        booking.vehicleNo,
                                        style: TextStyle(
                                            color: Colors.green), // Green color
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Car Type Sent:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        booking.carTypeSend,
                                        style: TextStyle(
                                            color: Colors.green), // Green color
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Vendor Name:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.vendorName,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Vendor Mobile:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.vendorMobile,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Party Mobile No:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.partyMobileNo,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Drop At:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.dropAt,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Booked By:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.bookedBy,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Rate Type:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.rateType,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Contact No:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                    booking.contactNo,
                                    style: TextStyle(
                                        color: Colors.green), // Green color
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    ));
  }
}
