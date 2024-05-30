import 'package:flutter/material.dart';

import '../couleur/liste_couleur.dart';

Widget buttonSheet(
    BuildContext context,
    String livraison,
    String montant,
    String continuer,
    String sup,
    VoidCallback onTap, // Add onTap as a parameter
    ) {
  return Container(
    height: 60,
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(vertical: 10),
    color: Coleur().couleur114521,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                "$livraison:",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
              Text(
                montant,
                style: TextStyle(
                  color: Coleur().couleur114521,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 80,
          width: 1,
          color: Colors.white,
        ),
        InkWell(
          onTap: onTap, // Use the onTap parameter here
          child: Row(
            children: [
              Text(
                continuer,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 15,),
              Icon(Icons.arrow_forward_ios,
              color: Coleur().couleurWhite,
              )
            ],
          ),
        ),
      ],
    ),
  );
}
