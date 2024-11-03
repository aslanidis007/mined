import 'package:flutter/material.dart';
import 'color.dart';

//Reminder of actions through messages
void showMessage({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    content: Text(
      message!,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: AppColors.lightMov.withOpacity(0.2),
  ));
}