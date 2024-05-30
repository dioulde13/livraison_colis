import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../couleur/liste_couleur.dart';
import '../fonctions/button_confirmer_abandonner.dart';
import '../fonctions/button_sheet.dart';
import 'paiement_livraison.dart';
import '../global.dart';
import '../dashboard/pied_page.dart';
import '../fonctions/app_bar.dart';
import '../fonctions/formater_montant.dart';
import '../fonctions/modals.dart';
import '../fonctions/tableau.dart';
import '../services/api_service.dart';
import 'expediteur.dart';
import 'dart:io';

class DetailFormulaire extends StatefulWidget {
  const DetailFormulaire({super.key});

  @override
  DetailFormulaireState createState() {
    return DetailFormulaireState();
  }
}

class DetailFormulaireState extends State<DetailFormulaire> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          image = null;
          nombreDePoinds.text = '';
          descriptionController.text = '';
          montantController.text = '';
          totalPoid = 0;
          counter = 1;
          avion = true;
          bateau = false;
          voiture = false;
          document = true;
          colis = false;
          marchandise = false;
        });
      });
    }
    montantController.addListener(_onTextChanged);
  }

  Future<void> _onTextChanged() async {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          totalPrix = calculResultat(montantController.text);
        });
      });
    }
  }

  double calculResultat(String input) {
    try {
      double inputValue = double.parse(input);
      return inputValue;
    } catch (e) {
      return 0.0;
    }
  }

  calcul() {
    setState(() {
      totalPoid = double.tryParse(nombreDePoinds.text)!.toDouble() * counter;
    });
  }

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      counter--;
    });
  }

  final MonModal monModal = MonModal();

  final _formKey = GlobalKey<FormState>();

  String _selectionnerSigne = "GNF";

  bool message = false;

  Future _pictureImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      image = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Coleur().couleurDEE3E5,
        appBar: entePage(
            context,
            const DetailLivraison(),
            "Livraison - Express",
            Coleur().couleur114521,
            Coleur().couleur114521,
            Coleur().couleur114521,
            "assets/images/livreurdecolis.svg",
            Coleur().couleurE0E0E0),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Coleur().couleurWhite,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        infoExpediteurDestinateur(),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Type colis",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        _typeColis(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            champetSelect(),
                            buttonIncrementDecrement()
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Saisir le montant à payer",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            // Seuls les chiffres sont autorisés
                          ],
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              // Adjust the padding as needed
                              child: DropdownButton<String>(
                                value: _selectionnerSigne,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectionnerSigne = newValue!;
                                  });
                                },
                                items: <String>[
                                  'GNF',
                                  'EUR',
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
                            } else if (!RegExp(r'^[0-9]+$')
                                .hasMatch(value.replaceAll(".", ""))) {
                              return "Saisir un entier";
                            } else if (value.endsWith('.')) {
                              return "Le montant ne doit pas se terminer par un point.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Type envoi",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 2,
                        ),
                        _typeEvoi(),
                        const SizedBox(
                          height: 20,
                        ),
                        descriptionETPhoto()
                      ],
                    ),
                  ),
                ),
              ),
              buttonSheet(
                context,
                "Livraison à",
                formaterUnMontant(totalPrix),
                "Continuer",
                ">",
                () {
                  if (_formKey.currentState!.validate() && image != null) {
                    calcul();
                    monModal.showBottomSheet(
                      context,
                      contenuModal(),
                      showFermerButton: false,
                    );
                  } else {
                    setState(() {
                      message = true;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: footer(context));
  }

  descriptionETPhoto() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Description et Photo...",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              Icons.file_copy,
              color: Coleur().couleur114521,
            ),
          ],
        ),
        const Divider(),
        const SizedBox(
          height: 30,
        ),
        TextFormField(
          controller: descriptionController,
          minLines: 4,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'Le contenus du colis sont......................',
            // labelText: 'Message',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Veuillez saisir la description";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image == null)
              Image.asset(
                "assets/images/phot.png",
                height: 100,
              )
            else
              Image.file(
                image!,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Coleur().couleur114521,
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _pictureImageFromCamera();
                    });
                  },
                  child: Text(
                    "Photo",
                    style: TextStyle(color: Coleur().couleurWhite),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            if (image != null)
              ElevatedButton.icon(
                label: const Text("Supprimer l'image"),
                onPressed: () {
                  setState(() {
                    image = null;
                  });
                },
                icon: const Icon(Icons.close),
              )
            else
              Text(
                message ? "Veuillez prendre une photo du colis" : "",
                style: const TextStyle(color: Colors.red, fontSize: 12),
              )
          ],
        ),
      ],
    );
  }

  infoExpediteurDestinateur() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Alignez les éléments à gauche
          children: [
            Text(
              "Destinataire",
              style: TextStyle(
                  fontSize: 20,
                  color: Coleur().couleur114521,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Espace vertical entre les éléments
            Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: Coleur().couleurE0E0E0,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Favoris"),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: 25.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Coleur().couleurWhite,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Coleur().couleur114521,
                        size: 16,
                      ))
                ],
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            SvgPicture.asset(
              "assets/images/destination.svg",
              height: 30,
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              height: 80,
              width: 1,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Nom:  ",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      nomExpediteurController.text,
                      style: TextStyle(
                          color: Coleur().couleur114521, fontSize: 12),
                    )
                  ],
                ),
                // Row(
                //   children: [
                //     const Text("Adresse:  ",
                //         style: TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.w300)),
                //     Text(selectedPaysExpediteur!,
                //       style: TextStyle(
                //           color: Coleur().couleur114521,
                //           fontSize: 12),
                //     )
                //   ],
                // ),
                Row(
                  children: [
                    const Text("Téléphone:  ",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300)),
                    Text(
                      telephoneExpediteurController.text,
                      style: TextStyle(
                          color: Coleur().couleur114521, fontSize: 13),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Date & heure:  ",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300)),
                    Expanded(
                      child: Text(
                        DateFormat('dd / MM / yyy HH:mm').format(laDate),
                        style: TextStyle(
                            color: Coleur().couleur114521, fontSize: 12),
                      ),
                    )
                  ],
                )
              ],
            )),
            Icon(
              Icons.arrow_forward_ios,
              size: 25,
              color: Coleur().couleur114521,
            )
          ],
        ),
        const Divider(),
        Row(
          children: [
            SvgPicture.asset(
              "assets/images/destination.svg",
              height: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Nom récepteur:  ",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      nomRecepteurController.text,
                      style: TextStyle(
                          color: Coleur().couleur114521, fontSize: 12),
                    )
                  ],
                ),
                // Row(
                //   children: [
                //     const Text("Adresse:  ",
                //         style: TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.w300)),
                //     Text(
                //       nomPays,
                //       style: TextStyle(
                //           color: Coleur().couleur114521,
                //           fontSize: 12),
                //     )
                //   ],
                // ),
                Row(
                  children: [
                    const Text("Téléphone:  ",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300)),
                    Text(
                      telephoneRecepteurController.text,
                      style: TextStyle(
                          color: Coleur().couleur114521, fontSize: 13),
                    )
                  ],
                ),
              ],
            )),
            Icon(
              Icons.arrow_forward_ios,
              color: Coleur().couleur114521,
              size: 25,
            )
          ],
        ),
      ],
    );
  }

  Widget champetSelect() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Poids *"),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: nombreDePoinds,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              // Seuls les chiffres sont autorisés
            ],
            decoration: InputDecoration(
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                // Adjust the padding as needed
                child: DropdownButton<String>(
                  value: selectionnerPoids,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectionnerPoids = newValue!;
                    });
                  },
                  items: <String>[
                    'kg',
                    'hg',
                    'dag',
                    'g',
                    'dg',
                    'cg',
                    'mg'
                  ] // Add more country codes as needed
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 8.0, 12.0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Le champs est vide";
              } else if (!RegExp(r'^[0-9]+$')
                  .hasMatch(value.replaceAll(".", ""))) {
                return "Saisir un entier";
              } else if (value.endsWith('.')) {
                return "Le montant ne doit pas se terminer par un point.";
              } else if (int.tryParse(value)!.toInt() > 30 &&
                  selectionnerPoids == "kg") {
                return "Max 30kg";
              } else if (int.tryParse(value)!.toInt() > 300 &&
                  selectionnerPoids == "hg") {
                return "Max 300hg";
              } else if (int.tryParse(value)!.toInt() > 3000 &&
                  selectionnerPoids == "dag") {
                return "Max 3000dag";
              } else if (int.tryParse(value)!.toInt() > 30000 &&
                  selectionnerPoids == "g") {
                return "Max 30 000g";
              } else if (int.tryParse(value)!.toInt() > 300000 &&
                  selectionnerPoids == "dg") {
                return "Max 300 000dg";
              } else if (int.tryParse(value)!.toInt() > 3000000 &&
                  selectionnerPoids == "cg") {
                return "Max 3000 000cg";
              } else if (int.tryParse(value)!.toInt() > 30000000 &&
                  selectionnerPoids == "mg") {
                return "Max 30 000 000cg";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buttonIncrementDecrement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quantité *"),
        const SizedBox(
          height: 5,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2.7,
          height: 45,
          decoration: BoxDecoration(
            color: Coleur().couleurWhite,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (counter > 1) {
                        _decrementCounter();
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Container(
                    height: 90,
                    width: 1,
                    color: Colors.black,
                  ),
                ],
              ),
              Text(
                '$counter',
                style: const TextStyle(fontSize: 15),
              ),
              Row(
                children: [
                  Container(
                    height: 90,
                    width: 1,
                    color: Colors.black,
                  ),
                  IconButton(
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _typeColis() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  document = true;
                  colis = false;
                  marchandise = false;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color:
                      document ? Coleur().couleurE0E0E0 : Coleur().couleurWhite,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(child: Container()), // Expansion vide à gauche
                    Center(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/doc.svg",
                            height: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Documents",
                            style: TextStyle(
                                fontSize: 12,
                                color: Coleur().couleur114521,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()), // Expansion vide à droite
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  document = false;
                  colis = true;
                  marchandise = false;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: colis ? Coleur().couleurE0E0E0 : Coleur().couleurWhite,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(child: Container()), // Expansion vide à gauche
                    Center(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/colis.svg",
                            height: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Colis",
                            style: TextStyle(
                                fontSize: 12,
                                color: Coleur().couleur114521,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()), // Expansion vide à droite
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  document = false;
                  colis = false;
                  marchandise = true;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: marchandise
                      ? Coleur().couleurE0E0E0
                      : Coleur().couleurWhite,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(child: Container()), // Expansion vide à gauche
                    Center(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/marchandise.svg",
                            height: 16,
                          ),
                          Text(
                            "Marchandises",
                            style: TextStyle(
                                fontSize: 10,
                                color: Coleur().couleur114521,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()), // Expansion vide à droite
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeEvoi() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  avion = true;
                  bateau = false;
                  voiture = false;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: avion ? Coleur().couleurE0E0E0 : Coleur().couleurWhite,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(child: Container()), // Expansion vide à gauche
                    Center(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/avion.svg",
                            height: 25,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Avion",
                            style: TextStyle(
                              fontSize: 12,
                              color: Coleur().couleur114521,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()), // Expansion vide à droite
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  avion = false;
                  bateau = true;
                  voiture = false;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color:
                      bateau ? Coleur().couleurE0E0E0 : Coleur().couleurWhite,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(child: Container()), // Expansion vide à gauche
                    Center(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/bateau.svg",
                            height: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Bateau",
                            style: TextStyle(
                                fontSize: 12,
                                color: Coleur().couleur114521,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()), // Expansion vide à droite
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  avion = false;
                  bateau = false;
                  voiture = true;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color:
                      voiture ? Coleur().couleurE0E0E0 : Coleur().couleurWhite,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(child: Container()), // Expansion vide à gauche
                    Center(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/voiture.svg",
                            height: 25,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Voiture",
                            style: TextStyle(
                                fontSize: 12,
                                color: Coleur().couleur114521,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()), // Expansion vide à droite
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contenuModal() {
    return Column(
      children: [
        const Text(
          "Récapitulatif du colis:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 2,
          width: 350,
          color: Colors.black,
        ),
        const SizedBox(
          height: 15,
        ),
        tableau("Livraison Express: ", "Conakry", Colors.black),
        const SizedBox(
          height: 15,
        ),
        const Divider(),
        const SizedBox(
          height: 5,
        ),
        tableau(
            "Catégorie: ",
            document
                ? "Document"
                : colis
                    ? "Colis"
                    : marchandise
                        ? "Marchandise"
                        : "",
            Colors.black),
        tableau(
            "Poids: ",
            "${nombreDePoinds.text} $selectionnerPoids * $counter = $totalPoid  $selectionnerPoids",
            Colors.black),
        tableau(
            "Type d'envoi: ",
            avion
                ? "Avion"
                : bateau
                    ? "Bateau"
                    : voiture
                        ? "Voiture"
                        : "",
            Colors.black),
        tableau(
            "Date & heure: ",
            formatDate(DateTime.parse('$laDate'),
                [dd, '/', mm, '/', yyyy, ' - ', HH, ':', nn]),
            Colors.black),
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        const SizedBox(
          height: 5,
        ),
        tableau("Expéditeur: ", nomExpediteurController.text, Colors.black),
        tableau("Adresse: ", selectedPaysExpediteur!, Colors.black),
        tableau(
            "Telephone: ", telephoneExpediteurController.text, Colors.black),
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        const SizedBox(
          height: 5,
        ),
        tableau("Récepteur: ", nomRecepteurController.text, Colors.black),
        tableau("Adresse: ", nomPays, Colors.black),
        tableau("Téléphone: ", telephoneRecepteurController.text, Colors.black),
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        const SizedBox(
          height: 5,
        ),
        tableau("Prix de la livraison: ", formaterUnMontant(totalPrix),
            Colors.black),
        tableau("Frais 0%: ", "0 GNF", Colors.black),
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        const SizedBox(
          height: 5,
        ),
        tableau("Vous payez: ", formaterUnMontant(totalPrix),
            Coleur().couleur114521),
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        tableau("Description: ", descriptionController.text,
            Coleur().couleur114521),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Photo"),
            image == null
                ? const Text('Aucune image sélectionnée.')
                : Image.file(
                    image!,
                    height: 70,
                    width: 80,
                  )
          ],
        ),
        const Divider(),
        const SizedBox(
          height: 15,
        ),
        buttonConfirmeAbandonner(
            context,
            //         () {
            //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaiementLivraison()));
            // },
            () => showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return AlertDialog(
                        title: const Text('Voulez-vous payer?'),
                        content: buttonConfirmeAbandonner(context, () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PaiementLivraison(
                                  suivant: 'Maintenant')));
                        }, () {
                          if (_formKey.currentState!.validate()) {
                            Map<String, String> body = {
                              'idUserConnect': listeDonneeConnectionUser['id'],
                              'nomExpediteur': nomExpediteurController.text,
                              'adresseExpediteur':
                                  selectedPaysExpediteur.toString(),
                              'msisdnExpediteur':
                                  telephoneExpediteurController.text,
                              'nomDestinateur': nomRecepteurController.text,
                              'adresseDestinateur': nomPays.toString(),
                              'msisdnDestinateur':
                                  telephoneRecepteurController.text,
                              'heureDepot': heure,
                              'modeEnvois': avion
                                  ? 'Avion'
                                  : bateau
                                      ? 'Bateau'
                                      : 'Voiture',
                              'mMontant':
                                  totalPrix.toString().replaceAll('.0', ''),
                              'iPoid': nombreDePoinds.text,
                              'vcUnite': selectionnerPoids.toString(),
                              'quantite': counter.toString(),
                              'idTypeColis': document
                                  ? "1"
                                  : colis
                                      ? "2"
                                      : '3',
                              'idModePaiement': '4',
                              'numeroCompteClient':
                                  telephoneExpediteurController.text,
                              'description': descriptionController.text,
                            };
                            // print(body);
                            EasyLoading.show();
                            Future.delayed(const Duration(seconds: 3), () {
                                ServiceApi().enregistrerColis(
                                  context: context,
                                  body: body,
                                  imagePath: image,
                                );
                            });
                          }
                        },
                            "Maintenant",
                            "À la livraison",
                            Coleur().couleur00A759,
                            Coleur().couleur114521,
                            0.3,
                            0.3));
                  });
                }), () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const DetailFormulaire()));
        }, "Suivant", "Abandonner", Coleur().couleur00A659,
            Coleur().couleur114521, 0.4, 0.4),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
