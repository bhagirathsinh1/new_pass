import 'package:flutter/material.dart';

NavigationService navigationService = NavigationService().get();

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  NavigationService();

  NavigationService? _instance;
  NavigationService get() {
    if (_instance == null) _instance = new NavigationService();

    return _instance!;
  }

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  popPage() => _navigationKey.currentState!.pop();
}
