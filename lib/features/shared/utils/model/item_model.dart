import 'package:flutter/cupertino.dart';

class NavigationItem {
  final String title;
  final String route;
  final IconData icon;

  const NavigationItem({
    required this.title,
    required this.route,
    required this.icon,
  });
}
