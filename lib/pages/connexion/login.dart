
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../couleur/liste_couleur.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final LocalAuthentication auth = LocalAuthentication();

  TextEditingController  numeroTelephone = TextEditingController();
  TextEditingController password = TextEditingController();
  String authorized = 'Not Authorized';
  bool isAuthenticating = false;

  String enregistrerNumeroTelephone = '';
  String enregistrerPassword = '';

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        isAuthenticating = true;
        authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: "Connectez-vous en utilisant l'empreinte, un schéma ou un code.",
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      ServiceApi().connexion(numero:enregistrerNumeroTelephone, password:enregistrerPassword, context: context);
      setState(() {
        isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      // print(e);
      setState(() {
        isAuthenticating = false;
        authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }
    setState(
            () => authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }


  @override
  void initState() {
    super.initState();
    _loadSavedText();
  }

  _loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      enregistrerNumeroTelephone = prefs.getString('saved_telephone') ?? '';
      enregistrerPassword = prefs.getString('saved_password') ?? '';
    });
  }


  saveText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_telephone', numeroTelephone.text);
    await prefs.setString('saved_password', password.text);
    setState(() {
      enregistrerNumeroTelephone = numeroTelephone.text;
      enregistrerPassword = password.text;
    });
  }


  @override
  Widget build(BuildContext context) {
    String result = '';

    return
      WillPopScope(
        onWillPop: () async {
          return false;
        },
      child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/fond.png"),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logolivraison.png",
                height: 50,
              ),
              const SizedBox(height: 60,),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     var res = await Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => const SimpleBarcodeScannerPage(),
                    //         ));
                    //     setState(() {
                    //       if (res is String) {
                    //         result = res;
                    //       }
                    //     });
                    //   },
                    //   child: const Text('Open Scanner'),
                    // ),
                    // Text('Barcode Result: $result'),
                    TextFormField(
                      controller: numeroTelephone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                        labelText: "Numéro d'utilisateur",
                        labelStyle: TextStyle(color: Colors.yellow),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir le téléphone";
                        } else if (!RegExp(r'^[0-9]+$')
                            .hasMatch(value.replaceAll(".", ""))) {
                          return "Le numéro de téléphone est invalide";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: password,
                      decoration: const InputDecoration(
                        labelText: "Mot de passe",
                        labelStyle: TextStyle(color: Colors.yellow),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer un mot de passe";
                        }
                        return null;
                      },
                    ),
                    TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title:Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.phone,
                               decoration: const InputDecoration(
                                 hintText: "Numero de téléphone",
                               ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Veuillez saisir le téléphone";
                                  } else if (!RegExp(r'^[0-9]+$')
                                      .hasMatch(value.replaceAll(".", ""))) {
                                    return "Le numéro de téléphone est invalide";
                                  }
                                  return null;
                                },

                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Annuler'),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(""),
                          Text(
                            "Mot de passe oublié?",
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            saveText();
                            ServiceApi().connexion(numero:numeroTelephone.text, password:password.text, context: context);
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Coleur().couleurBF9B38,
                        ),
                        child:  const Text(
                            "Connexion",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: _authenticate,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        // Supprimez le rembourrage par défaut pour ajuster la hauteur de l'image
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Ajustez la valeur du rayon pour définir la bordure
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 80, // Définissez la hauteur du bouton ici
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10.0), // Ajustez la valeur du rayon pour définir la bordure
                        ),
                        child: Image.asset(
                          "assets/images/empreintes.jpeg",
                          fit: BoxFit
                              .cover, // Ajustez le mode de redimensionnement de l'image selon vos besoins
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Coleur().couleur114521,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Copyrght c 2021 | Made with by MV1",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.search, color: Colors.white),
                Icon(Icons.share, color: Colors.white),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

class _scanBarcode {
}
