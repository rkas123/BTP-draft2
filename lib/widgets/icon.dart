import 'package:flutter/material.dart';

class MyIcon extends StatelessWidget {
  final IconData icon;
  final String size;
  const MyIcon({this.icon, this.size = 'default', Key key}) : super(key: key);

  double getSize(String size) {
    switch (size) {
      case 'sm':
        return 12;
      case 'default':
        return 24;
      case 'md':
        return 24;
      case 'lg':
        return 48;
      case 'xl':
        return 72;
    }
    return 24;
  }

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: getSize(size));
  }
}
