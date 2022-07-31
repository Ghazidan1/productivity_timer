import 'package:flutter/material.dart';

typedef CallbackSetting = void Function(String, int);

class ProductivityButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final double defaultPadding = 5.0;

  ProductivityButton(
      {required this.text, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                backgroundColor: color, enableFeedback: true)));
  }
}

class SettingButton extends StatelessWidget {
  final Color color;
  final String text;
  final int value;
  final String setting;
  final CallbackSetting callback;

  SettingButton(
      {required this.color,
      required this.text,
      required this.value,
      required this.setting,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(text, style: TextStyle(color: Colors.white)),
      color: color,
      onPressed: () => callback(setting, value),
    );
  }
}
