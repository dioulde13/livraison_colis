import 'package:flutter/material.dart';
import 'package:livraisons_colis/pages/dashboard/pied_page.dart';
import '../connexion/login.dart';
import '../couleur/liste_couleur.dart';
import '../enregistrement/expediteur.dart';
import '../fonctions/carre_acueil.dart';
import '../fonctions/formater_montant.dart';
import '../global.dart';
import '../historique/detail_historique.dart';
import '../livraisons/rechercher_colis.dart';
import '../parametre/parametres.dart';
import '../services/api_service.dart';
import '../statique/statique.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});



  @override
  AccueilPageState createState() {
    return AccueilPageState();
  }
}

class AccueilPageState extends State<AccueilPage> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool afficher = false;
  bool masquer = true;

  bool _refreshing = false;

  // void actualiserPage(StateSetter setState) {
  //   setState(() {
  //     EasyLoading.show();
  //     Future.delayed(const Duration(seconds: 6), () {
  //       EasyLoading.dismiss();
  //     });
  //   });
  // }

  //Fonction de rappel pour actualiser la page
  void _refreshPage() {
    setState(() {
      _refreshing = true;
    });

    setState(() {
      _refreshing = false;
    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Coleur().couleurF0EFF8,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Coleur().couleur114521,
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(
              Icons.sort,
              color: Colors.white,
              size: 40,
            ),
          ),
          // actions: const <Widget>[
          //   Icon(
          //     Icons.notifications,
          //     color: Colors.white,
          //     size: 35,
          //   ),
          //   SizedBox(
          //     width: 10,
          //   )
          // ],
        ),
        body:
        _refreshing
            ? const Center(
          child: CircularProgressIndicator(),
        )
            :SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                color: Coleur().couleur114521,
                child: Column(
                  children: [
                    const Text(
                      "Bonjour, MOMAR DIAGNE !",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        color: Coleur().couleur134D25,
                        borderRadius: BorderRadius.circular(5),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/home.png",
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/logolivraison.png",
                            height: 50,
                          ),
                          const Divider(),
                          const Text(
                            "Tout-en-Un",
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                          const Text(
                            "Transport de colis et de marchandises.",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Visibility(
                            visible: afficher,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Stack(
                                  children: [
                                    // Icon(
                                    //   Icons.remove_red_eye_outlined,
                                    //   size: 25,
                                    //   color: Coleur().couleurWhite,
                                    // ),
                                    SizedBox(width: 8),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Icon(
                                        Icons.remove,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        afficher = false;
                                        masquer = true;
                                      });
                                    },
                                    child: Text(
                                      montantTotal != null && montantTotal != '0'
                                          ? formaterUnMontant(double.tryParse(montantTotal)?.toDouble() ?? 0)
                                          : '0',
                                      style: TextStyle(
                                          color: Coleur().couleurWhite,
                                      fontSize: 15
                                      ),
                                    )
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: masquer,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon(
                                //   Icons.remove_red_eye_outlined,
                                //   size: 25,
                                //   color: Coleur().couleurWhite,
                                // ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    ServiceApi().montantTotalPayer(
                                        id: listeDonneeConnectionUser['id'],
                                        context: context);
                                    EasyLoading.show();
                                    Future.delayed(const Duration(seconds: 2),(){
                                    setState(() {
                                      afficher = true;
                                      masquer = false;
                                      });
                                    EasyLoading.dismiss();
                                    });
                                  },
                                  child: Text(
                                    "AFFICHER LE SOLDE",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Coleur().couleurWhite),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        carreAccueil(context, () {
                          statusDirectionPaiement = false;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DetailLivraison(),
                            ),
                          );
                        }, "assets/images/marchandise.svg", "Enregistrement", 25),
                        carreAccueil(context, () {
                          // ServiceApi().historiqueColisEnregistrer(
                          //     id: listeDonneeConnectionUser['id'],
                          //     context: context);
                          EasyLoading.show();
                       Future.delayed(const Duration(seconds: 4), () {
                         EasyLoading.dismiss();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const RechercheColis(),
                                ),
                              );
                          });

                        }
                        , "assets/images/livraisons.svg", "Livraison", 35),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        carreAccueil(context, () {
                          EasyLoading.show();
                          Future.delayed(const Duration(seconds: 4), () {
                            EasyLoading.dismiss();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => const Statique()));
                          });
                          ServiceApi().rechercheStatistique(
                              id: listeDonneeConnectionUser['id'],
                              adresseDestination: '',
                              dateDebut: '',
                              dateFin: '',
                              refreshCallback: _refreshPage,
                              typeEnvoi: "Avion",
                              context: context
                          );
                        }, "assets/images/statistque.svg", "Statistique", 25),
                        carreAccueil(context, () {
                          EasyLoading.show();
                          Future.delayed(const Duration(seconds: 4), () {
                              EasyLoading.dismiss();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => const Historique()));
                          ServiceApi().historiqueColisEnregistrer(
                              id: listeDonneeConnectionUser['id'],
                              context: context);
                          });
                        }, "assets/images/historique.svg", "Historique", 25),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width / 2,
          backgroundColor: Coleur().couleur114521,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Coleur().couleur114521,
                ),
                child: Text(
                  'Livraison de colis',
                  style: TextStyle(
                    color: Coleur().couleurWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // ListTile(
              //   title: Text(
              //     "Condition d'utilisation",
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: Coleur().couleurWhite),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => const AccueilPage()));
              //     // Navigator.pop(context);
              //   },
              // ),
              // ListTile(
              //   title: Text(
              //     "A propos",
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: Coleur().couleurWhite),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => const AccueilPage()));
              //     // Navigator.pop(context);
              //   },
              // ),
              ListTile(
                title: Text(
                  'Paramètres',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Coleur().couleurWhite),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ParametrePage()));
                  // Navigator.pop(context);
                },
              ),
              // ListTile(
              //   title: Text('Profil',
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: Coleur().couleurWhite
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).push(
              //         MaterialPageRoute(builder:
              //             (context) => Profil()
              //         )
              //     );
              //   },
              // ),
              const Divider(),
              ListTile(
                title: Text(
                  'Déconnexion',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Coleur().couleurWhite,
                      fontSize: 24),
                ),
                onTap: () {
                  _showContactBottomSheet();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar:
        footer(context)
    )
    ;
  }

  void _showContactBottomSheet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text(
                "Êtes-vous sûr(e) de vouloir vous déconnecter ?",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
}
