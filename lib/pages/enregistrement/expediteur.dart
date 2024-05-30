
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import '../fonctions/app_bar.dart';
import '../dashboard/dashboard.dart';
import '../dashboard/pied_page.dart';
import '../couleur/liste_couleur.dart';
import '../fonctions/button_sheet.dart';
import '../fonctions/favorite_icon_coeur.dart';
import '../fonctions/formater_montant.dart';
import '../fonctions/pays.dart';
import '../global.dart';
import '../services/api_service.dart';
import 'destinataire.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DetailLivraison extends StatefulWidget {
  const DetailLivraison({super.key});

  @override
  DetailLivraisonState createState() {
    return DetailLivraisonState();
  }
}

class DetailLivraisonState extends State<DetailLivraison> {
  TimeOfDay heureSelectionnee = TimeOfDay.now();

  bool favori = true;
  bool contact = false;

  // final _formKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();

  final TextEditingController numeroClientFavoris = TextEditingController();
  final TextEditingController numeroClientRecherche = TextEditingController();

  String _selectionnerCodePaysExpediteur = '+224';
  String _selectionnerCodePaysRecepteur = '+224';
  String _selectionnerCodePaysFavoris = '+224';
  List<String> codesPays = ['+224', '+33'];

  Pays? selectionPays;
  List<Pays> listePays = [];

  List<Contact>? _contacts;

  List filtrerListeClientFavorisParTelephone = [];

