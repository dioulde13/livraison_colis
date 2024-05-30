import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:date_format/date_format.dart';
import 'package:livraisons_colis/pages/livraisons/rechercher_colis.dart';

import '../couleur/liste_couleur.dart';
import '../dashboard/pied_page.dart';
import '../fonctions/app_bar.dart';
import '../fonctions/button.dart';
import '../fonctions/formater_montant.dart';
import '../fonctions/modals.dart';
import '../fonctions/tableau.dart';
import '../global.dart';
import '../services/api_service.dart';

class HistoriqueLivraison extends StatefulWidget {
  const HistoriqueLivraison({super.key});

  @override
  HistoriqueLivraisonState createState() {
    return HistoriqueLivraisonState();
  }
}

class HistoriqueLivraisonState extends State<HistoriqueLivraison> {
  final MonModal monModal = MonModal();

  bool avionHistoriqueLivrer = true;
  bool bateauHistoriqueLivrer = false;
  bool voitureHistoriqueLivrer = false;

  List filtrerListeColisTypeEnvoiEtTelephone = [];

  @override
  void initState() {
    super.initState();
    ServiceApi().listeHistoriqueColisLivrer(id: listeDonneeConnectionUser['id'], context: context);
    _refreshPage();
    if (listeTotalColisLivrer != null) {
      filtrerListeColisTypeEnvoiEtTelephone = List.from(listeTotalColisLivrer);
    }
    setState(() {
      avionHistoriqueLivrer = false;
      bateauHistoriqueLivrer = false;
      voitureHistoriqueLivrer = false;
    });
  }

  String query = "";

