import 'package:flutter/material.dart';

class MonModal {
  showBottomSheet(
      BuildContext context,
      Widget contenuModal, {
        bool isScrollControlled = true,
        bool showFermerButton = true,
      }) {
    return showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (BuildContext context) {
        return  Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 1.2,
            padding: const EdgeInsets.all(10.0),
            child:  SingleChildScrollView(
              child: Column(
                  children: <Widget>[
                    contenuModal,
                    if (showFermerButton) // Conditionally show the button
                      ElevatedButton(
                        onPressed: () {
                          // Ferme le BottomSheet lorsqu'on appuie sur le bouton
                          Navigator.of(context).pop();
                        },
                        child: const Text('Fermer'),
                      ),
                  ],
                ),
            ),
        );
      },
      isScrollControlled: isScrollControlled,
    );
  }
}
