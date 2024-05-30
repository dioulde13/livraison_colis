import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import '../couleur/liste_couleur.dart';
import '../dashboard/dashboard.dart';
import '../enregistrement/paiement_livraison.dart';
import '../fonctions/button.dart';
import '../fonctions/button_confirmer_abandonner.dart';
import '../fonctions/formater_montant.dart';
import '../fonctions/modals.dart';
import '../fonctions/tableau.dart';
import '../global.dart';
import 'package:image/image.dart' as img;
import '../livraisons/rechercher_colis.dart';
import 'dart:typed_data';

typedef RefreshCallback = void Function();
final MonModal monModal = MonModal();


class ServiceApi {
  //Fonction pour se connecter
  connexion(
        {required String numero,
        required String password,
        required BuildContext context
        }) async {
    try {
      EasyLoading.show();
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=authAgent&msisdn=$numero&password=$password"));
      // print('************************');
      var jsonData = json.decode(response.body)['data'];
      listeDonneeConnectionUser = jsonData;
      var jsonStatus = json.decode(response.body)['status'];
      // print(jsonStatus);
      var jsonMessage = json.decode(response.body)['message'];
      //verifier le type d'une variable
      // print(response.statusCode.runtimeType);
      if (jsonStatus == 200) {
        // ignore: use_build_context_synchronously
        montantTotalPayer(
            id: listeDonneeConnectionUser['id'],
            context: context
        );
        // ignore: use_build_context_synchronously
        listeDesPaysDestinateur(context: context);
        // ignore: use_build_context_synchronously
        rechercheStatistique(
            id: listeDonneeConnectionUser['id'],
            adresseDestination: '',
            dateDebut: '',
            dateFin: '',
            typeEnvoi: "Avion",
            context: context);
        // ignore: use_build_context_synchronously
        listeCLientFavoris(
            id: listeDonneeConnectionUser['id'],
            context: context
        );
        // ignore: use_build_context_synchronously
        historiqueColisEnregistrer(
            id: listeDonneeConnectionUser['id'],
            refreshCallback: refreshing,
            context: context
        );
        // Future.delayed(const Duration(seconds: 4), () {
          EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AccueilPage()));
        // });
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    jsonMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red,
                ),
                const Text(
                  "Erreur de connexion avec le serveur",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Réessayez'),
                  child: const Text(
                    'Réessayez',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  //Fonction pour modifier le mot de passe
  modifierMotPasse(
      {
        required String encien,
        required String nouveau,
        required String id,
        required BuildContext context}) async {
    try {
      EasyLoading.show();
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=updatePassword&idUsers=$id&password=$nouveau&ancienPassword=$encien"));
      var jsonStatus = json.decode(response.body)['status'];
      var jsonMessage = json.decode(response.body)['message'];
      if (jsonStatus == 200) {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.green,
                  ),
                  Text(
                    jsonMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        );
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    jsonMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red,
                ),
                const Text(
                  "Erreur de connexion avec le serveur",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Réessayez'),
                  child: const Text(
                    'Réessayez',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  //Fonction pour modifier le profil
  modifierProfil(
      {required String nom,
        required String prenom,
        required String numero,
        required String email,
        required String id,
        required BuildContext context}) async {
    try {
      EasyLoading.show();
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=updateInfoUser&idUsers=$id&nom=$nom&prenom=$prenom&msisdn=$numero&email=$email"));
      var jsonStatus = json.decode(response.body)['status'];
      var jsonMessage = json.decode(response.body)['message'];
      // print(jsonStatus);
      if (jsonStatus == 200) {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.green,
                  ),
                  Text(
                    jsonMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        );
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    jsonMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red,
                ),
                const Text(
                  "Erreur de connexion avec le serveur",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Réessayez'),
                  child: const Text(
                    'Réessayez',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }


  Widget contenuModalDetailColisEnregistrer(BuildContext context) {
    EasyLoading.dismiss();
    return Column(
      children: [
        const Text(
          "Récapitulatif du colis:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Divider(),
        tableau("Livraison Express: ", "Conakry", Colors.black),
        const Divider(),
        tableau("Ref : ", dernierElementEnregistrer['vcCodeColis'], Colors.black),
        tableau("Catégorie: ", dernierElementEnregistrer['typeColis'], Colors.black),
        tableau("Poids: ", '${dernierElementEnregistrer['iPoid']} '
            '${
            dernierElementEnregistrer['vcUnite'] ?? ''
        } * '
            '${dernierElementEnregistrer['iQuantite']} = ${((double.tryParse(dernierElementEnregistrer['iQuantite'])! * double.tryParse(dernierElementEnregistrer['iPoid'])!).toString()).replaceAll('.0', '')} '
            '${
            dernierElementEnregistrer['vcUnite'] ?? ''
        }', Colors.black),
        tableau("Type d'envoi: ", dernierElementEnregistrer['vcModeEnvois'], Colors.black),
        tableau("Date & heure: ", formatDate(DateTime.parse(dernierElementEnregistrer['dtCreated']), [dd, '/', mm, '/', yyyy, ' - ', HH, ':', nn]), Colors.black),
        const Divider(),
        tableau("Expéditeur: ", dernierElementEnregistrer['vcNameSender'], Colors.black),
        tableau("Adresse: ", dernierElementEnregistrer['vcAdresseSender'], Colors.black),
        tableau("Téléphone: ", dernierElementEnregistrer['vcMsisdnSender'], Colors.black),
        const Divider(),
        tableau("Récepteur: ", dernierElementEnregistrer['vcNameReceiver'], Colors.black),
        tableau("Kaloum: ", dernierElementEnregistrer['vcAdresseReceiver'], Colors.black),
        tableau("Téléphone: ", dernierElementEnregistrer['vcMsisdnReceiver'], Colors.black),
        const Divider(),
        tableau("Prix de la livraison: ", formaterUnMontant(double.tryParse(dernierElementEnregistrer['mMontant'])!.toDouble()), Colors.black),
        tableau("Status paiement: ",
            dernierElementEnregistrer['statusPaiement'] == 'Failed' ?
            'Echec de paiement':
            dernierElementEnregistrer['statusPaiement'] == 'pending'?
            'En attente': 'Payer',
            Colors.black
        ),
        tableau("Mode de paiement: ",
            dernierElementEnregistrer['idModePaiement'] == '4' ?
            'Paiement à la livraison':
            dernierElementEnregistrer['idModePaiement'] == '1'?
            'Orange Money':
            dernierElementEnregistrer['idModePaiement'] == '2'?'Mobile money':'Espèce',
            Colors.black
        ),
        tableau("Status colis: ",
            ((dernierElementEnregistrer['btBoarded'] == '1' && dernierElementEnregistrer['btReceived'] == '0' && dernierElementEnregistrer['btDelivred'] == '0'))?
            "Colis embarquer":
            ((dernierElementEnregistrer['btReceived'] == '1' && dernierElementEnregistrer['btLost'] == '0' && dernierElementEnregistrer['btCanceled'] == '0' && dernierElementEnregistrer['btDelivred'] == '0'))?
            "Colis reçu":
            ((dernierElementEnregistrer['btReceived'] == '1' && dernierElementEnregistrer['btLost'] == '1' && dernierElementEnregistrer['btCanceled'] == '0' && dernierElementEnregistrer['btDelivred'] == '0'))?
            "Colis perdu":
            ((dernierElementEnregistrer['btReceived'] == '1' && dernierElementEnregistrer['btLost'] == '1' && dernierElementEnregistrer['btCanceled'] == '1' && dernierElementEnregistrer['btDelivred'] == '0'))?
            "Opération annuler":
            ((dernierElementEnregistrer['btReceived'] == '1' && dernierElementEnregistrer['btLost'] == '0' && dernierElementEnregistrer['btCanceled'] == '0' && dernierElementEnregistrer['btDelivred'] == '1'))?
            "Colis livrer": "En attente", Colors.black),
        const Divider(),
        button(context, () {
          historiqueColisEnregistrer(id: listeDonneeConnectionUser['id'], context: context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>  const AccueilPage(),
          ));
        }, "Fermer", Coleur().couleur114521, Coleur().couleurWhite, 2, 48, 70, 0.5)
      ],
    );
  }

  //Fonction pour enregistrer un colis
  Future enregistrerColis(
      {
        required BuildContext context,
        required Map<String, String> body,
        required var imagePath
      }
      ) async {
    try {
      // EasyLoading.show();
      // print('JJJ******* je suis ici');
      final String url = '$baseUrl/2023@!&task=addClientColis';
      Map<String, String> headers = {
        'Accept': "Application/json",
      };
      // print("object");
      // Charger l'image
      final List<int> bytes = await imagePath.readAsBytes();
      img.Image selectedImage = img.decodeImage(Uint8List.fromList(bytes))!;
      // Compresser l'image
      final img.Image compressedImage = img.copyResize(selectedImage, width: 80, height: 80);
      // print('Taille de l\'image compressée : ${compressedImage.width} pixels de largeur x ${compressedImage.height} pixels de hauteur');
      // Convertir l'image compressée en bytes
      final Uint8List compressedBytes = Uint8List.fromList(img.encodePng(compressedImage));
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll(body)
        ..headers.addAll(headers)
        ..files.add(http.MultipartFile.fromBytes('photoColis', compressedBytes, filename: 'photoColis.png'));
      var response = await request.send();
      // print(response);
      var responseString = await response.stream.bytesToString();
      var responseBody = jsonDecode(responseString);
      var status = responseBody['status'];
      var message = responseBody['message'];
      // print(status);
      // print(message);
      // ignore: use_build_context_synchronously
      historiqueColisEnregistrer(id: listeDonneeConnectionUser['id'], context: context);
      if (status == 200) {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.yellow,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Coleur().couleur114521,
                        borderRadius: BorderRadius.circular(30)),
                    child:
                    InkWell(
                      onTap: () {
                        EasyLoading.show();
                        historiqueColisEnregistrer(id: listeDonneeConnectionUser['id'], context: context);
                        Future.delayed(const Duration(seconds: 5), () {
                          if(jsonStatusHistoriqueColis == 200){
                            EasyLoading.dismiss();
                          monModal.showBottomSheet(context, contenuModalDetailColisEnregistrer(context),
                              showFermerButton: false);
                          }
                        });
                      },
                      child: const Text(
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        "Vérifier",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.yellow,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Coleur().couleur114521,
                        borderRadius: BorderRadius.circular(30)),
                    child:
                    InkWell(
                      onTap: () {
                       Navigator.pop(context);
                      },
                      child: const Text(
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        "Réessayer",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // print("****");
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red,
                ),
                const Text(
                  "Erreur de connexion avec le serveur",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Réessayez'),
                  child: const Text(
                    'Réessayez',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      );
      // print('Erreur lors de l\'envoi de la requête : $e');
    }
  }


  //Fonction pour la liste des colis enregistrer
  historiqueColisEnregistrer(
      {required String id, refreshCallback, required BuildContext context}) async {
    try {
      // print("object historique");
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=getHistoriqueColis&idUserConnect=$id"));
      var jsonStatus = json.decode(response.body)['status'];
      var jsonMessage = json.decode(response.body)['message'];
      var jsonData = json.decode(response.body)['data'];
      listeTotalColisEnregistrer = jsonData;
      jsonStatusHistoriqueColis = jsonStatus;
      // print('********historique');
      // print(jsonMessage);
      // print(jsonStatus);
      // print(listeTotalColisEnregistrer);
      if (jsonStatus == 200) {
        dernierElementEnregistrer = listeTotalColisEnregistrer.first;
        refreshCallback();
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    jsonMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Column(
      //         children: [
      //           const Icon(
      //             Icons.error_outline,
      //             size: 50,
      //             color: Colors.red,
      //           ),
      //           const Text(
      //             "Erreur de connexion avec le serveur",
      //             style: TextStyle(fontSize: 20),
      //           ),
      //           const SizedBox(
      //             height: 15,
      //           ),
      //           TextButton(
      //             onPressed: () => Navigator.pop(context, 'Réessayez'),
      //             child: const Text(
      //               'Réessayez',
      //               style: TextStyle(fontSize: 20, color: Colors.red),
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // );
    }
  }

  //Fonction pour ajouter un client comme favoris
  Future ajouterClientFavoris({
    required BuildContext context,
    required Map<String, String> body,
  }) async {
    try {
      EasyLoading.show();
      // print('je suis');
      final String url =
          '$baseUrl/2023@!&task=addClientFavorie';
      Map<String, String> headers = {
        'Accept': "Application/json",
      };
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll(body)
        ..headers.addAll(headers);
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      var responseBody = jsonDecode(responseString);
      var status = responseBody['status'];
      var message = responseBody['message'];
      // print(status);
      // print(message);
      if (status == 200) {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        listeCLientFavoris(id: listeDonneeConnectionUser['id'], context: context);
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.green,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        );
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.yellow,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // print('Erreur lors de l\'envoi de la requête : $e');
    }
  }

  listeCLientFavoris(
      {required String id, required BuildContext context}) async {
    try {
      // EasyLoading.show();
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=getListefavorie&idUserConnect=$id"));
      var jsonStatus = json.decode(response.body)['status'];
      var jsonMessage = json.decode(response.body)['message'];
      var jsonData = json.decode(response.body)['data'];
      listeTotalClientFavoris = jsonData;
      // print("****************************");
      // print(listeTotalClientFavoris);
      if (jsonStatus == 200) {
        // EasyLoading.dismiss();
        // print('success');
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => Historique())
        // );
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    jsonMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Column(
      //         children: [
      //           const Icon(
      //             Icons.error_outline,
      //             size: 50,
      //             color: Colors.red,
      //           ),
      //           const Text(
      //             "Erreur de connexion avec le serveur",
      //             style: TextStyle(fontSize: 20),
      //           ),
      //           const SizedBox(
      //             height: 15,
      //           ),
      //           TextButton(
      //             onPressed: () => Navigator.pop(context, 'Réessayez'),
      //             child: const Text(
      //               'Réessayez',
      //               style: TextStyle(fontSize: 20, color: Colors.red),
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // );
    }
  }

  //Fonction pour recuperer le montant total payer
  montantTotalPayer({required String id, refreshCallback, required BuildContext context}) async {
    try {
      // EasyLoading.show();
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=getMontantTotalPayer&idUserConnect=$id"));
      var jsonStatus = json.decode(response.body)['status'];
      var jsonMessage = json.decode(response.body)['message'];
      var jsonData = json.decode(response.body)['data'];
       montantTotal = jsonData;
      // print('******************************');
      // print(montantTotal);
      // print(jsonMessage);
      // print(jsonStatus);
      if (jsonStatus == 200) {
        refreshCallback();
        // EasyLoading.dismiss();
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => Historique()
        // )
        // );
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    jsonMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Column(
      //         children: [
      //           const Icon(
      //             Icons.error_outline,
      //             size: 50,
      //             color: Colors.red,
      //           ),
      //           const Text(
      //             "Erreur de connexion avec le serveur",
      //             style: TextStyle(fontSize: 20),
      //           ),
      //           const SizedBox(
      //             height: 15,
      //           ),
      //           TextButton(
      //             onPressed: () => Navigator.pop(context, 'Réessayez'),
      //             child: const Text(
      //               'Réessayez',
      //               style: TextStyle(fontSize: 20, color: Colors.red),
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // );
    }
  }
  //Fonction pour la recherche des statistique
  rechercheStatistique(
      {
        required String id,
        adresseDestination,
        dateDebut,
        dateFin,
        required String typeEnvoi,
        refreshCallback,
        required BuildContext context
      }) async {
    try {
      // print("************");
      // print(adresseDestination);
      // print(typeEnvoi);
      // print(dateDebut);
      // print(dateFin);
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=getStatistique&idUserConnect=$id&adresseDestination=$adresseDestination&datedebut=$dateDebut&datefin=$dateFin&typeEnvoi=$typeEnvoi"));
      var jsonStatus = json.decode(response.body)['status'];
      var jsonMessage = json.decode(response.body)['message'];
      var jsonData = json.decode(response.body);
      listNombreTotal = jsonData;
      // print(listNombreTotal);
      if (jsonStatus == 200) {
        refreshCallback();
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    jsonMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Column(
      //         children: [
      //           Icon(
      //             Icons.error_outline,
      //             size: 50,
      //             color: Colors.red,
      //           ),
      //           Text(
      //             "Erreur de connexion",
      //             style: TextStyle(fontSize: 20),
      //           ),
      //           SizedBox(
      //             height: 15,
      //           ),
      //           TextButton(
      //             onPressed: () => Navigator.pop(context, 'Réessayez'),
      //             child: const Text(
      //               'Réessayez',
      //               style: TextStyle(fontSize: 20, color: Colors.red),
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // );
    }
  }


  Widget contenuModalDetailColisLivrer(BuildContext context) {
    return
      Column(
        children: [
          const Text(
            "Récapitulatif du colis:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Divider(),
          tableau("Livraison Express: ", "Conakry", Colors.black),
          const Divider(),
          const Text(
            "Informations sur l'agence de réception des colis",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          tableau("Pays: ", detailAgence['vcPays'], Colors.black),
          tableau("Agence: ", detailAgence['vcAgence'], Colors.black),
          tableau("Adresse: ", detailAgence['vcAdresse'], Colors.black),
          tableau("Téléphone: ", detailAgence['vcMsisdn'], Colors.black),
          const Divider(),
          tableau("Ref : ", detailColis['vcCodeColis'], Colors.black),
          tableau("Catégorie: ", detailColis['typeColis'], Colors.black),
          tableau("Poids: ",
              "${
                  detailColis['vcUnite'] ?? ''
              } * ${detailColis['iQuantite']} = ${((double.tryParse(detailColis['iQuantite'])! *
                  double.tryParse(detailColis['iPoid'])!).toString()).replaceAll('.0', '')} "
                  "${detailColis['vcUnite'] ?? ''}",
              Colors.black),
          tableau("Type d'envoi: ", detailColis['vcModeEnvois'], Colors.black),
          tableau("Date & heure: ", formatDate(DateTime.parse(detailColis['dtCreated']), [dd, '/', mm, '/', yyyy, ' - ', HH, ':', nn]), Colors.black),
          const Divider(),
          tableau("Expéditeur: ", detailColis['vcNameSender'], Colors.black),
          tableau("Adresse: ", detailColis['vcAdresseSender'], Colors.black),
          tableau("Téléphone: ", detailColis['vcMsisdnSender'], Colors.black),
          const Divider(),
          tableau("Récepteur: ", detailColis['vcNameReceiver'], Colors.black),
          tableau("Kaloum: ", detailColis['vcAdresseReceiver'], Colors.black),
          tableau("Téléphone: ", detailColis['vcMsisdnReceiver'], Colors.black),
          const Divider(),
          tableau(
              "Prix de la livraison: ",
              formaterUnMontant(
                  double.tryParse(detailColis['mMontant'])!.toDouble()),
              Colors.black),
          tableau(
              "Status paiement: ",
              detailColis['statusPaiement'] == 'pending'
                  ? 'En attente'
                  : detailColis['statusPaiement'] == 'Failed'
                  ? 'Echec de paiement'
                  : 'Succès',
              Colors.black),
          tableau("Mode de paiement: ",
              dernierElementEnregistrer['idModePaiement'] == '4' ?
              'Paiement à la livraison':
              dernierElementEnregistrer['idModePaiement'] == '1'?
              'Orange Money':
              dernierElementEnregistrer['idModePaiement'] == '2'?'Mobile money':'Espèce',
              Colors.black
          ),
          tableau(
              "Status colis: ",
              ((detailColis['btBoarded'] == '1' &&
                  detailColis['btReceived'] == '0' &&
                  detailColis['btLost'] == '0' &&
                  detailColis['btDelivred'] == '0' &&
                  detailColis['btCanceled'] == '0'))
                  ? "Colis embarquer"
                  : ((detailColis['btBoarded'] == '1' &&
                  detailColis['btReceived'] == '1' &&
                  detailColis['btLost'] == '0' &&
                  detailColis['btCanceled'] == '0' &&
                  detailColis['btDelivred'] == '0'))
                  ? "Colis reçu"
                  : ((detailColis['btBoarded'] == '1' &&
                  detailColis['btReceived'] == '0' &&
                  detailColis['btLost'] == '1' &&
                  detailColis['btCanceled'] == '0' &&
                  detailColis['btDelivred'] == '0'))
                  ? "Le colis a été perdu avant d'être embarqué.":
              ((detailColis['btBoarded'] == '1' &&
                  detailColis['btReceived'] == '1' &&
                  detailColis['btLost'] == '1' &&
                  detailColis['btCanceled'] == '0' &&
                  detailColis['btDelivred'] == '0'))
                  ?
              "Le colis a été perdu après réception."
                  : ((detailColis['btBoarded'] == '1' &&
                  detailColis['btReceived'] == '1' &&
                  detailColis['btLost'] == '0' &&
                  detailColis['btCanceled'] == '1' &&
                  detailColis['btDelivred'] == '0'))
                  ? "Colis retourner"
                  : ((detailColis['btBoarded'] == '1' &&
                  detailColis['btReceived'] == '1' &&
                  detailColis['btLost'] == '0' &&
                  detailColis['btCanceled'] == '0' &&
                  detailColis['btDelivred'] == '1'))
                  ? "Colis livrer"
                  : "En attente",
              Colors.black),
          if
          ((
              detailColis['btBoarded'] == '1' &&
                  detailColis['btReceived'] == '1' &&
                  detailColis['btLost'] == '0' &&
                  detailColis['btCanceled'] == '0' &&
                  detailColis['btDelivred'] == '0'))
            Column(
              children: [
                const Divider(),
                tableau(
                    "Vous payez: ",
                    formaterUnMontant(
                        double.tryParse(detailColis['mMontant'])!.toDouble()),
                    Colors.black),
                const Divider(),
                buttonConfirmeAbandonner(
                    context,
                    (detailColis['idModePaiement'] == "4" ) &&
                        ((detailColis['statusPaiement'] == 'pending' || (detailColis['statusPaiement'] == 'Failed')) &&
                            detailColis['btBoarded'] == '1' &&
                            detailColis['btReceived'] == '1' &&
                            detailColis['btLost'] == '0' &&
                            detailColis['btCanceled'] == '0' &&
                            detailColis['btDelivred'] == '0')
                        ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PaiementLivraison(
                            suivant: 'À la livraison'),
                      ));
                    }
                        : (detailColis['statusPaiement'] == 'success' &&
                        detailColis['btBoarded'] == '1' &&
                        detailColis['btReceived'] == '1' &&
                        detailColis['btLost'] == '0' &&
                        detailColis['btCanceled'] == '0' &&
                        detailColis['btDelivred'] == '0')
                        ? () {
                      ServiceApi().livrerColis(
                          refColis: refController.text,
                          id: listeDonneeConnectionUser['id'],
                          context: context);
                    }
                        :() {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RechercheColis(),
                      ));
                    },
                        () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RechercheColis(),
                      ));
                    },
                    (detailColis['idModePaiement'] == "4") &&
                        ((detailColis['statusPaiement'] == 'pending' || (detailColis['statusPaiement'] == 'Failed')) &&
                            detailColis['btBoarded'] == '1' &&
                            detailColis['btReceived'] == '1' &&
                            detailColis['btLost'] == '0' &&
                            detailColis['btCanceled'] == '0' &&
                            detailColis['btDelivred'] == '0')
                        ? 'Payer'
                        :
                    (detailColis['statusPaiement'] == 'success' &&
                        detailColis['btBoarded'] == '1' &&
                        detailColis['btReceived'] == '1' &&
                        detailColis['btLost'] == '0' &&
                        detailColis['btCanceled'] == '0' &&
                        detailColis['btDelivred'] == '0')?
                    'Confirmer':'Fermer',
                    'Abandonner',
                    Coleur().couleur00A759,
                    Coleur().couleur114521,
                    0.4,
                    0.4)
              ],
            )
          else
            const Column(
              children: [
                Divider(),
                // button(context, () {
                //   Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => const RechercheColis(),
                //   ));
                // }, "Fermer", Coleur().couleur114521, Coleur().couleurWhite, 2, 48, 70, 0.5)
              ],
            )
        ],
      );
  }


  //Fonction pour rechercher un colis
  detailsColis (
      {
        required BuildContext context,
        required String refColis,
        refreshCallback
      }) async {
    try {
      // print("object");
      EasyLoading.show();
      // print(refColis);
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=rechercheColisLivre&codeColis=$refColis"));
      // print(response);
      var jsonInfoColis = json.decode(response.body)['infoColis'];
      var jsonInfoAgence = json.decode(response.body)['infoAgence'];
      var message = json.decode(response.body)['message'];
      var jsonStatus = json.decode(response.body)['status'];
      detailColis = jsonInfoColis;
      detailAgence = jsonInfoAgence;
      // print('********detail colis');
      // print(detailColis);
      // print(detailAgence);
      // print(jsonStatus);
      if(jsonStatus == 200){
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        monModal.showBottomSheet(context, contenuModalDetailColisLivrer(context), showFermerButton: false);
        refreshCallback();
      }else{
        refreshCallback();
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // // ignore: use_build_context_synchronously
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Column(
      //         children: [
      //           const Icon(
      //             Icons.error_outline,
      //             size: 50,
      //             color: Colors.red,
      //           ),
      //           const Text(
      //             "Erreur de connexion avec le serveur",
      //             style: TextStyle(fontSize: 20),
      //           ),
      //           const SizedBox(
      //             height: 15,
      //           ),
      //           TextButton(
      //             onPressed: () => Navigator.pop(context, 'Réessayez'),
      //             child: const Text(
      //               'Réessayez',
      //               style: TextStyle(fontSize: 20, color: Colors.red),
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // );
    }
  }


  //Fonction pour livrer le colis au client
  livrerColis (
      {
        required String refColis,
        required String id,
        required BuildContext context,
      }) async {
    try {
      EasyLoading.show();
      // print(refColis);
      // print(id);
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=addDlivrerColis&codeColis=$refColis&idUserConnect=$id"));
      var jsonData = json.decode(response.body)['data'];
      var message = json.decode(response.body)['message'];
      var jsonStatus = json.decode(response.body)['status'];
      detailColisLivrer = jsonData;
      // print('********----////colis livrer');
      // print(detailColisLivrer);
      // print(jsonStatus);
      if(jsonStatus == 200){
        // ignore: use_build_context_synchronously
        // detailsColis(context: context, refColis: refColis);
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.yellow,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Coleur().couleur114521,
                        borderRadius: BorderRadius.circular(30)),
                    child:
                    InkWell(
                      onTap: () {
                        // Future.delayed(const Duration(seconds: 3), () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RechercheColis(),
                        ));
                        // });
                      },
                      child: const Text(
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        "Verifier",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
        // Future.delayed(const Duration(seconds: 4), () {
        //   EasyLoading.dismiss();
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) =>
        //     const PageSuccess(valider: 'Confirmer'),
        //   ));
        // });
      } else{
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red,
                ),
                const Text(
                  "Erreur de connexion avec le serveur",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Réessayez'),
                  child: const Text(
                    'Réessayez',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }


  //Fonction qui permet de payer a la livraison
  Future paiementLivraison({
    required BuildContext context,
    required Map<String, String> body,
  }) async {
    try {
      EasyLoading.show();
      final String url ='$baseUrl/2023@!&task=addPaiementLivraison';
      Map<String, String> headers = {
        'Accept': "Application/json",
      };
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll(body)
        ..headers.addAll(headers);
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      var responseBody = jsonDecode(responseString);
      var status = responseBody['status'];
      var message = responseBody['message'];
      // print("*** payer a la livraison");
      // print(status);
      // print(message);
      // print(responseBody);
      // print(statusModePaiment);
      if (status == 200) {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.yellow,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Coleur().couleur114521,
                        borderRadius: BorderRadius.circular(30)),
                    child:
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => const RechercheColis()));
                      },
                      child: const Text(
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        "Fermer",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
        // Future.delayed(const Duration(seconds: 4), () {
        //   EasyLoading.dismiss();
        //   // ignore: use_build_context_synchronously
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>
        //       PageSuccess(valider: statusModePaiment?"Valider":"À la livraison")));
        // });
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.yellow,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.yellow,
                ),
                Text(
                  "Erreur lors de l'envoi de la requête",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        },
      );
      // print('Erreur lors de l\'envoi de la requête : $e');
    }
  }


  Widget contenuModalInfoColisNonPayer(BuildContext context) {
    return
      Column(
        children: [
          const Text(
            "Récapitulatif du colis:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Divider(),
          tableau("Livraison Express: ", "Conakry", Colors.black),
          const Divider(),
          tableau("Ref : ", infoColisNonPayer['vcCodeColis'], Colors.black),
          tableau("Catégorie: ", infoColisNonPayer['typeColis'], Colors.black),
          tableau("Poids: ",
              "${infoColisNonPayer['iPoid']} ${
                  infoColisNonPayer['vcUnite'] ?? ''
              } * ${infoColisNonPayer['iQuantite']} = ${((double.tryParse(infoColisNonPayer['iQuantite'])! *
                  double.tryParse(infoColisNonPayer['iPoid'])!).toString()).replaceAll('.0', '')} ${
                  infoColisNonPayer['vcUnite'] ?? ''
              }",
              Colors.black),
          tableau("Type d'envoi: ", infoColisNonPayer['vcModeEnvois'], Colors.black),
          tableau("Date & heure: ", formatDate(DateTime.parse(infoColisNonPayer['dtCreated']), [dd, '/', mm, '/', yyyy, ' - ', HH, ':', nn]), Colors.black),
          const Divider(),
          tableau("Expéditeur: ", infoColisNonPayer['vcNameSender'], Colors.black),
          tableau("Adresse: ", infoColisNonPayer['vcAdresseSender'], Colors.black),
          tableau("Téléphone: ", infoColisNonPayer['vcMsisdnSender'], Colors.black),
          const Divider(),
          tableau("Récepteur: ", infoColisNonPayer['vcNameReceiver'], Colors.black),
          tableau("Kaloum: ", infoColisNonPayer['vcAdresseReceiver'], Colors.black),
          tableau("Téléphone: ", infoColisNonPayer['vcMsisdnReceiver'], Colors.black),
          const Divider(),
          tableau(
              "Prix de la livraison: ",
              formaterUnMontant(
                  double.tryParse(infoColisNonPayer['mMontant'])!.toDouble()),
              Colors.black),
          tableau(
              "Status paiement: ",
              infoColisNonPayer['statusPaiement'] == 'pending'
                  ? 'En attente'
                  : infoColisNonPayer['statusPaiement'] == 'Failed'
                  ? 'Echec de paiement'
                  : 'Succès',
              Colors.black),
          tableau("Mode de paiement: ",
              infoColisNonPayer['idModePaiement'] == '4' ?
              'Paiement à la livraison':
              infoColisNonPayer['idModePaiement'] == '1'?
              'Orange Money':
              infoColisNonPayer['idModePaiement'] == '2'?'Mobile money':'Espèce',
              Colors.black
          ),
          const SizedBox(height: 20,),
          if(infoColisNonPayer['statusPaiement'] == 'Failed')
          Container(
            padding: const EdgeInsets.only(top: 5),
            height: 35,
            width: 200,
            decoration: BoxDecoration(
                color: Coleur().couleur114521,
                borderRadius: BorderRadius.circular(30)),
            child:
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PaiementLivraison(suivant: 'Relancer paiement'),));
              },
              child: const Text(
                style: TextStyle(color: Colors.white, fontSize: 16),
                "Payer",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
  }


  //Fonction info colis non payer
  infosColisNonPayer (
      {
        required String refColis,
        required BuildContext context,
      }) async {
    try {
      EasyLoading.show();
      // print(refColis);
      // print(id);
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=getInfoColisNonPayer&codeColis=$refColis"));
      var jsonData = json.decode(response.body)['data'];
      var message = json.decode(response.body)['message'];
      var jsonStatus = json.decode(response.body)['status'];
      infoColisNonPayer = jsonData;
      // print('********----');
      // print(message);
      // print(infoColisNonPayer);
      // print(jsonStatus);
      if(jsonStatus == 200){
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        monModal.showBottomSheet(context, contenuModalInfoColisNonPayer(context), showFermerButton: false);
      } else{
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red,
                ),
                const Text(
                  "Erreur de connexion avec le serveur",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Réessayez'),
                  child: const Text(
                    'Réessayez',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }


  //Fonction pour relancer le paiement en cas d'echec
  relancerPaiement (
      {
        required String refColis,
        required String id,
        required String idModePaiement,
        required String montant,
        nuneroClient,
        required BuildContext context,
      }) async {
    try {
      // print("ll");
      // print(refColis);
      // print(id);
      // print(idModePaiement);
      // print(montant);
      // print(nuneroClient);
      EasyLoading.show();
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=addPayment&codeColis=$refColis&idUserConnect=$id&idModePaiement=$idModePaiement&montant=$montant&numeroCompteClient=$nuneroClient"));
      // var jsonData = json.decode(response.body)['data'];
      // print("object");
      var message = json.decode(response.body)['message'];
      // print(message);
      var jsonStatus = json.decode(response.body)['status'];
      // detailColisLivrer = jsonData;
      // print('********--- relance paiement');
      // print(detailColisLivrer);
      // print(jsonStatus);
      if(jsonStatus == 200){
        // ignore: use_build_context_synchronously
        // detailsColis(context: context, refColis: refColis);
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.yellow,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Coleur().couleur114521,
                        borderRadius: BorderRadius.circular(30)),
                    child:
                    InkWell(
                      onTap: () {
                        // Future.delayed(const Duration(seconds: 3), () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RechercheColis(),
                        ));
                        // });
                      },
                      child: const Text(
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        "Verifier",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else{
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red,
                ),
                const Text(
                  "Erreur de connexion avec le serveur",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Réessayez'),
                  child: const Text(
                    'Réessayez',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }



  //Liste de pays de destination
  listeDesPaysDestinateur(
      { required BuildContext context}) async {
    try {
      // EasyLoading.show();
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=getPaysDestionation"));
      var jsonData = json.decode(response.body)['data'];
      listesPays = jsonData;
      // print('******** Liste des pays');
      // print(listesPays);
    } catch (e) {
      EasyLoading.dismiss();
    }
  }


  //Fonction pour la liste des colis enregistrer
  listeHistoriqueColisLivrer(
      {required String id, refreshCallback, required BuildContext context}) async {
    try {
      // EasyLoading.show();
      http.Response response;
      response = await http.get(Uri.parse("$baseUrl/2023@!&task=getHistoriqueColisLivrer&idUserConnect=$id"));
      var jsonStatus = json.decode(response.body)['status'];
      var jsonMessage = json.decode(response.body)['message'];
      var jsonData = json.decode(response.body)['data'];
      listeTotalColisLivrer = jsonData;
      // print('********historique colis livrer');
      // print(listeTotalColisLivrer);
      if (jsonStatus == 200) {
        // EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    jsonMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Réessayez'),
                    child: const Text(
                      'Réessayez',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red,
                ),
                const Text(
                  "Erreur de connexion avec le serveur",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Réessayez'),
                  child: const Text(
                    'Réessayez',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

}
