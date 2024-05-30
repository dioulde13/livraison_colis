import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import '../dashboard/dashboard.dart';
import '../couleur/liste_couleur.dart';
import '../fonctions/button.dart';
import '../fonctions/formater_montant.dart';
import '../fonctions/modals.dart';
import '../fonctions/tableau.dart';
import '../global.dart';
import '../services/api_service.dart';
import 'historique_livraison.dart';

class RechercheColis extends StatefulWidget {
  const RechercheColis({super.key});

  @override
  RechercheColisState createState() {
    return RechercheColisState();
  }
}

class RechercheColisState extends State<RechercheColis> {


  List filtrerListeColisTypeEnvoiEtTelephone = [];

  String query = "";

  void _filterClients(String status) {
    setState(() {
      EasyLoading.show();
      filtrerListeColisTypeEnvoiEtTelephone = listeTotalColisEnregistrer.where((client) {
            bool codeColis = client['vcCodeColis']?.toLowerCase().contains(query.toLowerCase()) ?? false;
            bool modeEnvoiFilter = false;
            if (status == "success") {
              Future.delayed(const Duration(seconds: 1), () {
                EasyLoading.dismiss();
              });
              modeEnvoiFilter = client['statusPaiement']?.startsWith("success") ?? false;
            } else if (status == "4") {
              Future.delayed(const Duration(seconds: 1), () {
                EasyLoading.dismiss();
              });
              modeEnvoiFilter = client['idModePaiement']?.startsWith("4") ?? false;
            }
            Future.delayed(const Duration(seconds: 1), () {
              EasyLoading.dismiss();
            });
            return ((codeColis && (!status.isNotEmpty || modeEnvoiFilter)));
          }).toList();
    });
  }


  void actualiserPage(StateSetter setState) {
    setState(() {
      payerParExpediteur = true;
      payerParRecepteur = false;
      ServiceApi().historiqueColisEnregistrer(
        id: listeDonneeConnectionUser['id'],
        refreshCallback: _refreshPage,
        context: context,
      );
      EasyLoading.show();
      Future.delayed(const Duration(seconds: 5), () {
        EasyLoading.dismiss();
      });
      if (listeTotalColisEnregistrer != null) {
        filtrerListeColisTypeEnvoiEtTelephone = List.from(listeTotalColisEnregistrer);
      }
    });
  }


  final MonModal monModal = MonModal();

  final _formKey = GlobalKey<FormState>();
  TextEditingController numeroDeReference = TextEditingController();

  // Fonction de rappel pour actualiser la page
  void _refreshPage() {
    setState(() {
      refreshing = true;
    });
    setState(() {
      refreshing = false;
    });
  }

  bool payerParExpediteur = true;
  bool payerParRecepteur = false;


