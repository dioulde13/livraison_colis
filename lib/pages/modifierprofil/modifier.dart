import 'package:flutter/material.dart';
import '../couleur/liste_couleur.dart';
import '../dashboard/dashboard.dart';
import '../dashboard/pied_page.dart';
import '../fonctions/app_bar.dart';
import '../fonctions/button.dart';
import '../global.dart';
import '../services/api_service.dart';

class Modifier extends StatefulWidget {
  const Modifier({super.key});

  @override
  ModifierState createState() {
    return ModifierState();
  }
}

class ModifierState extends State<Modifier> {
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nomController.text = listeDonneeConnectionUser["vcNom"];
    prenomController.text = listeDonneeConnectionUser["vcPrenom"];
    numeroController.text = listeDonneeConnectionUser["vcMsisdn"];
    emailController.text = listeDonneeConnectionUser["email"];
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Coleur().couleurF0EFF8,
      appBar: entePage(
          context,
          const AccueilPage(),
          "Modifier le profil",
          Coleur().couleurWhite,
          Coleur().couleurWhite,
          Coleur().couleurWhite,
          "imagePath",
          Coleur().couleur114521),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Coleur().couleurWhite,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nom"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: nomController,
                      decoration: InputDecoration(
                        hintText: "Nom",
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir le nom";
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Prenom"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: prenomController,
                      decoration: InputDecoration(
                        hintText: "Prenom",
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir le prenom";
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Téléphone"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: numeroController,
                      keyboardType: TextInputType.phone,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: "Téléphone",
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir  le Téléphone";
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Email"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir l'email";
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                            .hasMatch(value)) {
                          return "Veuillez saisir un email valide";
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                button(context,
                        () {
                          if (_formKey.currentState!.validate()) {
                            ServiceApi().modifierProfil(
                                context: context,
                                nom: nomController.text,
                                prenom: prenomController.text,
                                numero: numeroController.text,
                                email: emailController.text,
                                id: listeDonneeConnectionUser['id']
                            );
                          }
                         },
                    "Modifier", Coleur().couleur114521,
                    Coleur().couleurWhite, 0, 40, 70, 0.5)
              ],
            ),
          ),
        ),
      ),
        bottomNavigationBar:
        footer(context)
    );
  }
}
