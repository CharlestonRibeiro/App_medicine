import 'package:app_medicine/controller/add_medicine_controller.dart';
import 'package:app_medicine/controller/auth_service.dart';
import 'package:app_medicine/controller/details_medicine_controller.dart';
import 'package:app_medicine/controller/edit_medicine_controller.dart';
import 'package:app_medicine/firebase_options.dart';
import 'package:app_medicine/helpers/notification_service.dart';
import 'package:app_medicine/helpers/routes.dart';
import 'package:app_medicine/screens/login_page/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AddMedicineController(),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailsMedicineController(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditMedicineController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        Provider<NotificationService>(
          create: (context) => NotificationService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de medicamentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kGreyColor,
        appBarTheme:
            const AppBarTheme(elevation: 0, backgroundColor: Colors.blue),
        scaffoldBackgroundColor: kBlueColor,
      ),
      routes: Routes.list,
      initialRoute: Routes().initial,
      navigatorKey: Routes.navigatorKey,
    );
  }
}
