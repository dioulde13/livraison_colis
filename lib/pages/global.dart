import 'package:flutter/material.dart';
import 'dart:io';

String baseUrl = 'https://api-expresscolis.ecash-guinee.com/api/livraison?interfaceid=livraisonapi&secret=@cash!LIVRAISONPTI12Q@';
// ignore: prefer_typing_uninitialized_variables
var listeDonneeConnectionUser;
// ignore: prefer_typing_uninitialized_variables
var listeTotalColisEnregistrer;
// ignore: prefer_typing_uninitialized_variables
var listeTotalColisParModeEnvoi;
// ignore: prefer_typing_uninitialized_variables
var listeTotalClientFavoris;
// ignore: prefer_typing_uninitialized_variables
var montantTotal;
// ignore: prefer_typing_uninitialized_variables
var listNombreTotal;
// ignore: prefer_typing_uninitialized_variables
var detailColis;
// ignore: prefer_typing_uninitialized_variables
var detailAgence;
// ignore: prefer_typing_uninitialized_variables
var detailColisLivrer;
// ignore: prefer_typing_uninitialized_variables
var dernierElementEnregistrer;
// ignore: prefer_typing_uninitialized_variables
var listeTotalColisLivrer;
// ignore: prefer_typing_uninitialized_variables
 var jsonStatusHistoriqueColis;
// ignore: prefer_typing_uninitialized_variables
var infoColisNonPayer;
// ignore: prefer_typing_uninitialized_variables
var listesPays;

DateTime laDate = DateTime.now();

String heure = laDate.hour.toString();


DateTime dateTimeDebut = DateTime.now();
DateTime dateTimeFin = DateTime.now();
bool actualiseDate = false;

String selectedNom = '';
String selectedAdresse = '';
String selectedTelephone = '';

bool mtnMoney = false;
bool orangeMoney = false;
bool autres = false;

bool avion = true;
bool bateau = false;
bool voiture = false;

bool statusDirectionPaiement = false;


bool loadingHistoriqueColis = false;

bool avionHistorique = false;
bool bateauHistorique = false;
bool voitureHistorique = false;

bool avionStatistique = true;
bool bateauStatistique = false;
bool voitureStatistique = false;
bool redirectSTatistique = false;

bool document = true;
bool colis = false;
bool marchandise = false;

bool refreshing = false;

double totalPoid = 0;

double totalPrix = 0;

int counter = 1;

bool statusPayerLivraison = false;
bool statusModePaiment = false;

bool statusPaiementALaLivraison = false;


bool arretEasyLoading = false;

String selectionPays = '';

TextEditingController refController = TextEditingController();

String selectionnerPoids = "kg";

TextEditingController nomExpediteurController = TextEditingController();
TextEditingController adresseExpediteurController = TextEditingController();
File? image;
TextEditingController dateDebutStatistique = TextEditingController();
TextEditingController dateFinStatistique = TextEditingController();
TextEditingController montantController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController telephoneExpediteurController = TextEditingController();
TextEditingController nomRecepteurController = TextEditingController();
TextEditingController adresseRecepteurController = TextEditingController();
TextEditingController telephoneRecepteurController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController nombreDePoinds = TextEditingController();

String nomPays = "GUINEE";


String? selectedPaysExpediteur;
String? selectedPaysDestinateur;

String? selectedCountry;

List<String> listPays = [
  "",
  "Afghanistan",
  "Afrique du Sud",
  "Albanie",
  "Algérie",
  "Allemagne",
  "Andorre",
  "Angola",
  "Antigua-et-Barbuda",
  "Arabie Saoudite",
  "Argentine",
  "Arménie",
  "Australie",
  "Autriche",
  "Azerbaïdjan",
  "Bahamas",
  "Bahreïn",
  "Bangladesh",
  "Barbade",
  "Belgique",
  "Belize",
  "Bénin",
  "Bhoutan",
  "Biélorussie",
  "Birmanie",
  "Bolivie",
  "Bosnie-Herzégovine",
  "Botswana",
  "Brésil",
  "Brunei",
  "Bulgarie",
  "Burkina Faso",
  "Burundi",
  "Cambodge",
  "Cameroun",
  "Canada",
  "Cap-Vert",
  "Centrafrique",
  "Chili",
  "Chine",
  "Chypre",
  "Colombie",
  "Comores",
  "Congo-Brazzaville",
  "Congo-Kinshasa",
  "Corée du Nord",
  "Corée du Sud",
  "Costa Rica",
  "Côte d'Ivoire",
  "Croatie",
  "Cuba",
  "Danemark",
  "Djibouti",
  "Dominique",
  "Égypte",
  "Émirats arabes unis",
  "Équateur",
  "Érythrée",
  "Espagne",
  "Estonie",
  "États-Unis",
  "Éthiopie",
  "Fidji",
  "Finlande",
  "France",
  "Gabon",
  "Gambie",
  "Géorgie",
  "Ghana",
  "Grèce",
  "Grenade",
  "Guatemala",
  "Guinée",
  "Guinée équatoriale",
  "Guinée-Bissau",
  "Guyana",
  "Haïti",
  "Honduras",
  "Hongrie",
  "Îles Marshall",
  "Inde",
  "Indonésie",
  "Iran",
  "Iraq",
  "Irlande",
  "Islande",
  "Israël",
  "Italie",
  "Jamaïque",
  "Japon",
  "Jordanie",
  "Kazakhstan",
  "Kenya",
  "Kirghizistan",
  "Kiribati",
  "Koweït",
  "Laos",
  "Lesotho",
  "Lettonie",
  "Liban",
  "Liberia",
  "Libye",
  "Liechtenstein",
  "Lituanie",
  "Luxembourg",
  "Macédoine",
  "Madagascar",
  "Malaisie",
  "Malawi",
  "Maldives",
  "Mali",
  "Malte",
  "Maroc",
  "Maurice",
  "Mauritanie",
  "Mexique",
  "Micronésie",
  "Moldavie",
  "Monaco",
  "Mongolie",
  "Monténégro",
  "Mozambique",
  "Namibie",
  "Nauru",
  "Népal",
  "Nicaragua",
  "Niger",
  "Nigeria",
  "Niue",
  "Norvège",
  "Nouvelle-Zélande",
  "Oman",
  "Ouganda",
  "Ouzbékistan",
  "Pakistan",
  "Palaos",
  "Panama",
  "Papouasie-Nouvelle-Guinée",
  "Paraguay",
  "Pays-Bas",
  "Pérou",
  "Philippines",
  "Pologne",
  "Portugal",
  "Qatar",
  "République centrafricaine",
  "République dominicaine",
  "République tchèque",
  "Roumanie",
  "Royaume-Uni",
  "Russie",
  "Rwanda",
  "Saint-Christophe-et-Niévès",
  "Saint-Marin",
  "Saint-Vincent-et-les-Grenadines",
  "Sainte-Lucie",
  "Salomon",
  "Salvador",
  "Samoa",
  "São Tomé-et-Principe",
  "Sénégal",
  "Serbie"
];