  @override
  void initState() {
    super.initState();
    filtrerListeClientFavorisParTelephone = listeTotalClientFavoris != null
        ? List.from(listeTotalClientFavoris)
        : [];
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          nomExpediteurController.text = '';
          adresseExpediteurController.text = '';
          telephoneExpediteurController.text = '';
          dateController.text = '';
          nomRecepteurController.text = '';
          adresseRecepteurController.text = '';
          telephoneRecepteurController.text = '';
          fetchCountries();
        });
      });
    }
  }

  Future<void> fetchCountries() async {
    // print(listesPays);
      List<Pays> countries = [];
      // print(countries);
      for (var pays in listesPays) {
        countries.add(Pays.fromJson(pays));
      }
      setState(() {
        listePays = countries;
        // print(listePays);
        selectionPays = countries.firstWhere((pays) => pays.nom == 'GUINEE');
      });

  }

  String query = "";

  void _filterClients(String query) {
    setState(() {
      filtrerListeClientFavorisParTelephone =
          listeTotalClientFavoris.where((client) {
        bool matchesPhone = client['vcMsisdn']?.toLowerCase().contains(query.toLowerCase()) ?? false;
        return matchesPhone;
      }).toList();
    });
  }

  Future<void> refreshModalData(StateSetter setState) async {
    setState(() {
      EasyLoading.show();
      Future.delayed(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
        ServiceApi().listeCLientFavoris(id: listeDonneeConnectionUser['id'], context: context);
        filtrerListeClientFavorisParTelephone = listeTotalClientFavoris != null ? List.from(listeTotalClientFavoris) : [];
      });
    });
  }

  // void maDate() {
  //   TimeOfDay heureActuelle = TimeOfDay.now();
  //   showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2040),
  //   ).then((selectedDate) {
  //     if (selectedDate != null) {
  //       // Utilisez l'heure actuelle obtenue précédemment comme heure initiale
  //       showTimePicker(
  //         context: context,
  //         initialTime: heureActuelle,
  //       ).then((selectedTime) {
  //         if (selectedTime != null) {
  //           // Extraire l'heure et les minutes
  //           int heure = selectedTime.hour;
  //           int minutes = selectedTime.minute;
  //
  //           // Créer une nouvelle instance de DateTime avec la date sélectionnée et l'heure sélectionnée
  //           DateTime selectedDateTime = DateTime(
  //             selectedDate.year,
  //             selectedDate.month,
  //             selectedDate.day,
  //             heure,
  //             minutes,
  //           );
  //           setState(() {
  //             laDate = selectedDateTime;
  //             heureSelectionnee = selectedTime;
  //           });
  //         }
  //       });
  //     }
  //   });
  // }

  TextEditingController adresseController = TextEditingController();

  // void differenceDate(){
  //   DateTime dateF = DateTime.parse(laDate.toString());
  //   DateTime dateD = DateTime.now();
  //   Duration diff = dateF.difference(dateD);
  //   jour = diff.inDays;
  //   heures = diff.inHours;
  //   // print("K***----");
  //   // print(dateF);
  //   // print(dateD);
  //   // print(diff);
  //   // print(diff.inDays);
  //   // print(diff.inHours);
  // }

  final TextEditingController _autocompleteController = TextEditingController();

  @override
  void dispose() {
    _autocompleteController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Coleur().couleurE0E0E0,
        appBar: entePage(
            context,
            const AccueilPage(),
            "Livraison - Express",
            Coleur().couleur114521,
            Coleur().couleur114521,
            Coleur().couleur114521,
            "assets/images/livreurdecolis.svg",
            Coleur().couleurE0E0E0),
        body: Column(
          children: [
            infoExpediteurEtDestinateur(),
            buttonSheet(
              context,
              "Livraison à",
              formaterUnMontant(double.tryParse('0') ?? 0.0),
              "Continuer",
              ">",
              () {
                // supprimerImage();
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DetailFormulaire()));
                }
              },
            ),
          ],
        ),
        bottomNavigationBar:
        footer(context)
    );
  }

  infoExpediteurEtDestinateur() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Coleur().couleurWhite,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Expéditeur",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  favoriteIconCoeur(
                    "Favoris",
                    Coleur().couleurE0E0E0,
                    () {
                      setState(() {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          numeroClientRecherche.clear();
                        });
                        EasyLoading.show();
                        Future.delayed(const Duration(seconds: 1), () {
                          EasyLoading.dismiss();
                          _filterClients('');
                          _showBottomSheetFavoris(context);
                        });
                      });
                      ServiceApi().listeCLientFavoris(
                          id: listeDonneeConnectionUser['id'],
                          context: context);
                    },
                  )
                ],
              ),
              const Divider(),
              const Text("Remplissez les champs vides"),
              const Divider(),
              Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Nom expéditeur *"),
                      const SizedBox(
                        height: 2,
                      ),
                      TextFormField(
                        controller: nomExpediteurController,
                        decoration: InputDecoration(
                          hintText: "Nom expéditeur",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir le nom et le prénom";
                          }
                          return null;
                        }),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Adresse *"),
                      const SizedBox(
                        height: 2,
                      ),
                      Autocomplete<String>(
                        optionsBuilder:
                            (TextEditingValue paysTextEditingValue) {
                          if (paysTextEditingValue.text.isEmpty) {
                            return listPays;
                          }
                          String searchText =
                              paysTextEditingValue.text.toLowerCase();
                          return listPays.where((String option) {
                            return option.toLowerCase().contains(searchText);
                          });
                        },
                        onSelected: (String value) {
                          setState(() {
                            selectedPaysExpediteur = value;
                          });
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                          return TextFormField(
                            onChanged: (text) {
                              setState(() {
                                favori = false;
                              });
                            },
                            focusNode: focusNode,
                            controller: favori ? adresseController : controller,
                            decoration: InputDecoration(
                              hintText: "Adresse",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                            ),
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir l'adresse";
                              }
                              return null;
                            }),
                          );
                        },
                      ),
                      // TextFormField(
                      //     controller: infosEnregistrement
                      // .adresseExpediteurController,
                      //     decoration: InputDecoration(
                      //       hintText: "Adresse",
                      //       border: OutlineInputBorder(
                      //           borderRadius:
                      //           BorderRadius.circular(10)),
                      //       contentPadding: EdgeInsets.symmetric(
                      //           vertical: 10, horizontal: 20),
                      //       suffixIcon: IconButton(
                      //         onPressed: () {
                      //           // openMap(9.5561702, -13.6722476);
                      //         },
                      //         icon: SvgPicture.asset(
                      //           'assets/images/adress.svg',
                      //           width: 24,
                      //           height: 24,
                      //           color: Coleur().couleur114521,
                      //         ),
                      //       ),
                      //     ),
                      //     validator: (((value) {
                      //       if (value == null || value.isEmpty) {
                      //         return "Veuillez saisir l'adresse";
                      //       }
                      //       return null;
                      //     }))
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("N° de téléphone *"),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: telephoneExpediteurController,
                        keyboardType: TextInputType.phone,
                        maxLength: 9,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Seuls les chiffres sont autorisés
                        ],
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 8.0),
                              // Adjust the padding as needed
                              child: DropdownButton<String>(
                                value: _selectionnerCodePaysExpediteur,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectionnerCodePaysExpediteur = newValue!;
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
                                    _fetchContactsExpediteur();
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
                            return "Saisir un entier";
                          } else if (!value.startsWith("6") &&
                              _selectionnerCodePaysExpediteur == "+224") {
                            return "Le numéro  doit commencer par 6";
                          } else if (!value.startsWith("7") &&
                              _selectionnerCodePaysExpediteur == "+33") {
                            return "Le numéro doit commencer par 7";
                          } else if (value.length < 9) {
                            return "Le numéro de téléphone est invalide";
                          } else if (value.length > 9) {
                            return "Le numéro de téléphone est invalide";
                          }else if (value.endsWith('.')) {
                            return "Le numéro de téléphone se terminer par un point.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 3),
                      // const Text("Date d'arrivée prévue du colis *"),
                      // const SizedBox(height: 2),
                      // TextFormField(
                      //   controller: InfosEnregistrement.dateController,
                      //   readOnly: true,
                      //   decoration: InputDecoration(
                      //     hintText: DateFormat('dd / MM / yyy HH:mm').format(laDate),
                      //     prefixIcon: MaterialButton(
                      //       child: const Icon(Icons.calendar_month),
                      //       onPressed: () {
                      //         maDate();
                      //       },
                      //     ),
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10)),
                      //     contentPadding: const EdgeInsets.symmetric(
                      //         vertical: 10, horizontal: 5),
                      //   ),
                      //   validator: ((value) {
                      //     if (value == null || value.isEmpty) {
                      //       return "Veuillez saisir le nom et le prénom";
                      //     }
                      //     return null;
                      //   }),
                      // ),
                      const Text("Nom récepteur *"),
                      const SizedBox(
                        height: 2,
                      ),
                      TextFormField(
                        controller: nomRecepteurController,
                        decoration: InputDecoration(
                          hintText: "Nom récepteur",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir le nom et le prénom";
                          }
                          return null;
                        }),
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text("Prénom récepteur *"),
                      // SizedBox(
                      //   height: 2,
                      // ),
                      // TextFormField(
                      //   controller: infosEnregistrement
                      //       .prenomRecepteurController,
                      //   decoration: InputDecoration(
                      //     hintText: "Prénom récepteur",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     contentPadding: EdgeInsets.symmetric(
                      //         vertical: 10, horizontal: 20),
                      //   ),
                      //   validator: ((value) {
                      //     if (value == null || value.isEmpty) {
                      //       return "Veuillez saisir le prénom";
                      //     }
                      //     return null;
                      //   }),
                      // ),
                      const SizedBox(
                        height: 2,
                      ),
                      // Autocomplete<String>(
                      //   optionsBuilder: (TextEditingValue paysTextEditingValue) {
                      //     if (paysTextEditingValue.text.isEmpty) {
                      //       return listePaysDeDestination.cast<String>();
                      //     }
                      //     String searchText = paysTextEditingValue.text.toLowerCase();
                      //          return listePaysDeDestination.where((option) {
                      //          return option.toLowerCase().contains(searchText);
                      //          }).cast<String>();
                      //   },
                      //   onSelected: (String value) {
                      //     setState(() {
                      //       selectedPaysDestinateur = value;
                      //     });
                      //   },
                      //   fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      //     return
                      //     TextFormField(
                      //       controller: controller,
                      //       focusNode: focusNode,
                      //       decoration: InputDecoration(
                      //         hintText: "Adresse",
                      //         prefixIcon: const Icon(Icons.search),
                      //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      //         contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      //       ),
                      //       validator: ((value) {
                      //         if (value == null || value.isEmpty) {
                      //           return "Veuillez saisir l'adresse";
                      //         }
                      //         return null;
                      //       }),
                      //     );
                      //   },
                      // ),
                      // TextFormField(
                      //     controller: infosEnregistrement
                      //         .adresseRecepteurController,
                      //     decoration: InputDecoration(
                      //       hintText: "Adresse",
                      //       border: OutlineInputBorder(
                      //           borderRadius:
                      //           BorderRadius.circular(10)),
                      //       contentPadding: EdgeInsets.symmetric(
                      //           vertical: 10, horizontal: 20),
                      //       suffixIcon: IconButton(
                      //         onPressed: () {
                      //           // openMap(9.5561702, -13.6722476);
                      //         },
                      //         icon: SvgPicture.asset(
                      //           'assets/images/adress.svg',
                      //           width: 24,
                      //           height: 24,
                      //           color: Coleur().couleur114521,
                      //         ),
                      //       ),
                      //     ),
                      //     validator: (((value) {
                      //       if (value == null || value.isEmpty) {
                      //         return "Veuillez saisir l'adresse";
                      //       }
                      //       return null;
                      //     }))),
                      const Text("Adresse *"),
                      const SizedBox(
                        height: 2,
                      ),
                      // DropdownButton<Pays>(
                      //   value: selectionPays,
                      //   onChanged: (Pays? newValue) {
                      //     setState(() {
                      //       selectionPays = newValue;
                      //       nomPays = selectionPays!.nom;
                      //       print(nomPays);
                      //     });
                      //   },
                      //   items: listePays.map((Pays pays) {
                      //     return DropdownMenuItem<Pays>(
                      //       value: pays,
                      //       child: Text(pays.nom),
                      //     );
                      //   }).toList(),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Autocomplete<Pays>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return listePays.where((Pays pays) {
                            return pays.nom
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          }).toList();
                        },
                        onSelected: (Pays pays) {
                          setState(() {
                            fetchCountries();
                            selectionPays = pays;
                            nomPays = pays.nom;
                            // print(nomPays);
                          });
                        },
                        displayStringForOption: (Pays pays) => pays.nom,
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController controller,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: "Adresse",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                            ),
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir l'adresse";
                              }
                              return null;
                            }),
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<Pays> onSelected,
                            Iterable<Pays> options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              child: SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  itemExtent: 35.0,
                                  padding:
                                      const EdgeInsets.only(top: 0, bottom: 0),
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Pays pays = options.elementAt(index);
                                    return GestureDetector(
                                      onTap: () {
                                        onSelected(pays);
                                      },
                                      child: ListTile(
                                        title: Text(pays.nom),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const Text("N° de téléphone *"),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: telephoneRecepteurController,
                        keyboardType: TextInputType.phone,
                        maxLength: 9,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Seuls les chiffres sont autorisés
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 8.0),
                            // Adjust the padding as needed
                            child: DropdownButton<String>(
                              value: _selectionnerCodePaysRecepteur,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectionnerCodePaysRecepteur = newValue!;
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
                                  _fetchContactsRecepteur();
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(16.0, 12.0, 8.0, 12.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir le téléphone";
                          } else if (!RegExp(r'^[0-9]+$')
                              .hasMatch(value.replaceAll(".", ""))) {
                            return "Le numéro de téléphone est invalide";
                          } else if (!value.startsWith("6") &&
                              _selectionnerCodePaysRecepteur == "+224") {
                            return "Le numéro doit commencer par 6";
                          } else if (!value.startsWith("7") &&
                              _selectionnerCodePaysRecepteur == "+33") {
                            return "Le numéro doit commencer par 7";
                          } else if (value.length < 9) {
                            return "Le numéro de téléphone est invalide";
                          } else if (value.length > 9) {
                            return "Le numéro de téléphone est invalide";
                          }
                          return null;
                        },
                      ),
                      // const Text("Numéro de pièce du récepteur *"),
                      // const SizedBox(
                      //   height: 2,
                      // ),
                      // TextFormField(
                      //   // controller: nomExpediteurController,
                      //   decoration: InputDecoration(
                      //     hintText: "Numéro de pièce d'identité ou passeport",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     contentPadding: const EdgeInsets.symmetric(
                      //         vertical: 10, horizontal: 20),
                      //   ),
                      //   // validator: ((value) {
                      //   //   if (value == null || value.isEmpty) {
                      //   //     return "Veuillez saisir le numéro de pièce du récepteur";
                      //   //   }
                      //   //   return null;
                      //   // }),
                      // ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheetFavoris(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width / 1.1,
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  controller: numeroClientRecherche,
                  maxLength: 9,
                  onChanged: (value) {
                    setState(() {
                      query = value;
                      _filterClients(query);
                    });
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      // suffixIcon: Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Container(
                      //       width: 1.0,
                      //       height: 40,
                      //       color: Colors.grey,
                      //       // Couleur de la ligne verticale
                      //       margin: const EdgeInsets.only(left: 8.0),
                      //     ),
                      //     const Icon(Icons.location_on),
                      //   ],
                      // ),
                      hintText: "Entrer le numéro du client",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 12),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  title: Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "N° de téléphone *",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: numeroClientFavoris,
                                          keyboardType: TextInputType.phone,
                                          maxLength: 9,
                                          decoration: InputDecoration(
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0, right: 8.0),
                                                // Adjust the padding as needed
                                                child: DropdownButton<String>(
                                                  value:
                                                      _selectionnerCodePaysFavoris,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _selectionnerCodePaysFavoris =
                                                          newValue!;
                                                    });
                                                  },
                                                  items: codesPays.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
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
                                                    // onTap: () {
                                                    //   _fetchContactsExpediteur();
                                                    // },
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              // contentPadding: EdgeInsets.fromLTRB(
                                              //     16.0, 12.0, 8.0, 12.0),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20)),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Veuillez saisir le téléphone";
                                            } else if (!RegExp(r'^[0-9]+$')
                                                .hasMatch(value.replaceAll(
                                                    ".", ""))) {
                                              return "Le numéro de téléphone est invalide";
                                            } else if (!value.startsWith("6") &&
                                                _selectionnerCodePaysExpediteur ==
                                                    "+224") {
                                              return "Le numéro  doit commencer par 6";
                                            } else if (!value.startsWith("7") &&
                                                _selectionnerCodePaysExpediteur ==
                                                    "+33") {
                                              return "Le numéro doit commencer par 7";
                                            } else if (value.length < 9) {
                                              return "Le numéro de téléphone est invalide";
                                            } else if (value.length > 9) {
                                              return "Le numéro de téléphone est invalide";
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Annuler'),
                                      child: const Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Valider'),
                                      child: InkWell(
                                          onTap: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              Map<String, String> body = {
                                                'idUserConnect':
                                                    listeDonneeConnectionUser[
                                                        'id'],
                                                'msisdnCilent':
                                                    numeroClientFavoris.text,
                                              };
                                              ServiceApi().ajouterClientFavoris(
                                                context: context,
                                                body: body,
                                              );
                                            }
                                          },
                                          child: const Text("Valider")),
                                    ),
                                  ],
                                );
                              });
                            }),
                        child: const Text("Ajouter")),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Coleur().couleur114521),
                      onPressed: () {
                        refreshModalData(setState);
                      },
                      child: const Text(
                        'Actualiser',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite,
                          size: 15,
                        ),
                      ),
                    ),
                    const Text(
                      "Liste des favoris",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                    itemCount: filtrerListeClientFavorisParTelephone.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index <
                          filtrerListeClientFavorisParTelephone.length) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              favori = true;
                              selectedNom =
                                  filtrerListeClientFavorisParTelephone[index]
                                      ['vcNom'];
                              selectedAdresse =
                                  filtrerListeClientFavorisParTelephone[index]
                                      ['vcAdresse'];
                              selectedTelephone =
                                  filtrerListeClientFavorisParTelephone[index]
                                      ['vcMsisdn'];
                              nomExpediteurController.text = selectedNom;
                              selectedPaysExpediteur = selectedAdresse;
                              adresseController.text = selectedAdresse;
                              telephoneExpediteurController.text =
                                  selectedTelephone;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/destination.svg',
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 1,
                                height: 60,
                                color: Coleur().couleur114521,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.7,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Nom :    ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              filtrerListeClientFavorisParTelephone[
                                                  index]['vcNom'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Coleur().couleur114521,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Adresse:   ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              filtrerListeClientFavorisParTelephone[
                                                  index]['vcAdresse'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Coleur().couleur114521,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Téléphone: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              filtrerListeClientFavorisParTelephone[
                                                  index]['vcMsisdn'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Coleur().couleur114521,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.yellow,
                                size: 25,
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Handle the case where the index is out of bounds.
                        return Container();
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  void _showContactBottomSheetExpediteur() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 1.1,
          margin: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: _contacts!.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(_contacts![i].displayName),
              onTap: () async {
                Navigator.pop(context); // Fermer le BottomSheet
                final fullContact =
                    await FlutterContacts.getContact(_contacts![i].id);
                // Mettre à jour le champ de numéro de téléphone
                if (fullContact!.phones.isNotEmpty) {
                  telephoneExpediteurController.text =
                      fullContact.phones.first.number;
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showContactBottomSheetRecepteur() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 1.1,
          margin: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: _contacts!.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(_contacts![i].displayName),
              onTap: () async {
                Navigator.pop(context); // Fermer le BottomSheet
                final fullContact =
                    await FlutterContacts.getContact(_contacts![i].id);
                // Mettre à jour le champ de numéro de téléphone
                if (fullContact!.phones.isNotEmpty) {
                  telephoneRecepteurController.text =
                      fullContact.phones.first.number;
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future _fetchContactsExpediteur() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      // setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
      _showContactBottomSheetExpediteur();
    }
  }

  Future _fetchContactsRecepteur() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      // setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
      _showContactBottomSheetRecepteur();
    }
  }
}
