import 'package:flutter/material.dart';

Widget buttonConfirmeAbandonner(
    BuildContext context,
    VoidCallback onTap1,
    VoidCallback onTap,
    String text1,
    String text2,
    Color color1,
    Color color2,
    double width1,
    double width2
    ) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap1,
          child:
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * width1,
            decoration: BoxDecoration(
              color: color1,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
            ),
            child: Center(
              child: Text(text1,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child:
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * width2,
            decoration: BoxDecoration(
              color: color2,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Center(
              child: Text(text2,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
            ),
          ),
        ),
      ],
    );

}
