import 'package:flutter/material.dart';

class CustomScaffoldMessenger {
  CustomScaffoldMessenger._();

  static final _instance = CustomScaffoldMessenger._();

  factory CustomScaffoldMessenger() => _instance;

  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSuccess(String message, {Duration? duration}) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }

  void showFail(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
