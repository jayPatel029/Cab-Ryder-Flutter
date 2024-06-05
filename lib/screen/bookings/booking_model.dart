class BookingData {
  final int id;
  final String rentalDate;
  final String reportingDatetime;
  final String dutyType;
  final String party;
  final String carType;
  final String vehicleNo;
  final String supplier;
  final String driver;
  final String bookingStatus;
  final String vendorName;
  final String vendorMobile;
  final String partyMobileNo;
  final String carTypeSend;
  final String dropAt;
  final String bookingMode;
  final String bookedBy;
  final String rateType;
  final String contactNo;
  final String driverContact;
  final String entryDate;
  final String entryTime;

  BookingData({
    required this.id,
    required this.rentalDate,
    required this.reportingDatetime,
    required this.dutyType,
    required this.party,
    required this.carType,
    required this.vehicleNo,
    required this.supplier,
    required this.driver,
    required this.bookingStatus,
    required this.vendorName,
    required this.vendorMobile,
    required this.partyMobileNo,
    required this.carTypeSend,
    required this.dropAt,
    required this.bookingMode,
    required this.bookedBy,
    required this.rateType,
    required this.contactNo,
    required this.driverContact,
    required this.entryDate,
    required this.entryTime,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'],
      rentalDate: json['rentalDate'] ?? '',
      reportingDatetime: json['reportingDatetime'] ?? '',
      dutyType: json['dutyType'] ?? '',
      party: json['party'] ?? '',
      carType: json['carType'] ?? '',
      vehicleNo: json['vehicleNo'] ?? '',
      supplier: json['supplier'] ?? '',
      driver: json['driver'] ?? '',
      bookingStatus: json['bookingStatus'] ?? '',
      vendorName: json['vendor_name'] ?? '',
      vendorMobile: json['vendor_mobile'] ?? '',
      carTypeSend: json['carTypeSend'] ?? '',
      dropAt: json['dropAt'] ?? '',
      bookingMode: json['bookingMode'] ?? '',
      bookedBy: json['bookedBy'] ?? '',
      rateType: json['rateType'] ?? '',
      contactNo: json['contactNo'] ?? '',
      driverContact: json['driverContact'] ?? '',
      partyMobileNo: json['party_mobileNo'] ?? '',
      entryDate: json['entryDate'] ?? '',
      entryTime: json['entryTime'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id.toString(),
      'rentalDate': rentalDate,
      'reportingDatetime': reportingDatetime,
      'dutyType': dutyType,
      'party': party,
      'carType': carType,
      'vehicleNo': vehicleNo,
      'supplier': supplier,
      'driver': driver,
      'bookingStatus': bookingStatus,
      'vendorName': vendorName,
      'vendorMobile': vendorMobile,
      'partyMobileNo': partyMobileNo,
      'carTypeSend': carTypeSend,
      'dropAt': dropAt,
      'bookingMode': bookingMode,
      'bookedBy': bookedBy,
      'rateType': rateType,
      'contactNo': contactNo,
      'driverContact': driverContact,
      'entryDate': entryDate,
      'entryTime': entryTime,
    };
  }
}
