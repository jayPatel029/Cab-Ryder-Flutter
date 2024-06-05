import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'booking_model.dart';
import 'bookings_data_service.dart';

class DataGridController extends ChangeNotifier {
  List<BookingData> _bookings = [];
  List<BookingData> _filteredBookings = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  DateTime? _fromDate;
  DateTime? _toDate;
  final DataRepository _dataRepository = DataRepository();

  List<BookingData> get bookings => _filteredBookings;

  bool get isLoading => _isLoading;

  DateTime? get fromDate => _fromDate;

  DateTime? get toDate => _toDate;

  TextEditingController get searchController => _searchController;

  DataGridController() {
    _initialize();
  }

  Future<void> _initialize() async {
    _searchController.addListener(() {
      _filterBookings();
    });

    await _fetchBookings("All");
  }

  Future<void> _fetchBookings(String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dataRepository.fetchBookings(status);
      _isLoading = false;
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred');
      _isLoading = false;
    }

    notifyListeners();
  }

  void _filterBookings() {
    List<BookingData> results = [];
    if (_searchController.text.isEmpty) {
      results = _bookings;
    } else {
      results = _bookings
          .where((booking) => booking.toMap().values.any((value) => value
          .toLowerCase()
          .contains(_searchController.text.toLowerCase())))
          .toList();
    }

    _filteredBookings = results;
    notifyListeners();
  }

  void filterByDateRange(DateTime? fromDate, DateTime? toDate) {
    _fromDate = fromDate;
    _toDate = toDate;
    _filterBookings();
  }

  void fetchBookingsByStatus(String status) {
    _fetchBookings(status);
  }

  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
