import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import '../connexion/login.dart';
import '../couleur/liste_couleur.dart';
import '../dashboard/pied_page.dart';
import '../fonctions/button_cercle.dart';
import '../fonctions/formater_montant.dart';
import '../fonctions/modals.dart';
import '../global.dart';
import '../livraisons/rechercher_colis.dart';
import '../parametre/parametres.dart';
import '../services/api_service.dart';
import 'destinataire.dart';

class PaiementLivraison extends StatefulWidget {
  const PaiementLivraison({super.key, required this.suivant});

  final String suivant;

  @override
  PaiementLivraisonState createState() {
    return PaiementLivraisonState();
  }
}

class PaiementLivraisonState extends State<PaiementLivraison> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MonModal monModal = MonModal();

  bool afficher = false;
  bool masquer = true;

  TextEditingController telephoneMtnMoneyController = TextEditingController();
  TextEditingController telephoneOrangeMoneyController =
      TextEditingController();

  String _selectionnerCodePays = '+224'; // Default country code

  final _formKey = GlobalKey<FormState>();

  TextEditingController codeColis = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.suivant == 'À la livraison') {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            montantController.text = detailColis['mMontant'].toString().replaceAll('.0000', '');
          });
        });
      }
    } else if (widget.suivant == 'Relancer paiement') {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            montantController.text = infoColisNonPayer['mMontant'].toString().replaceAll('.0000', '');
          });
        });
      }
    } else {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            montantController.text = totalPrix.toString();
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Coleur().couleurF0EFF8,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Coleur().couleur274A26,
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
          actions: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: SvgPicture.asset(
                  "assets/images/livreurdecolis.svg",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      color: Coleur().couleur145127,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 6,
                          decoration: BoxDecoration(
                              color: Coleur().couleur274A26,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(35),
                                  bottomRight: Radius.circular(35))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Paiement - Livraison",
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Visibility(
                                  visible: afficher,
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 25,
                                            color: Coleur().couleurWhite,
                                          ),
                                          const SizedBox(width: 8),
                                          const Positioned(
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
                                            montantTotal != 0
                                                ? formaterUnMontant(
                                                    double.tryParse(
                                                            montantTotal)!
                                                        .toDouble())
                                                : '0',
                                            style: TextStyle(
                                                color: Coleur().couleurWhite),
                                          )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: masquer,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 25,
                                        color: Coleur().couleurWhite,
                                      ),
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
                                          "MONTANT PAYER",
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
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Montant : ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            Text(
                              widget.suivant == 'À la livraison'
                                  ? formaterUnMontant(double.tryParse(
                                          detailColis['mMontant'] ?? '0')!
                                      .toDouble())
                                  : widget.suivant == 'Relancer paiement'
                                      ? formaterUnMontant(double.tryParse(
                                              infoColisNonPayer['mMontant'] ??
                                                  '0')!
                                          .toDouble())
                                      : formaterUnMontant(totalPrix),
                              style: TextStyle(
                                  fontSize: 15, color: Coleur().couleurWhite),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 30,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Container(
                  //       height: 35,
                  //       width: 150,
                  //       decoration: BoxDecoration(
                  //           color: Coleur().couleur114521,
                  //           borderRadius: BorderRadius.circular(20)),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           SvgPicture.asset(
                  //             "assets/images/paiement.svg",
                  //             height: 24,
                  //           ),
                  //           const SizedBox(
                  //             width: 6,
                  //           ),
                  //           const Text(
                  //             "Manuel",
                  //             style:
                  //             TextStyle(fontSize: 18, color: Colors.white),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     Container(
                  //       height: 35,
                  //       width: 150,
                  //       decoration: BoxDecoration(
                  //           color: Coleur().couleurF2F2F2,
                  //           borderRadius: BorderRadius.circular(20)),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           SvgPicture.asset(
                  //             "assets/images/paiement.svg",
                  //             height: 24,
                  //           ),
                  //           const SizedBox(
                  //             width: 6,
                  //           ),
                  //           const Text(
                  //             "QR CODE",
                  //             style:
                  //             TextStyle(fontSize: 15, color: Colors.black),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    color: Coleur().couleurWhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mode de paiement * ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Coleur().couleur114521),
                          ),
                          SvgPicture.asset(
                            "assets/images/paiement.svg",
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Divider(),
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          const SizedBox(
                            width: 10,
                          ),
                          buttonCercle("MTN Money", Colors.white, () {
                            setState(() {
                              mtnMoney = true;
                              orangeMoney = false;
                              autres = false;
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: contenuModal(),
                                ),
                              );
                            });
                          }, "assets/images/mobile.png"),
                          const SizedBox(
                            width: 10,
                          ),
                          buttonCercle("Orange Money", Colors.white, () {
                            setState(() {
                              mtnMoney = false;
                              orangeMoney = true;
                              autres = false;
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: contenuModal(),
                                ),
                              );
                            });
                          }, "assets/images/orange-money-logo.jpg"),
                          const SizedBox(
                            width: 10,
                          ),
                          buttonCercle("Espèce", Colors.white, () {
                            setState(() {
                              mtnMoney = false;
                              orangeMoney = false;
                              autres = true;
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: contenuModal(),
                                ),
                              );
                            });
                          }, "assets/images/cash.jpg"),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      height: 35,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Coleur().couleur114521,
                          borderRadius: BorderRadius.circular(30)),
                      child: InkWell(
                        onTap: () {
                          widget.suivant == 'Maintenant'
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const DetailFormulaire(),
                                ))
                              : Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const RechercheColis(),
                                ));
                        },
                        child: const Text(
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          "Retourner",
                          textAlign: TextAlign.center,
                        ),
                      ),
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
                  _showBottomSheet();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: footer(context));
  }

  void _showBottomSheet() {
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
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

  Widget contenuModal() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Visibility(
                visible: mtnMoney,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Coleur().couleur114521,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "MTN Money",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Coleur().couleur114521,
                            fontSize: 15),
                      ),
                      const Divider(
                        thickness: 3,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "N° de téléphone *",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: telephoneMtnMoneyController,
                            maxLength: 9,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 8.0),
                                  child: DropdownButton<String>(
                                    value: _selectionnerCodePays,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectionnerCodePays = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      '+224',
                                      '+33',
                                    ] // Add more country codes as needed
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/phone.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // _fetchContacts();
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/contact.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                // contentPadding: EdgeInsets.fromLTRB(
                                //     16.0, 12.0, 8.0, 12.0),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir le téléphone";
                              } else if (!RegExp(r'^[0-9]+$')
                                  .hasMatch(value.replaceAll(".", ""))) {
                                return "Le numéro de téléphone est invalide";
                              } else if (!value.startsWith("66")) {
                                return "Le numéro doit commencer par 66";
                              } else if (value.length < 9) {
                                return "Le numéro de téléphone est invalide";
                              } else if (value.length > 9) {
                                return "Le numéro de téléphone est invalide";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          if (widget.suivant == 'Maintenant')
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, String> body = {
                                    'idUserConnect':
                                        listeDonneeConnectionUser['id'],
                                    'nomExpediteur':
                                        nomExpediteurController.text,
                                    'adresseExpediteur':
                                        selectedPaysExpediteur.toString(),
                                    'msisdnExpediteur':
                                        telephoneExpediteurController.text,
                                    'nomDestinateur':
                                        nomRecepteurController.text,
                                    'adresseDestinateur': nomPays.toString(),
                                    'msisdnDestinateur':
                                        telephoneRecepteurController.text,
                                    'heureDepot': heure,
                                    'modeEnvois': avion
                                        ? 'Avion'
                                        : bateau
                                            ? 'Bateau'
                                            : 'Voiture',
                                    'iPoid': nombreDePoinds.text,
                                    'vcUnite': selectionnerPoids.toString(),
                                    'quantite': counter.toString(),
                                    'mMontant': totalPrix
                                        .toString()
                                        .replaceAll('.0', ''),
                                    'idTypeColis': document
                                        ? "1"
                                        : colis
                                            ? "2"
                                            : '3',
                                    'idModePaiement': '2',
                                    'numeroCompteClient':
                                        telephoneMtnMoneyController.text,
                                    'description': descriptionController.text,
                                  };
                                  // print(body);
                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    ServiceApi().enregistrerColis(
                                        context: context,
                                        body: body,
                                        imagePath: image);
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                height: 35,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Coleur().couleur114521,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Valider",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else if (widget.suivant == 'À la livraison')
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, String> body = {
                                    'idUserConnect':
                                        listeDonneeConnectionUser['id'],
                                    'codeColis':
                                        detailColis['vcCodeColis'].toString(),
                                    'idModePaiement': '2',
                                    'montant': detailColis['mMontant']
                                        .toString()
                                        .replaceAll('.0000', ''),
                                    'numeroCompteClient':
                                        telephoneMtnMoneyController.text,
                                  };
                                  ServiceApi().paiementLivraison(
                                      context: context, body: body);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                height: 35,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Coleur().couleur114521,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Valider",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else if (widget.suivant == 'Relancer paiement')
                            InkWell(
                              onTap: () {
                                ServiceApi().relancerPaiement(
                                    refColis: infoColisNonPayer['vcCodeColis']
                                        .toString(),
                                    id: listeDonneeConnectionUser['id'],
                                    idModePaiement: '2',
                                    montant: infoColisNonPayer['mMontant']
                                        .toString()
                                        .replaceAll('.0000', ''),
                                    nuneroClient:
                                        telephoneMtnMoneyController.text,
                                    context: context);
                                // print("je suis ici Areeba");
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                height: 35,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Coleur().couleur114521,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Valider",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                )),
            Visibility(
                visible: orangeMoney,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Coleur().couleur114521,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Orange Money",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Coleur().couleur114521,
                            fontSize: 15),
                      ),
                      const Divider(
                        thickness: 3,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "N° de téléphone * ",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: telephoneOrangeMoneyController,
                            maxLength: 9,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 8.0),
                                  // Adjust the padding as needed
                                  child: DropdownButton<String>(
                                    value: _selectionnerCodePays,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectionnerCodePays = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      '+224',
                                      '+33',
                                    ] // Add more country codes as needed
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/phone.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // _fetchContacts();
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/contact.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                // contentPadding: EdgeInsets.fromLTRB(
                                //     16.0, 12.0, 8.0, 12.0),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir le téléphone";
                              } else if (!RegExp(r'^[0-9]+$')
                                  .hasMatch(value.replaceAll(".", ""))) {
                                return "Le numéro de téléphone est invalide";
                              } else if (!value.startsWith("6") &&
                                  _selectionnerCodePays == "+224") {
                                return "Le numéro  doit commencer par 6";
                              } else if (!value.startsWith("7") &&
                                  _selectionnerCodePays == "+33") {
                                return "Le numéro doit commencer par 7";
                              } else if (value.length < 9) {
                                return "Le numéro de téléphone est invalide";
                              } else if (value.startsWith("66")) {
                                return "Le numéro n'est pas MTN";
                              } else if (value.length > 9) {
                                return "Le numéro de téléphone est invalide";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          if (widget.suivant == 'Maintenant')
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, String> body = {
                                    'idUserConnect':
                                        listeDonneeConnectionUser['id'],
                                    'nomExpediteur':
                                        nomExpediteurController.text,
                                    'adresseExpediteur':
                                        selectedPaysExpediteur.toString(),
                                    'msisdnExpediteur':
                                        telephoneExpediteurController.text,
                                    'nomDestinateur':
                                        nomRecepteurController.text,
                                    'adresseDestinateur': nomPays.toString(),
                                    'msisdnDestinateur':
                                        telephoneRecepteurController.text,
                                    'heureDepot': heure,
                                    'modeEnvois': avion
                                        ? 'Avion'
                                        : bateau
                                            ? 'Bateau'
                                            : 'Voiture',
                                    'iPoid': nombreDePoinds.text,
                                    'vcUnite': selectionnerPoids.toString(),
                                    'quantite': counter.toString(),
                                    'mMontant': totalPrix
                                        .toString()
                                        .replaceAll('.0', ''),
                                    'idTypeColis': document
                                        ? "1"
                                        : colis
                                            ? "2"
                                            : '3',
                                    'idModePaiement': '1',
                                    'numeroCompteClient':
                                        telephoneOrangeMoneyController.text,
                                    'description': descriptionController.text,
                                  };
                                  // print(body);
                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    ServiceApi().enregistrerColis(
                                        context: context,
                                        body: body,
                                        imagePath: image);
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                height: 36,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Coleur().couleur114521,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Valider",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else if (widget.suivant == 'À la livraison')
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, String> body = {
                                    'idUserConnect':
                                        listeDonneeConnectionUser['id'],
                                    'codeColis':
                                        detailColis['vcCodeColis'].toString(),
                                    'idModePaiement': '1',
                                    'montant': detailColis['mMontant']
                                        .toString()
                                        .replaceAll('.0000', ''),
                                    'numeroCompteClient':
                                        telephoneOrangeMoneyController.text,
                                  };
                                  ServiceApi().paiementLivraison(
                                      context: context, body: body);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                height: 35,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Coleur().couleur114521,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Valide",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else if (widget.suivant == 'Relancer paiement')
                            InkWell(
                              onTap: () {
                                ServiceApi().relancerPaiement(
                                    refColis: infoColisNonPayer['vcCodeColis']
                                        .toString(),
                                    id: listeDonneeConnectionUser['id'],
                                    idModePaiement: '1',
                                    montant: infoColisNonPayer['mMontant']
                                        .toString()
                                        .replaceAll('.0000', ''),
                                    nuneroClient:
                                        telephoneMtnMoneyController.text,
                                    context: context);
                                // print("je suis ici Orange");
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                height: 35,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Coleur().couleur114521,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Valider",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                )),
            Visibility(
                visible: autres,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Coleur().couleur114521,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Pay Cash",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Coleur().couleur114521,
                            fontSize: 15),
                      ),
                      const Divider(
                        thickness: 3,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Saisir le montant ",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            enabled: false,
                            maxLength: 9,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              // labelText: 'Montant',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              suffixStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            controller: montantController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir le montant";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          if (widget.suivant == 'Maintenant')
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  EasyLoading.show();
                                  Map<String, String> body = {
                                    'idUserConnect':
                                        listeDonneeConnectionUser['id'],
                                    'nomExpediteur':
                                        nomExpediteurController.text,
                                    'adresseExpediteur':
                                        selectedPaysExpediteur.toString(),
                                    'msisdnExpediteur':
                                        telephoneExpediteurController.text,
                                    'nomDestinateur':
                                        nomRecepteurController.text,
                                    'adresseDestinateur': nomPays.toString(),
                                    'msisdnDestinateur':
                                        telephoneRecepteurController.text,
                                    'heureDepot': heure,
                                    'modeEnvois': avion
                                        ? 'Avion'
                                        : bateau
                                            ? 'Bateau'
                                            : 'Voiture',
                                    'mMontant': totalPrix
                                        .toString()
                                        .replaceAll('.0', ''),
                                    'iPoid': nombreDePoinds.text,
                                    'vcUnite': selectionnerPoids.toString(),
                                    'quantite': counter.toString(),
                                    'idTypeColis': document
                                        ? "1"
                                        : colis
                                            ? "2"
                                            : '3',
                                    'idModePaiement': '3',
                                    'numeroCompteClient':
                                        telephoneExpediteurController.text,
                                    'description': descriptionController.text,
                                  };
                                  // print(body);
                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    ServiceApi().enregistrerColis(
                                      context: context,
                                      body: body,
                                      imagePath: image,
                                    );
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                height: 35,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Coleur().couleur114521,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Valide",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else if (widget.suivant == 'À la livraison')
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, String> body = {
                                    'idUserConnect':
                                        listeDonneeConnectionUser['id'],
                                    'codeColis':
                                        detailColis['vcCodeColis'].toString(),
                                    'idModePaiement': '3',
                                    'montant': detailColis['mMontant']
                                        .toString()
                                        .replaceAll('.0000', ''),
                                    // 'numeroCompteClient': detailColis['vcMsisdnReceiver'].toString(),
                                  };
                                  ServiceApi().paiementLivraison(
                                      context: context, body: body);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                height: 35,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Coleur().couleur114521,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Valide",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else if (widget.suivant == 'Relancer paiement')
                            InkWell(
                              onTap: () {
                                ServiceApi().relancerPaiement(
                                    refColis: infoColisNonPayer['vcCodeColis']
                                        .toString(),
                                    id: listeDonneeConnectionUser['id'],
                                    idModePaiement: '3',
                                    montant: infoColisNonPayer['mMontant']
                                        .toString()
                                        .replaceAll('.0000', ''),
                                    // nuneroClient: telephoneMtnMoneyController.text,
                                    context: context);
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                height: 35,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Coleur().couleur114521,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Valider",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
