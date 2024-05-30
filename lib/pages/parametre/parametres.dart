import 'package:flutter/material.dart';
import '../connexion/login.dart';
import '../couleur/liste_couleur.dart';
import '../dashboard/dashboard.dart';
import '../dashboard/pied_page.dart';
import '../fonctions/app_bar.dart';
import '../global.dart';
import '../modifierprofil/modifier.dart';
import 'changer_mot_passe_page.dart';

class ParametrePage extends StatefulWidget {
  const ParametrePage({super.key});

  @override
  ParametrePageState createState() {
    return ParametrePageState();
  }
}

class ParametrePageState extends State<ParametrePage> {
  void _showContactBottomSheet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text("Êtes-vous sûr(e) de vouloir vous déconnecter ?",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Non'),
                    child: const Text(
                      'Non',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                    child: const Text(
                      'Oui',
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: entePage(
            context,
            const AccueilPage(),
            "Paramètres",
            Coleur().couleurWhite,
            Coleur().couleurWhite,
            Coleur().couleurWhite,
            '',
            Coleur().couleur114521),
        body: ListView(
          children: <Widget>[
            const ListTile(
              title: Row(
                children: [
                  Text(
                    "Paramètres",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  )
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipOval(
                    child: Image.asset("assets/images/profil.png", height: 60),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        listeDonneeConnectionUser['vcPrenom'] +
                            " " +
                            listeDonneeConnectionUser['vcNom'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        listeDonneeConnectionUser['email'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        listeDonneeConnectionUser['vcMsisdn'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Modifier()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Modifier le profil",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangerPassePage()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Changer de mot de passe",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            // ListTile(
            //   title: InkWell(
            //     onTap: () {
            //       Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const Notifications(),
            //       ));
            //     },
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           children: [
            //             Icon(
            //               Icons.notifications,
            //               size: 40,
            //             ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Text(
            //               "Notification",
            //               style: TextStyle(
            //                   fontSize: 15, fontWeight: FontWeight.bold),
            //             )
            //           ],
            //         ),
            //         Icon(Icons.arrow_forward_ios)
            //       ],
            //     ),
            //   ),
            // ),
            // ListTile(
            //   title: InkWell(
            //     onTap: () {
            //       Navigator.of(context).push(
            //           MaterialPageRoute(builder: (context) => const System()));
            //     },
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           children: [
            //             Icon(
            //               Icons.settings_system_daydream_sharp,
            //               size: 40,
            //             ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Text(
            //               "Systeme",
            //               style: TextStyle(
            //                   fontSize: 15, fontWeight: FontWeight.bold),
            //             )
            //           ],
            //         ),
            //         Icon(Icons.arrow_forward_ios)
            //       ],
            //     ),
            //   ),
            // ),
            // ListTile(
            //   title: InkWell(
            //     onTap: () {
            //       Navigator.of(context).push(
            //           MaterialPageRoute(builder: (context) => const General()));
            //     },
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           children: [
            //             Icon(
            //               Icons.build,
            //               size: 40,
            //             ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Text(
            //               "Gènèrale",
            //               style: TextStyle(
            //                   fontSize: 15, fontWeight: FontWeight.bold),
            //             )
            //           ],
            //         ),
            //         Icon(Icons.arrow_forward_ios)
            //       ],
            //     ),
            //   ),
            // ),
            // ListTile(
            //   title: InkWell(
            //     onTap: () {
            //       Navigator.of(context).push(
            //           MaterialPageRoute(builder: (context) => const Propos()));
            //     },
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           children: [
            //             Icon(
            //               Icons.where_to_vote_outlined,
            //               size: 40,
            //             ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Text(
            //               "A propos de nous",
            //               style: TextStyle(
            //                   fontSize: 15, fontWeight: FontWeight.bold),
            //             )
            //           ],
            //         ),
            //         Icon(Icons.arrow_forward_ios)
            //       ],
            //     ),
            //   ),
            // ),
            ListTile(
              title: InkWell(
                onTap: () {
                  _showContactBottomSheet();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Deconnexion",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
        footer(context)
    );
  }
}
