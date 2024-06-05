// ignore_for_file: prefer_const_constructors, deprecated_member_use
import 'package:carlink/screen/bookings/bookings_screen.dart';
import 'package:carlink/screen/bookings/data_grid.dart';
import 'package:carlink/screen/bottombar/home_screen.dart';
import 'package:carlink/screen/gerneral_support/Applanguage_screen.dart';
import 'package:carlink/screen/home/home_screen.dart';
import 'package:carlink/screen/login_flow/login_screen.dart';
import 'package:carlink/screen/login_flow/splash_screen.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:carlink/helpar/get_di.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';
import 'Localmodal_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  await GetStorage.init();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("45574d4f-427f-498d-afdf-e0b6fdb7b0b9");
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences _prefs;
  const MyApp({super.key, required SharedPreferences prefs}): _prefs = prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ColorNotifire(),
        ),
        ChangeNotifierProvider(create: (context) => LocaleModel(_prefs)),
      ],
      child: Consumer<LocaleModel>(
        builder: (context, localeModel, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: LocalString(),
            locale: localeModel.locale,
            theme: ThemeData(
                useMaterial3: false,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                dividerColor: Colors.transparent,
                fontFamily: "urbani_regular",
                primaryColor: const Color(0xff1347FF),
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: const Color(0xff194BFB),
                )),
            home:

              // DataGrid()
            // BookingsScreen()
            // HomeScreen()
            //     HomeScreenTwo()
            LoginScreen()
            // const SplashScreen(),
          );
        },
      ),
    );
  }
}
