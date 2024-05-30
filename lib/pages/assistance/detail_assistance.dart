import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../dashboard/dashboard.dart';
import '../dashboard/pied_page.dart';
import '../couleur/liste_couleur.dart';
import '../fonctions/button_confirmer_abandonner.dart';
import '../fonctions/modals.dart';






class DetailAssistance extends StatefulWidget {
  const DetailAssistance({super.key});

  @override
  DetailAssistanceState createState() {
    return DetailAssistanceState();
  }
}

class DetailAssistanceState extends State<DetailAssistance> {
  final MonModal monModal = MonModal();

  var numero = '620545648';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Coleur().couleurF0EFF8,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AccueilPage()));
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Coleur().couleur114521,
              )),
          backgroundColor: const Color(0xFFF0EFF8),
          actions: <Widget>[
            Row(
              children: [
                Text(
                  "Assistance",
                  style: TextStyle(color: Coleur().couleur114521, fontSize: 18),
                ),
                const SizedBox(width: 60),
                // Ajoute un espace de 8 pixels entre le texte et l'icône
                SvgPicture.asset(
                  "assets/images/assistancepied.svg",
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 20),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height /1.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Coleur().couleurWhite,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Coleur().couleurWhite,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    border: Border.all(
                      color: Colors.black, // Couleur de la bordure
                      width: 0.4, // Épaisseur de la bordure
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Contacter nous ......",
                            style: TextStyle(color: Coleur().couleur114521),
                          ),
                          const Text(
                            "i",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const Divider(),
                      partieAssistanceTechnique(),
                      const Divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      buttonConfirmeAbandonner(
                          context,
                              (){
                                 setState(() {
                                   // launch('tel://$numero');
                                 });
                              },
                              (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder:
                                    (context) => const AccueilPage(),
                                )
                            );
                          },
                          "Appeler",
                          "Retour",
                          Colors.green,
                          Coleur().couleur114521,
                          0.4, 0.4
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                continuDeuxiemePartie(),
              ],
            ),
          ),
        ),
        bottomNavigationBar:
        footer(context)
    );
  }

  Widget partieAssistanceTechnique() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.phone,
          size: 25,
          color: Coleur().couleur114521,
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          height: 90,
          width: 3,
          color: Coleur().couleur114521,
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Assistance technique et commerciale",
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            Row(
              children: [
                const Text(
                  "Par telephone:  ",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                    fontSize: 10
                  ),
                ),
                Text(
                  "+224 600 00 00 00",
                  style: TextStyle(
                      color: Coleur().couleur114521,
                      fontWeight: FontWeight.bold,
                      fontSize: 10
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  "Destination:  ",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 10
                  ),
                ),
                Text(
                  "7j/7 de 8h à 20 heure",
                  style: TextStyle(
                      color: Coleur().couleur114521,
                      fontWeight: FontWeight.bold,
                      fontSize: 10
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  "Nombre colis :  ",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 10
                  ),
                ),
                Text(
                  "20",
                  style: TextStyle(
                      color: Coleur().couleur114521,
                      fontWeight: FontWeight.bold,
                      fontSize: 10
                  ),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          width: 3,
        ),
        const Icon(
          Icons.arrow_forward_ios,
            size: 20,
          color: Colors.yellow,
        )
      ],
    );
  }


  Widget continuDeuxiemePartie() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          // Ajoutez le padding horizontal ici
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Par Message",
                style: TextStyle(
                  color: Coleur().couleur114521,
                ),
              ),
              const Text(
                "i",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        const Divider(),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          // Ajoutez le padding horizontal ici
          child: Text(
            "Par SMS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Coleur().couleur114521,
              fontSize: 18,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          // Ajoutez le padding horizontal ici
          child: messageParSms(),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          // Ajoutez le padding horizontal ici
          child: buttonEvoyer(),
        ),
      ],
    );
  }

  Widget messageParSms() {
    return TextField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: 'Saisissez votre texte ici',
        labelText: 'Message',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // contentPadding: EdgeInsets.symmetric(vertical: 50.0), // Ajustez cette valeur selon vos besoins
      ),
    );
  }

  buttonEvoyer() {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder:
        //         (context) => DetailLivraison()
        //     )
        // );
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Coleur().couleur114521,
            borderRadius: BorderRadius.circular(20)),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Envoyer",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
