import 'package:flutter/material.dart';

Widget buttonCercle(
    String texte,
    Color color,
    VoidCallback onTapCallback,
    String imagePath
    ) {
  return SingleChildScrollView(
    child: Column(
      children: [
        InkWell(
          onTap: () {
            onTapCallback();
          },
          child: Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(35), // Half of height or width to make it a circle
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                height: 40, // Set the desired height for the image
                width: 40, // Set the desired width for the image
              ),
            ),
          ),
        ),
        const SizedBox(height: 8,),
        Text(texte,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold
        ),
        ),
      ],
    ),
  );
}
