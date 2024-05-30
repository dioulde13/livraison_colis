import 'package:flutter/material.dart';

import '../couleur/liste_couleur.dart';
import '../fonctions/app_bar.dart';
import '../parametre/parametres.dart';
class Propos extends StatefulWidget {
  const Propos({super.key});

  @override
  ProposState createState() {
    return ProposState();
  }
}

class ProposState extends State<Propos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: entePage(
          context,
          const ParametrePage(),
          "A propos de nous",
          Coleur().couleur114521,
          Coleur().couleur114521,
          Coleur().couleur114521,
          "assets/images/livraisons.svg",
          Coleur().couleurF0EFF8
      ),
    );
  }
}
