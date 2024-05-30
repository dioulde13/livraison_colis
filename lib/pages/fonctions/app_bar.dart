import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


PreferredSizeWidget entePage(
    BuildContext context,
    Widget redirectionPage,
    String text,
    Color colorIconGauche,
    Color colorText,
    Color colorIconDroite,
    String imagePath,
    Color backgroundColor
    ) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text(text,
    style: TextStyle(
      color: colorText,
      fontWeight: FontWeight.bold,
      fontSize: 16
    ),
    ),
    centerTitle: true,
    leading: InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => redirectionPage),
        );
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: colorIconGauche,
        size: 32,
      ),
    ),
    backgroundColor: backgroundColor, // Fix the typo here
    actions: <Widget>[
          SvgPicture.asset(
            imagePath,
            width: 30,
            height: 30,
          ),
      const SizedBox(width: 18,)
    ],
  );
}
