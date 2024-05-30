import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import '../assistance/detail_assistance.dart';
import '../couleur/liste_couleur.dart';
import '../enregistrement/expediteur.dart';
import '../global.dart';
import '../modifierprofil/modifier.dart';
import '../services/api_service.dart';
import '../statique/statique.dart';
import 'dashboard.dart';

  footer(
      BuildContext context
      ){
  return Container(
    color: Coleur().couleurDEE3E5,
    padding: const EdgeInsets.only(top: 8, bottom: 5),
    width: MediaQuery.of(context).size.width,
    height: 50,
    child:
    Row(
      children: [
        Expanded(
          flex: 1,
          child: InkWell(
              onTap: (){
                Future.delayed(const Duration(seconds: 4), () {
                  EasyLoading.dismiss();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>  const AccueilPage()));
                });
              },
              child: SvgPicture.asset("assets/images/home.svg")
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
              onTap: (){
                Future.delayed(const Duration(seconds: 4), () {
                  EasyLoading.dismiss();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>  const Modifier(),));
                });
              },
              child: SvgPicture.asset("assets/images/user.svg")
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: (){
              Future.delayed(const Duration(seconds: 4), () {
                EasyLoading.dismiss();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const DetailLivraison()));
              });
            },
            child: SvgPicture.asset("assets/images/Cercleadd.svg")
        ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
              onTap: (){
                Future.delayed(const Duration(seconds: 4), () {
                  EasyLoading.dismiss();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (BuildContext context) => const DetailAssistance()));
                });
              },
              child: SvgPicture.asset("assets/images/assistancepied.svg")
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
              onTap: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>  const  Statique(),)
                );
                ServiceApi().rechercheStatistique(
                    id: listeDonneeConnectionUser['id'],
                    adresseDestination: '',
                    dateDebut: '',
                    dateFin: '',
                    typeEnvoi: "Avion",
                    context: context
                );
              },
              child: SvgPicture.asset("assets/images/statistque.svg")
          ),
        )

      ],
    ),

  );
  }

