import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../couleur/liste_couleur.dart';
import '../dashboard/dashboard.dart';
import '../dashboard/pied_page.dart';
import '../fonctions/app_bar.dart';
import '../global.dart';
import '../services/api_service.dart';


class Statique extends StatefulWidget {
  const Statique({super.key});

  @override
  StatiqueState createState() {
    return StatiqueState();
  }
}

class StatiqueState extends State<Statique> {
  // DateTime laDate = DateTime.now();
  // TimeOfDay heureSelectionnmeOfDay.now();
  // String heureMunite = "";
  //
  // void maDate() {
  //   TimeOfDay heureActuelle = TimeOfDay.now();
  //   heureMunite = heureActuelle.hour.toString() +":"+ heureActuelle.minute.toString();
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
  //           // Créer une nouvelle instance de DateTime avec la date sélectionnée et l'heure sélectionnée
  //           DateTime selectedDateTime = DateTime(
  //             selectedDate.year,
  //             selectedDate.month,
  //             selectedDate.day,
  //             selectedTime.hour,
  //             selectedTime.minute,
  //           );
  //
  //           setState(() {
  //             laDate = selectedDateTime;
  //             heureSelectionnee = selectedTime;
  //           });
  //         }
  //       });
  //     }
  //   });
  // }



  Future<void> dateDebutFonction() async{
    DateTime? pecked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050)
    );
    if(pecked != null){
      setState(() {
        EasyLoading.show();
        Future.delayed(const Duration(seconds: 4), () {
          EasyLoading.dismiss();
        });
        String formattedDate = DateFormat('dd-MM-yyy').format(pecked);
        dateDebutStatistique.text = formattedDate;
        ServiceApi().rechercheStatistique(
          id: listeDonneeConnectionUser['id'],
          adresseDestination: selectedCountry,
          dateDebut: dateDebutStatistique.text.toString(),
          dateFin: dateFinStatistique.text.toString(),
          refreshCallback: _refreshPage,
          typeEnvoi: avionStatistique ? "Avion" : bateauStatistique ? "Bateau" : "Voiture",
          context: context,
        );
      });
    }
  }


  Future<void> dateFinFonction() async{
    DateTime? pecked =
    await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050)
    );
    if( pecked != null){
      setState(() {
        EasyLoading.show();
        Future.delayed(const Duration(seconds: 4), () {
          EasyLoading.dismiss();
        });
        String formattedDate = DateFormat('dd-MM-yyy').format(pecked);
        dateFinStatistique.text = formattedDate;
        ServiceApi().rechercheStatistique(
          id: listeDonneeConnectionUser['id'],
          adresseDestination: selectedCountry,
          dateDebut: dateDebutStatistique.text.toString(),
          dateFin: dateFinStatistique.text.toString(),
          refreshCallback: _refreshPage,
          typeEnvoi: avionStatistique ? "Avion" : bateauStatistique ? "Bateau" : "Voiture",
          context: context,
        );
      });
    }
  }

  // TimeOfDay heureSelectionneeDebut = TimeOfDay.now();
  // String heureMuniteDebut = "";
  //
  // void dateDebutFonction() {
  //   TimeOfDay heureActuelle = TimeOfDay.now();
  //   heureMuniteDebut =
  //       heureActuelle.hour.toString() + ":" + heureActuelle.minute.toString();
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
  //           // Créer une nouvelle instance de DateTime avec la date sélectionnée et l'heure sélectionnée
  //           DateTime selectedDateTime = DateTime(
  //             selectedDate.year,
  //             selectedDate.month,
  //             selectedDate.day,
  //             selectedTime.hour,
  //             selectedTime.minute,
  //           );
  //           setState(() {
  //             redirectSTatistique = true;
  //             dateTimeDebut = selectedDateTime;
  //             heureSelectionneeDebut = selectedTime;
  //             ServiceApi().rechercheStatistique(
  //               id: listeDonneeConnectionUser['id'],
  //               adresseDestination: selectedValue,
  //               dateDebut: dateTimeDebut.toString(),
  //               dateFin: dateTimeFin.toString(),
  //               refreshCallback: _refreshPage,
  //               typeEnvoi: avionStatistique?"Avion":bateauStatistique?"Bateau":"Voiture",
  //               context: context,
  //             );
  //           });
  //         }
  //       });
  //     }
  //   });
  //
  // }




  // TimeOfDay heureSelectionneeFin = TimeOfDay.now();
  //
  // void dateFinFonction() {
  //   TimeOfDay heureActuelle = TimeOfDay.now();
  //
  //   showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2040),
  //   ).then((selectedDate) {
  //     if (selectedDate != null) {
  //       // Maintenant, vous avez la date sélectionnée sans l'heure
  //       DateTime selectedDateTime = DateTime(
  //         selectedDate.year,
  //         selectedDate.month,
  //         selectedDate.day,
  //         heureActuelle.hour,
  //         heureActuelle.minute,
  //       );
  //
  //       setState(() {
  //         redirectSTatistique = true;
  //         dateTimeFin = selectedDateTime;
  //         heureSelectionneeFin = heureActuelle;
  //         ServiceApi().rechercheStatistique(
  //           id: listeDonneeConnectionUser['id'],
  //           adresseDestination: selectedValue,
  //           dateDebut: dateTimeDebut.toString(),
  //           dateFin: dateTimeFin.toString(),
  //           refreshCallback: _refreshPage,
  //           typeEnvoi: avionStatistique ? "Avion" : bateauStatistique ? "Bateau" : "Voiture",
  //           context: context,
  //         );
  //       });
  //     }
  //   });
  // }




  void _filtrerParTypeEnvoi(String status) {
    setState(() {
      EasyLoading.show();
        dateDebutStatistique.text = '';
        dateFinStatistique.text = '';
      if (status == "avion") {
        Future.delayed(const Duration(seconds: 3), () {
          EasyLoading.dismiss();
        });
        ServiceApi().rechercheStatistique(
            id: listeDonneeConnectionUser['id'],
            adresseDestination: selectedCountry,
            dateDebut: dateDebutStatistique.text,
            dateFin: dateFinStatistique.text,
            refreshCallback: _refreshPage,
            typeEnvoi: "Avion",
            context: context);
      } else if (status == "bateau") {
        Future.delayed(const Duration(seconds: 3), () {
          EasyLoading.dismiss();
        });
        ServiceApi().rechercheStatistique(
            id: listeDonneeConnectionUser['id'],
            adresseDestination: selectedCountry,
            dateDebut: dateDebutStatistique.text,
            dateFin: dateFinStatistique.text,
            refreshCallback: _refreshPage,
            typeEnvoi: "Bateau",
            context: context);
      } else if (status == "voiture") {
        Future.delayed(const Duration(seconds: 3), () {
          EasyLoading.dismiss();
        });
        ServiceApi().rechercheStatistique(
            id: listeDonneeConnectionUser['id'],
            adresseDestination: selectedCountry,
            dateDebut: dateDebutStatistique.text,
            dateFin: dateFinStatistique.text,
            refreshCallback: _refreshPage,
            typeEnvoi: "Voiture",
            context: context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dateDebutStatistique.clear();
      dateFinStatistique.clear();
      selectedCountry = '';
      setState(() {
        avionStatistique = true;
        bateauStatistique = false;
        voitureStatistique = false;
      });
    });
  }


  void searchCountry(String selectionnerCountry) {
    setState(() {
      EasyLoading.show();
      Future.delayed(const Duration(seconds: 4), () {
        EasyLoading.dismiss();
      });
      ServiceApi().rechercheStatistique(
        id: listeDonneeConnectionUser['id'],
        adresseDestination: selectionnerCountry.toString(),
        dateDebut: dateDebutStatistique.text.toString(),
        dateFin: dateFinStatistique.text.toString(),
        refreshCallback: _refreshPage,
        typeEnvoi: avionStatistique?"Avion":bateauStatistique?"Bateau":"Voiture",
        context: context,
      );
    });
  }

  // Fonction de rappel pour actualiser la page
  void _refreshPage() {
    setState(() {
      refreshing = true;
    });
    setState(() {
      refreshing = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Coleur().couleurF0EFF8,
        appBar: entePage(
            context,
            const AccueilPage(),
            "Statistique",
            Coleur().couleur114521,
            Coleur().couleur114521,
            Coleur().couleur114521,
            "assets/images/statistque.svg",
            Coleur().couleurF0EFF8),
        body:
        refreshing
            ? const Center(
          child: CircularProgressIndicator(),
        )
            :
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Statistique logistique.....",
                      style: TextStyle(color: Coleur().couleur114521),
                    ),
                    SvgPicture.asset(
                      "assets/images/istatistique.svg",
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
                const Divider(),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue paysTextEditingValue) {
                    if (paysTextEditingValue.text.isEmpty) {
                      return listPays;
                    }
                    String searchText = paysTextEditingValue.text.toLowerCase();
                    return listPays.where((String option) {
                      return option.toLowerCase().contains(searchText);
                    });
                  },
                  onSelected: (String value) {
                    setState(() {
                        selectedCountry = value;
                        searchCountry(value);
                    });
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: "Adresse de destination",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                const SizedBox(
                  height: 4,
                ),
                // DropdownMenu<String>(
                //   enableFilter: true,
                //   requestFocusOnTap: true,
                //   leadingIcon: const Icon(Icons.search),
                //   label: const Text('Selectionnez un pays'),
                //   onSelected: (String? country) {
                //     setState(() {
                //       selectedCountry = country;
                //       if (country != null) {
                //         searchCountry(country);
                //       }
                //     });
                //   },
                //   dropdownMenuEntries: listPays.map<DropdownMenuEntry<String>>((String country) {
                //     return DropdownMenuEntry<String>(
                //       value: country,
                //       label: country,
                //     );
                //   }).toList(),
                // ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "Date & heure *",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 3,
                ),
                TextFormField(
                  controller: dateDebutStatistique,
                  readOnly: true,
                  decoration: InputDecoration(
                    // hintText: DateFormat('dd / MM / yyy').format(dateDebutStatistique),
                    prefixIcon: MaterialButton(
                      child: const Icon(Icons.calendar_month),
                      onPressed: () {
                        dateDebutFonction();
                      },
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "Date fin *",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 3,
                ),
                TextFormField(
                  controller: dateFinStatistique,
                  readOnly: true,
                  decoration: InputDecoration(
                    // hintText: DateFormat('dd / MM / yyy').format(infosEnregistrement.dateFinStatistique as DateTime),
                    prefixIcon: MaterialButton(
                      child: const Icon(Icons.calendar_month),
                      onPressed: () {
                        dateFinFonction();
                      },
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Statistique par Mois",
                  style: TextStyle(color: Coleur().couleur114521),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                _typeEvoi(),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Statistique par Mois",
                  style: TextStyle(color: Coleur().couleur114521),
                ),
                const Divider(),
                const SizedBox(
                  height: 15,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      texteNombre(
                          "Total enregistrement *",
                      listNombreTotal != null? listNombreTotal['totalEnregistrement'].toString():"",
                          40,
                          MediaQuery.of(context).size.width / 2.3),
                      const SizedBox(
                        width: 5,
                      ),
                      texteNombre(
                          "Total livré",
                          listNombreTotal != null?listNombreTotal['totalLivre'].toString():"",
                          40,
                          MediaQuery.of(context).size.width / 2.4
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      texteNombre(
                          "Documents *",
                          listNombreTotal != null? listNombreTotal['nombreDocument'].toString():"",
                          40,
                          MediaQuery.of(context).size.width / 3.7),
                      const SizedBox(
                        width: 3,
                      ),
                      texteNombre(
                          "Colis *",
                          listNombreTotal != null? listNombreTotal['nombreColis'].toString():"",
                          40,
                          MediaQuery.of(context).size.width / 3.5),
                      const SizedBox(
                        width: 3,
                      ),
                      texteNombre(
                          "Marchandise *",
                          listNombreTotal != null? listNombreTotal['nombreMarchandise'].toString():"",
                          40,
                          MediaQuery.of(context).size.width / 3.5)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar:
        footer(context)
    );
  }

  Widget _typeEvoi() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _filtrerParTypeEnvoi("avion");
                    avionStatistique = true;
                    bateauStatistique = false;
                    voitureStatistique = false;
                  });
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width / 3.7,
                  decoration: BoxDecoration(
                    color: avionStatistique
                        ? Coleur().couleurE0E0E0
                        : Coleur().couleurWhite,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      SvgPicture.asset(
                        "assets/images/avion.svg",
                        height: 25,
                        // color: Coleur().couleur114521,
                      ),
                      const SizedBox(width: 5),
                      Text(
                          "Avion",
                          style: TextStyle(
                              fontSize: 12,
                              color: Coleur().couleur114521,
                              fontWeight: FontWeight.bold),
                        ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _filtrerParTypeEnvoi("bateau");
                    avionStatistique = false;
                    bateauStatistique = true;
                    voitureStatistique = false;
                  });
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width / 3.3,
                  decoration: BoxDecoration(
                    color: bateauStatistique
                        ? Coleur().couleurE0E0E0
                        : Coleur().couleurWhite,
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      SvgPicture.asset(
                        "assets/images/bateau.svg",
                        height: 16,
                        // color: Coleur().couleur114521,
                      ),
                      const SizedBox(width: 5),
                     Text(
                          "Bateau",
                          style: TextStyle(
                              fontSize: 12,
                              color: Coleur().couleur114521,
                              fontWeight: FontWeight.bold),
                        ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _filtrerParTypeEnvoi("voiture");
                    avionStatistique = false;
                    bateauStatistique = false;
                    voitureStatistique = true;
                  });
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width / 3.5,
                  decoration: BoxDecoration(
                    color: voitureStatistique
                        ? Coleur().couleurE0E0E0
                        : Coleur().couleurWhite,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      SvgPicture.asset(
                        "assets/images/voiture.svg",
                        height: 25,
                        // color: Coleur().couleur114521,
                      ),
                      const SizedBox(width: 5),
                       Text(
                          "Voiture",
                          style: TextStyle(
                              fontSize: 12,
                              color: Coleur().couleur114521,
                              fontWeight: FontWeight.bold),
                        ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget texteNombre(String texte, String nombre, double hauteurContainer,
      double largeurContainer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(texte),
        const SizedBox(
          height: 2,
        ),
        Container(
          padding: const EdgeInsets.only(top: 3, left: 5),
          height: hauteurContainer,
          // Utilisez le paramètre pour définir la hauteur
          width: largeurContainer,
          decoration: BoxDecoration(
            color: Coleur().couleurC4C4C7,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            nombre,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            // textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
