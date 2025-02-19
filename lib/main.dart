import 'package:flutter/material.dart';
import 'package:practice_7/app/my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var pref = await SharedPreferences.getInstance();
  var isLoggedIn = pref.getBool('isLoggedIn') ?? false;
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}
