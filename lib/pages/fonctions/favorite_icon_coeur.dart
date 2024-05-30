import 'package:flutter/material.dart' show BorderRadius, BoxDecoration, Color, Colors, Container, EdgeInsets, Icon, Icons, InkWell, Padding, Row, Text, TextStyle, VoidCallback, Widget;

import '../couleur/liste_couleur.dart';

Widget favoriteIconCoeur(
    String text,
    Color color,
    VoidCallback onTap, // Ajout du paramètre onTap
    ) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 30,
      width: 95,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 8, right: 5),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.favorite,
                size: 18,
                color: Coleur().couleur114521, // Remplacez cela par la couleur souhaitée
              ),
            ),
        ],
      ),
    ),
  );
}
