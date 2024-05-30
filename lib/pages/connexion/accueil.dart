import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  AccueilState createState() {
    return AccueilState();
  }
}

class AccueilState extends State<Accueil> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage()
            )
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
           child:  Container(
             padding: const EdgeInsets.all(80),
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width,
             decoration: const BoxDecoration(
               image: DecorationImage(
                 fit: BoxFit.cover,
                 image: AssetImage("assets/images/fond.png"),
               ),
             ),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 const Divider(
                   thickness: 3, // Ajustez la valeur selon vos besoins pour augmenter la largeur
                   color: Colors.yellow, // Remplacez par la couleur souhaitée
                 ),
                 const SizedBox(height: 90,),
                 Image.asset(
                   "assets/images/logolivraison.png",
                   height: 60,
                 ),
                 const SizedBox(height: 90,),
                 const Divider(
                   thickness: 3, // Ajustez la valeur selon vos besoins pour augmenter la largeur
                   color: Colors.yellow, // Remplacez par la couleur souhaitée
                 ),
               ],
             ),
           ),
      ),
    );
  }
}
