import 'package:app_medicine/screens/add_medicine/add_medicine_screen.dart';
import 'package:app_medicine/screens/auth_check/auth_check.dart';
import 'package:app_medicine/screens/details_medicine/medicine_details.dart';
import 'package:app_medicine/screens/edit_medicine/edit_medicine_page.dart';
import 'package:app_medicine/screens/home_page/home_page.dart';
import 'package:app_medicine/screens/login_page/login_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/': (context) => const AuthCheck(),
    '/home': (context) => const HomeScreen(),
    '/add': (context) => const AddMedicineScreen(),
    '/edit': (context) => const EditMedicinePage(),
    '/details': (context) => const DetailsMedicine(),
    '/login': (context) => LoginScreen(),
  };

  String initial = '/';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
