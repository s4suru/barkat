import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbih/admob_demo.dart';
import 'package:tasbih/screens/login_screen.dart';

import '../languageSelectionScreen.dart';
import 'home_screen.dart';
import 'on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Widget _initialScreen;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      _determineInitialScreen();
    });
  }

  void _determineInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasCompletedOnboarding =
        prefs.getBool('has_completed_onboarding') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('rabin $isLoggedIn');
    if (hasCompletedOnboarding) {
      if (isLoggedIn) {
        navigateTo(const HomeScreen());
      } else {
        navigateTo(LoginScreen());
      }
    } else {
      navigateTo(const OnBoardingScreen());
    }
  }

  navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage("assets/images/Splash.png"),
      fit: BoxFit.cover,
    );
  }
}