  @override
  void initState() {
    super.initState();
    _refreshPage();
    if (listeTotalColisEnregistrer != null) {
      filtrerListeColisTypeEnvoiEtTelephone =
          List.from(listeTotalColisEnregistrer);
    }
    setState(() {
      payerParExpediteur = true;
      payerParRecepteur  = false;
    });
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          refController.text = '';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Coleur().couleurF0EFF8,
          appBar: AppBar(
            backgroundColor: Coleur().couleurF0EFF8,
            bottom:  TabBar(
              tabs: [
                Text("Liste des colis selon le mode de paiement",
                  style: TextStyle(
                      color: Coleur().couleur114521,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),
                ),
                Text('Livraison des colis',
                  style: TextStyle(
                      color: Coleur().couleur114521,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            title: Text("Livraison",
              style: TextStyle(
                  color: Coleur().couleur114521,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AccueilPage()),
                );
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Coleur().couleur114521,
                size: 32,
              ),
            ),
            actions: <Widget>[
              SvgPicture.asset(
                "assets/images/search.svg",
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 18,)
            ],
          ),
          body:  TabBarView(
            children: [
              SingleChildScrollView(
                child:
                Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height / 4.4,
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                              children: [
                                searchSection(),
                                const SizedBox(
                                  height: 15,
                                ),
                                _typeEvoi(),
                              ],
                            )
                    ),
                    rechercherColisLotSection()
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Coleur().couleurWhite,
                  ),
                  child: Form(
                    key: _formKey,
                       child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Alignez les éléments à gauche
                          children: [
                            Text(
                              "Livraison des colis",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            // Espace vertical entre les éléments
                          ],
                        ),
                        const Divider(),
                        const Text("Remplissez le champs vide"),
                        const Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text("Insérer le numéro de référence du colis..."),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: refController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            // labelText: 'Rechercher ...',
                            hintText: 'Saisir le numéro du référence',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez saisir le numéro de ref";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        button(context, () {
                          if (_formKey.currentState!.validate()) {
                            ServiceApi().detailsColis(
                                context: context,
                                refreshCallback: _refreshPage,
                                refColis: refController.text);
                          }
                        },
                            "Livrer un colis reçu", Coleur().couleur114521,
                            Coleur().couleurWhite, 0, 45, 10, 0.5),
                        const SizedBox(height: 16.0),
                        button(context, () {
                          // Future.delayed(const Duration(seconds: 4), () {
                          //
                          // });
                          EasyLoading.show();
                          Future.delayed(const Duration(seconds: 3), () {
                            EasyLoading.dismiss();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    const HistoriqueLivraison()));
                          });
                          ServiceApi().listeHistoriqueColisLivrer(
                              id: listeDonneeConnectionUser['id'],
                              context: context);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => const HistoriqueLivraison(),
                          // ));
                        }, "Historique des colis livrés", Coleur().couleurBF9B38,
                            Coleur().couleurWhite, 0, 40, 10, 0),
                        const SizedBox(height: 16.0),
                        button(context, () {
                          if (_formKey.currentState!.validate()) {
                            ServiceApi().infosColisNonPayer(
                                context: context,
                                refColis: refController.text);
                          }
                        },
                            "Réessayer paiement", Colors.indigo,
                            Coleur().couleurWhite, 0, 45, 10, 0.5),
                      ],
                    ),
                     )
                ),
              ),
            ],
          ),
        ),
      ),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    payerParExpediteur?"La liste des colis payés par l'expéditeur":"La liste des colis à payer lors de la livraison",
                    style: TextStyle(
                        color: Coleur().couleur114521,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
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
              child: ListView.builder(
                itemCount: filtrerListeColisTypeEnvoiEtTelephone.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = filtrerListeColisTypeEnvoiEtTelephone[index];
                  if (payerParExpediteur?item['statusPaiement'] == 'success':item['idModePaiement'] == '4') {
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
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          filtrerListeColisTypeEnvoiEtTelephone[index]['vcCodeColis'] +
                                              " ",
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 11,
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
                                          formatDate(
                                              DateTime.parse(
                                                  filtrerListeColisTypeEnvoiEtTelephone[
                                                  index]['dtCreated']),
                                              [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy,
                                                ' - ',
                                                HH,
                                                ':',
                                                nn
                                              ]),
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
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          filtrerListeColisTypeEnvoiEtTelephone[index]
                                          ['statusPaiement'] ==
                                              'pending'
                                              ? 'En attente'
                                              : filtrerListeColisTypeEnvoiEtTelephone[index]
                                          ['statusPaiement'] ==
                                              'Failed'
                                              ? 'Echec de paiement'
                                              : 'Succès',
                                          style: TextStyle(
                                              color: Coleur().couleur114521,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text(
                                          "Mode de paiement:  ",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          filtrerListeColisTypeEnvoiEtTelephone[
                                          index]
                                          ['idModePaiement'] ==
                                              '1'
                                              ? 'Orange Money'
                                              : filtrerListeColisTypeEnvoiEtTelephone[
                                          index]
                                          ['idModePaiement'] ==
                                              '2'
                                              ? 'Mobile Money'
                                              : filtrerListeColisTypeEnvoiEtTelephone[
                                          index][
                                          'idModePaiement'] ==
                                              '3'
                                              ? 'Espece'
                                              : 'Paiement à la livraison',
                                          style: TextStyle(
                                              color: Coleur().couleur114521,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    statuscolis(index),
                                    Row(
                                      children: [
                                        const Text(
                                          "Montant :    ",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          "${formaterUnMontant(double.tryParse(filtrerListeColisTypeEnvoiEtTelephone[index]['mMontant'] ?? '0')!.toDouble())} ",
                                          style: TextStyle(
                                              color: Coleur().couleur114521,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    // if (_formKey.currentState!.validate()) {
                                      ServiceApi().detailsColis(
                                          context: context,
                                          refreshCallback: _refreshPage,
                                          refColis: numeroDeReference.text == ''? filtrerListeColisTypeEnvoiEtTelephone[index]['vcCodeColis']: numeroDeReference.text
                                      );
                                    // }
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
                },),
            ),
          ],
        ));
  }

  statuscolis(int index) {
    return Row(
      children: [
        const Text(
          "Status colis:   ",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
        ),
        if (filtrerListeColisTypeEnvoiEtTelephone[index]['btBoarded'] == '1' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '0' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btCanceled'] == '0' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '0' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btLost'] == '0')
          Text(
            'Colis embarquer',
            style: TextStyle(
                color: Coleur().couleur114521,
                fontSize: 11,
                fontWeight: FontWeight.bold),
          )
        else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btBoarded'] ==
            '1' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '1' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btLost'] == '0' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btCanceled'] == '0' &&
            filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '0')
          Text(
            'Colis reçu',
            style: TextStyle(
                color: Coleur().couleur114521,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          )
        else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btBoarded'] ==
              '1' &&
              filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '0' &&
              filtrerListeColisTypeEnvoiEtTelephone[index]['btLost'] == '1' &&
              filtrerListeColisTypeEnvoiEtTelephone[index]['btCanceled'] == '0' &&
              filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '0')
            const Text(
              "Colis perdu avant l'embarquement",
              style: TextStyle(
                  color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
            )
          else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btBoarded'] ==
                '1' &&
                filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '1' &&
                filtrerListeColisTypeEnvoiEtTelephone[index]['btLost'] == '1' &&
                filtrerListeColisTypeEnvoiEtTelephone[index]['btCanceled'] == '0' &&
                filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '0')
              const Text(
                "Colis perdu après réception.",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
              )
            else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btBoarded'] ==
                  '1' &&
                  filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '1' &&
                  filtrerListeColisTypeEnvoiEtTelephone[index]['btLost'] == '0' &&
                  filtrerListeColisTypeEnvoiEtTelephone[index]['btCanceled'] == '1' &&
                  filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '0')
                Text(
                  'Colis retourner',
                  style: TextStyle(
                      color: Coleur().couleur114521,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                )
              else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btBoarded'] ==
                    '1' &&
                    filtrerListeColisTypeEnvoiEtTelephone[index]['btReceived'] == '1' &&
                    filtrerListeColisTypeEnvoiEtTelephone[index]['btLost'] == '0' &&
                    filtrerListeColisTypeEnvoiEtTelephone[index]['btCanceled'] == '0' &&
                    filtrerListeColisTypeEnvoiEtTelephone[index]['btDelivred'] == '1')
                  Text(
                    'Colis livrer',
                    style: TextStyle(
                        color: Coleur().couleur114521,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  )
                else if (filtrerListeColisTypeEnvoiEtTelephone[index]['btBoarded'] ==
                      '0')
                    Text(
                      'En attente',
                      style: TextStyle(
                          color: Coleur().couleur114521,
                          fontSize: 11,
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
        controller: numeroDeReference,
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
            hintText: "Entrer le numéro de référence",
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  _filterClients("success");
                  payerParExpediteur = true;
                  payerParRecepteur = false;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: payerParExpediteur
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
                          Text(
                            "liste colis payer par l'expediteur",
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
                  _filterClients("4");
                  payerParExpediteur = false;
                  payerParRecepteur = true;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: payerParRecepteur
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
                          Text(
                            "liste colis payer à la livraison",
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
        tableau(
            "Poids: ",
            "$poids $unite * $quantite = ${double.tryParse(quantite)! * double.tryParse(poids)!} $unite",
            Colors.black),
        tableau("Type d'envoi: ", modeEnvoi, Colors.black),
        tableau(
            "Date & heure: ",
            formatDate(DateTime.parse(dateHeure),
                [dd, '/', mm, '/', yyyy, ' - ', HH, ':', nn])
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
        // buttonConfirmeAbandonner(context, () {
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => const Historique(),
        //   ));
        // }, () {}, "Modifier", "Fermer", Coleur().couleur114521,
        //     Coleur().couleurC19C37, 0.4, 0.4)
      ],
    );
  }

}
