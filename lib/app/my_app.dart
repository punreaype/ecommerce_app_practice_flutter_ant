import 'package:flutter/material.dart';
import 'package:practice_7/routes/app_routes.dart';
import 'package:practice_7/routes/routes.dart';

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({
    super.key,
    this.isLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skincare App',
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? Routes.navBar : Routes.login,
      routes: appRoutes,
    );
  }
}
