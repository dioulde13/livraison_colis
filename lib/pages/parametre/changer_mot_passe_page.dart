import 'package:flutter/material.dart';
import 'package:livraisons_colis/pages/parametre/parametres.dart';
import '../couleur/liste_couleur.dart';
import '../dashboard/pied_page.dart';
import '../fonctions/app_bar.dart';
import '../fonctions/button.dart';
import '../global.dart';
import '../services/api_service.dart';

class ChangerPassePage extends StatefulWidget {
  const ChangerPassePage({super.key});

  @override
  ChangerPassePageState createState() {
    return ChangerPassePageState();
  }
}

class ChangerPassePageState extends State<ChangerPassePage> {
  TextEditingController encienMotDePasse = TextEditingController();
  TextEditingController nouveauMotDePasse = TextEditingController();
  TextEditingController confirmerMotDePasse = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Coleur().couleurF0EFF8,
      appBar: entePage(
          context,
          const ParametrePage(),
          "Changer le mot de passe",
          Coleur().couleurWhite,
          Coleur().couleurWhite,
          Coleur().couleurWhite,
          "imagePath",
          Coleur().couleur114521),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Coleur().couleurWhite,
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
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
                    const Text("Ancien mot de passe"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: encienMotDePasse,
                      decoration: InputDecoration(
                        hintText: "Ancien mot de passe",
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir l'encien mot de passe";
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Nouveau mot de passe"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: nouveauMotDePasse,
                      decoration: InputDecoration(
                        hintText: "Nouveau mot de passe",
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir le nouveau mot de passe";
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Confirmer le mot de passe"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: confirmerMotDePasse,
                      decoration: InputDecoration(
                        hintText: "Confirmer le mot de passe",
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir le confirmer mot de passe";
                        } else if (nouveauMotDePasse.text !=
                            confirmerMotDePasse.text) {
                          return "Mot de passe non conforme";
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                button(context, () {
                  if (_formKey.currentState!.validate()) {
                    ServiceApi().modifierMotPasse(
                        context: context,
                        encien: encienMotDePasse.text,
                        nouveau: nouveauMotDePasse.text,
                        id: listeDonneeConnectionUser['id']
                    );
                  }
                }, "Modifier", Coleur().couleur114521, Coleur().couleurWhite, 0, 43, 70, 0.5)
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
