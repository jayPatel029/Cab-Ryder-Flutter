import 'package:carlink/screen/bookings/bookings_screen.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/Dark_lightmode.dart';
import '../bookings/data_grid.dart';
import 'home_screen_widgets.dart';

class HomeScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // centerTitle: true,
        title: Text(
          'Operators',
          style:
              TextStyle(fontFamily: FontFamily.europaWoff, color: BlackColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            HomeOperatorButton(
              label: 'Transfer',
              icon: Icons.swap_horiz,
              color: Colors.purple,
              onTap: () {
                Get.to(
                    DataGrid()
                    // const BookingsScreen()

                );
              },
            ),
            HomeOperatorButton(
              label: 'Vouchers',
              icon: Icons.card_giftcard,
              color: Colors.orange,
              onTap: () {

              },
            ),
            HomeOperatorButton(
              label: 'Top Up',
              icon: Icons.vertical_align_top,
              color: Colors.blue,
              onTap: () {},
            ),
            HomeOperatorButton(
              label: 'Bill Pay',
              icon: Icons.payment,
              color: Colors.green,
              onTap: () {},
            ),
            HomeOperatorButton(
              label: 'Rewards',
              icon: Icons.card_giftcard,
              color: Colors.purple,
              onTap: () {},
            ),
            HomeOperatorButton(
              label: 'Shopping',
              icon: Icons.shopping_cart,
              color: Colors.green,
              onTap: () {},
            ),
            HomeOperatorButton(
              label: 'Tickets',
              icon: Icons.confirmation_number,
              color: Colors.orange,
              onTap: () {},
            ),
            HomeOperatorButton(
              label: 'Budgets',
              icon: Icons.account_balance_wallet,
              color: Colors.blue,
              onTap: () {},
            ),
            HomeOperatorButton(
              label: 'Request',
              icon: Icons.request_page,
              color: Colors.orange,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
