import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../couleur/liste_couleur.dart';
import '../dashboard/dashboard.dart';
import '../dashboard/pied_page.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  ProfilState createState() {
    return ProfilState();
  }
}

class ProfilState extends State<Profil> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Coleur().couleurDEE3E5,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Coleur().couleurF0EFF8,
          title: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const AccueilPage()));
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Coleur().couleur114521,
              )
          ),
          actions: [
            Row(
              children: [
                Text(
                  "Profil",
                  style: TextStyle(
                      color: Coleur().couleur114521,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 120),
                // Ajoute un espace de 8 pixels entre le texte et l'icône
                SvgPicture.asset(
                  "assets/images/user.svg",
                  width: 30,
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ],
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text("Nom: ",
                    // style: TextStyle(
                    //   fontSize: 25,
                    // ),
                    // ),
                    Text("Balde",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text("Prenom: ",
                    //   style: TextStyle(
                    //       fontSize: 25,
                    //   ),
                    // ),
                    Text("Mamadou Dioulde",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text("Email: ",
                    //   style: TextStyle(
                    //       fontSize: 25,
                    //   ),
                    // ),
                    Text("baldedioulde@gmal.com",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text("Telephone: ",
                    //   style: TextStyle(
                    //       fontSize: 25,
                    //   ),
                    // ),
                    Text("628 52 45 21",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/imo.png")
                        )
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/insta.jpeg")
                          )
                      ),                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/wattsapp.jpeg")
                          )
                      ),                     ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/facebook.jpeg")
                          )
                      ),                     ),
                  ],
                ),
              ],
        ),
        bottomNavigationBar:
        footer(context)
    );
  }

}
