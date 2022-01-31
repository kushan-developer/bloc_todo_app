import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, Color color, String message) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}
