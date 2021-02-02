import 'package:flutter/material.dart';

var defaultInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(7));

String getFileName(String path) {
  return path.replaceAll('/', '\\').split('\\').last;
}

Route createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 200),
    reverseTransitionDuration: Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutExpo)),
        child: child,
      );
    },
  );
}

TextStyle keyboardHintTextStyle() {
  return TextStyle(fontSize: 8, letterSpacing: 1.2, color: Colors.grey[200]);
}
