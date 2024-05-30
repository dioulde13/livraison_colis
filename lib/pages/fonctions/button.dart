import 'package:flutter/material.dart';

Widget button(
    BuildContext context,
    VoidCallback onTap,
    String text,
    Color colorbutton,
    Color colortext,
    double nombre,
    double height,
    double circularValeur,
    double widthBorder,
    ) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height,
      width: MediaQuery
          .of(context)
          .size
          .width / nombre,
      decoration: BoxDecoration(
          color: colorbutton,
          borderRadius: BorderRadius.circular(circularValeur),
        border: Border.all(width: widthBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
          style: TextStyle(
              color: colortext,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );

}