  void _filterClients(String status) {
    setState(() {
      EasyLoading.show();
      filtrerListeColisTypeEnvoiEtTelephone =
          listeTotalColisLivrer.where((client) {bool matchesPhone = client['vcMsisdnSender']?.toLowerCase().contains(query.toLowerCase()) ?? false;
          bool codeColis = client['vcCodeColis']
              ?.toLowerCase()
              .contains(query.toLowerCase()) ??
              false;
          bool modeEnvoiFilter = false;
          if (status == "Avion") {
            Future.delayed(const Duration(seconds: 1), () {
              EasyLoading.dismiss();
            });
            modeEnvoiFilter =
                client['vcModeEnvois']?.startsWith("Avion") ?? false;
          } else if (status == "Bateau") {
            Future.delayed(const Duration(seconds: 1), () {
              EasyLoading.dismiss();
            });
            modeEnvoiFilter =
                client['vcModeEnvois']?.startsWith("Bateau") ?? false;
          } else if (status == "Voiture") {
            Future.delayed(const Duration(seconds: 1), () {
              EasyLoading.dismiss();
            });
            modeEnvoiFilter =
                client['vcModeEnvois']?.startsWith("Voiture") ?? false;
          }
          Future.delayed(const Duration(seconds: 1), () {
            EasyLoading.dismiss();
          });
          return ((matchesPhone && (!status.isNotEmpty || modeEnvoiFilter)) ||
              (codeColis && (!status.isNotEmpty || modeEnvoiFilter)));
          }).toList();
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

  void actualiserPage(StateSetter setState) {
    setState(() {
      ServiceApi().listeHistoriqueColisLivrer(
        id: listeDonneeConnectionUser['id'],
        refreshCallback: _refreshPage,
        context: context,
      );
      EasyLoading.show();
      Future.delayed(const Duration(seconds: 6), () {
        EasyLoading.dismiss();
      });
      if (listeTotalColisLivrer != null) {
        filtrerListeColisTypeEnvoiEtTelephone = List.from(listeTotalColisLivrer);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF0EFF8),
        appBar: entePage(
            context,
            const RechercheColis(),
            "Historique des colis livrés",
            Coleur().couleur114521,
            Coleur().couleur114521,
            Coleur().couleur114521,
            "assets/images/historique.svg",
            Coleur().couleurF0EFF8),
        body:
        refreshing
            ? const Center(
          child: CircularProgressIndicator(),
        )
            :
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height / 4.2,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      searchSection(),
                      const SizedBox(
                        height: 15,
                      ),
                      _typeEvoi()],
                  )),
              rechercherColisLotSection()
            ],
          ),
        ),
        bottomNavigationBar:
        footer(context)
    );
  }

  rechercherColisLotSection() {
    return Container(
        height: MediaQuery.of(context).size.height / 1.7,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
            color: Coleur().couleurWhite,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Liste des colis qui ont été livrés",
                  style: TextStyle(
                      color: Coleur().couleur114521,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Coleur().couleur114521),
                  onPressed: () {
                    actualiserPage(setState);
                  },
                  child: const Text(
                    'Actualiser',
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: filtrerListeColisTypeEnvoiEtTelephone.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index < filtrerListeColisTypeEnvoiEtTelephone.length) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            'assets/images/colis.svg',
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
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Ref:    ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['vcCodeColis'] +
                                              " ",
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Téléphone :    ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['vcMsisdnSender'] +
                                              " ",
                                          style: TextStyle(
                                              color: Coleur().couleur114521,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Date & heure : ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          formatDate(DateTime.parse(filtrerListeColisTypeEnvoiEtTelephone[index]['dtCreated']), [dd, '/', mm, '/', yyyy, ' - ', HH, ':', nn]),
                                          style: TextStyle(
                                              color: Coleur().couleur114521,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text(
                                          "Status paiement:  ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          filtrerListeColisTypeEnvoiEtTelephone[index]['statusPaiement'] == 'pending' ?
                                          'En attente' : filtrerListeColisTypeEnvoiEtTelephone[index]['statusPaiement'] == 'Failed'?
                                          'Echec de paiement':
                                          'Succès',
                                          style: TextStyle(
                                              color: Coleur().couleur114521,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    statuscolis(index),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    monModal.showBottomSheet(
                                        context,
                                        contenuModal(
                                          nomExpediteur:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['vcNameSender'],
                                          adresseExpediteur:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['vcAdresseSender'],
                                          msisdnExpediteur:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['vcMsisdnSender'],
                                          nomRecepteur:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['vcNameReceiver'],
                                          adresseRecepteur:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['vcAdresseReceiver'],
                                          msisdnRecepteur:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['vcMsisdnReceiver'],
                                          modeEnvoi:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['vcModeEnvois'],
                                          typeColis:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['typeColis'],
                                          dateHeure:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['dtCreated'],
                                          montant:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['mMontant'],
                                          poids:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['iPoid'],
                                          unite: filtrerListeColisTypeEnvoiEtTelephone[index]['vcUnite'] ?? '',
                                          quantite:
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]['iQuantite'],
                                        ),
                                        showFermerButton: false);
                                  },
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.yellow,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              ),
            ),
          ],
        ));
  }


  statuscolis(int index) {
    return Row(
      children: [
        const Text(
          "Status colis:   ",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300),
        ),
        if (filtrerListeColisTypeEnvoiEtTelephone[index]['btBoarded'] == '1' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '0' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '0')
          Text('Colis embarquer',
            style: TextStyle(
                color: Coleur().couleur114521,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          )
        else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '1' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btLost'] == '0' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btCanceled'] == '0' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '0')
          Text('Colis reçu',
            style: TextStyle(
                color: Coleur().couleur114521,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          )
        else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '1' &&
              filtrerListeColisTypeEnvoiEtTelephone[index]['btLost'] == '1' &&
              filtrerListeColisTypeEnvoiEtTelephone[index]['btCanceled'] == '0' &&
              filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '0')
            Text('Colis perdu',
              style: TextStyle(
                  color: Coleur().couleur114521,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            )
          else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '1' &&
                filtrerListeColisTypeEnvoiEtTelephone[index]['btLost'] == '1' &&
                filtrerListeColisTypeEnvoiEtTelephone[index]['btCanceled'] == '1' &&
                filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '0')
              Text('Opération annuler',
                style: TextStyle(
                    color: Coleur().couleur114521,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              )
            else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '1' &&
                  filtrerListeColisTypeEnvoiEtTelephone[index]['btLost'] == '0' &&
                  filtrerListeColisTypeEnvoiEtTelephone[index]['btCanceled'] == '0' &&
                  filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '1')
                Text('Colis livrer',
                  style: TextStyle(
                      color: Coleur().couleur114521,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                )
              else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btBoarded'] == '0')
                  Text('En attente',
                    style: TextStyle(
                        color: Coleur().couleur114521,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
      ],
    );
  }


  searchSection() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
        left: 30,
        right: 30,
      ),
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Coleur().couleur134D25,
          borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        maxLength: 9,
        onChanged: (value) {
          setState(() {
            query = value;
            _filterClients("");
          });
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 1.0,
                  height: 40,
                  color: Colors.grey, // Couleur de la ligne verticale
                  margin: const EdgeInsets.only(left: 8.0),
                ),
                const Icon(Icons.location_on),
              ],
            ),
            hintText: "Saisir le ref ou téléphone",
            contentPadding: const EdgeInsets.symmetric(
              vertical: 1.0,
            ),
            filled: true,
            fillColor: Colors.white,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
      ),
    );
  }


  Widget _typeEvoi() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _filterClients("Avion");
                    avionHistoriqueLivrer = true;
                    bateauHistoriqueLivrer = false;
                    voitureHistoriqueLivrer = false;
                  });
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: avionHistoriqueLivrer
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
                    _filterClients("Bateau");
                    avionHistoriqueLivrer = false;
                    bateauHistoriqueLivrer = true;
                    voitureHistoriqueLivrer = false;
                  });
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: bateauHistoriqueLivrer
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
                    _filterClients("Voiture");
                    avionHistoriqueLivrer = false;
                    bateauHistoriqueLivrer = false;
                    voitureHistoriqueLivrer = true;
                  });
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: voitureHistoriqueLivrer
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
      ),
    );
  }


  texteIcon(String texte, Color color, String imagePath) {
    return Container(
      height: 30,
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: SvgPicture.asset(
              imagePath,
              width: 25,
              height: 25,
            ),
            onPressed: () {
              // Action lorsque l'icône est cliquée
            },
          ),
          Text(
            texte,
            style: TextStyle(fontSize: 12, color: Coleur().couleur114521),
          )
        ],
      ),
    );
  }

  Widget contenuModal({
    // required String reference,
    required String nomExpediteur,
    required String adresseExpediteur,
    required String msisdnExpediteur,
    required String nomRecepteur,
    required String adresseRecepteur,
    required String msisdnRecepteur,
    required String modeEnvoi,
    required String typeColis,
    required String dateHeure,
    required String montant,
    required String poids,
    required String unite,
    required String quantite,
  }) {
    return Column(
      children: [
        const Text(
          "Récapitulatif du colis:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Divider(),
        tableau("Livraison Express: ", "Conakry", Colors.black),
        const Divider(),
        tableau("Catégorie: ", typeColis, Colors.black),
        tableau("Poids: ", "$poids $unite * $quantite = ${double.tryParse(quantite)! * double.tryParse(poids)!} $unite", Colors.black),
        tableau("Type d'envoi: ", modeEnvoi, Colors.black),
        tableau("Date & heure: ", formatDate(DateTime.parse(dateHeure), [dd, '/', mm, '/', yyyy, ' - ', HH, ':', nn])
            // DateFormat('dd/MM/yyyy  HH:mm').format(DateTime.parse(dateHeure))
            ,
            Colors.black),
        const Divider(),
        tableau("Expéditeur: ", nomExpediteur, Colors.black),
        tableau("Adresse: ", adresseExpediteur, Colors.black),
        tableau("Telephone: ", msisdnExpediteur, Colors.black),
        const Divider(),
        tableau("Recepteur: ", nomRecepteur, Colors.black),
        tableau("Adresse: ", adresseRecepteur, Colors.black),
        tableau("Telephone: ", msisdnRecepteur, Colors.black),
        const Divider(),
        tableau(
            "Prix de la livraison: ",
            formaterUnMontant(double.tryParse(montant)!.toDouble()),
            Colors.black),
        tableau("Frais 0%: ", "0 GNF", Colors.black),
        const Divider(),
        tableau(
            "Vous payez: ",
            formaterUnMontant(double.tryParse(montant)!.toDouble()),
            Coleur().couleur114521),
        const Divider(),
        const SizedBox(
          height: 20,
        ),
        button(context, () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const HistoriqueLivraison(),
          ));
        }, "Fermer", Coleur().couleur114521, Coleur().couleurWhite, 2, 48, 70, 0.5)
        // buttonConfirmeAbandonner(context, () {
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => const HistoriqueLivraison(),
        //   ));
        // }, () {}, "Modifier", "Fermer", Coleur().couleur114521,
        //     Coleur().couleurC19C37, 0.4, 0.4)
      ],
    );
  }
}
