import 'package:flutter/material.dart';

class CustomColors {

static Map<String, Color> statusColors = {
  'All' : Color(0xFF808080),
  'Booked' : Color(0xFF1E90FF),
  'Alloted' : Color(0xFFFFD700),
  'Dispatch' : Color(0xFF32CD32),
  'Closed' : Color(0xFF4B0082),
  'Cancelled' : Color(0xFFFF0000),
  'Billed' : Color(0xFF8A2BE2),
  'Cash' : Color(0xFF228B22),
  'PendingVendorDuty' : Color(0xFFFFA500),
  'VendorDuty' : Color(0xFF20B2AA),
};

  static const Color allColor = Color(0xFF808080); // Gray
  static const Color bookedColor = Color(0xFF1E90FF); // Dodger Blue
  static const Color allotedColor = Color(0xFFFFD700); // Gold
  static const Color dispatchColor = Color(0xFF32CD32); // Lime Green
  static const Color closedColor = Color(0xFF4B0082); // Indigo
  static const Color cancelledColor = Color(0xFFFF0000); // Red
  static const Color billedColor = Color(0xFF8A2BE2); // Blue Violet
  static const Color cashColor = Color(0xFF228B22); // Forest Green
  static const Color pendingVendorDutyColor = Color(0xFFFFA500); // Orange
  static const Color vendorDutyColor = Color(0xFF20B2AA); // Light Sea Green
}



//
//
// Color getButtonColor(String status) {
//   switch (status) {
//     case "All":
//       return CustomColors.allColor;
//     case "Booked":
//       return CustomColors.bookedColor;
//     case "Alloted":
//       return CustomColors.allotedColor;
//     case "Dispatch":
//       return CustomColors.dispatchColor;
//     case "Closed":
//       return CustomColors.closedColor;
//     case "Cancelled":
//       return CustomColors.cancelledColor;
//     case "Billed":
//       return CustomColors.billedColor;
//     case "Cash":
//       return CustomColors.cashColor;
//     case "PendingVendorDuty":
//       return CustomColors.pendingVendorDutyColor;
//     case "VendorDuty":
//       return CustomColors.vendorDutyColor;
//     default:
//       return Colors.grey; // Default color for unknown status
//   }
// }
