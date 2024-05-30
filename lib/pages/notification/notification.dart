import 'package:flutter/material.dart';

import '../couleur/liste_couleur.dart';
import '../fonctions/app_bar.dart';
import '../parametre/parametres.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  NotificationsState createState() {
    return NotificationsState();
  }
}

class NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:entePage(
          context,
          const ParametrePage(),
          "Notification",
          Coleur().couleur114521,
          Coleur().couleur114521,
          Coleur().couleur114521,
          "assets/images/livraisons.svg",
          Coleur().couleurF0EFF8
      ),
    );
  }
}
