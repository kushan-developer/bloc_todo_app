import 'package:flutter/material.dart';
import 'package:flutter_bloc_app/presentation/screens/home_screen.dart';
import 'package:flutter_bloc_app/presentation/screens/second_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case "/second":
        return MaterialPageRoute(builder: (_) => SecondScreen());
      default:
        return null;
    }
  }
}
