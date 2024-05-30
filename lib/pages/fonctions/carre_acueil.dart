import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../couleur/liste_couleur.dart';

Widget carreAccueil(
  BuildContext context,
    VoidCallback onTap, // Add onTap as a parameter
    // Widget redirectionPage,
  String imagePath,
  String text,
  double heigh,
) {
  return InkWell(
    onTap: onTap,
    child: Center(
      child: Container(
        width: 120, // Largeur souhaitée
        height: 100, // Hauteur souhaitée
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            // Couleur de la bordure (noire)
            width: 0.5, // Épaisseur de la bordure
          ),
          borderRadius: BorderRadius.circular(10.0),
          // Rayon des coins arrondis
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // Couleur de la bordure
                      width: 2.0, // Épaisseur de la bordure
                    ),
                    color: Coleur().couleurF2F2F2,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      imagePath,
                      height: heigh,
                    ),
                  ),
                ),
              ),
              Text(text)
            ],
          ),
        ),
      ),
    ),
  );
}
