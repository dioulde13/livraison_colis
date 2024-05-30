// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:livraison_colis/pages/couleur/liste_couleur.dart';
// import '../enregistrement/expediteur.dart';
// import '../fonctions/app_bar.dart';
// import 'dart:io';
//
//
// class AjouterListeImage extends StatefulWidget {
//   const AjouterListeImage({super.key});
//
//
//   @override
//   AjouterListeImageState createState() {
//     return AjouterListeImageState();
//   }
// }
//
// class AjouterListeImageState extends State<AjouterListeImage> {
//
//
//   File? _image;
//
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(source: source);
//       if (pickedFile != null) {
//         setState(() {
//           _image = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       // print('Erreur lors de la récupération de l\'image: $e');
//     }
//   }
//
//
//   final ImagePicker imagePicker = ImagePicker();
//   List<XFile>? imageFileList = [];
//
//   void selectImages() async {
//     final List<XFile> selectedImages = await
//     imagePicker.pickMultiImage();
//     if (selectedImages.isNotEmpty) {
//       imageFileList!.addAll(selectedImages);
//     }
//     // print("Image List Length:" + imageFileList!.length.toString());
//     setState((){});
//   }
//
//
//   List<File> imageFiles = [];
//
//   void takeSnapshot() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? img = await picker.pickImage(
//       source: ImageSource.camera, // alternatively, use ImageSource.gallery
//       maxWidth: 400,
//     );
//     if (img == null) return;
//
//     setState(() {
//       imageFiles.add(File(img.path)); // Ajoutez le fichier à la liste
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Coleur().couleurDEE3E5,
//         appBar: entePage(
//             context,
//             const DetailLivraison(),
//             "Livraison - Express",
//             Coleur().couleur114521,
//             Coleur().couleur114521,
//             Coleur().couleur114521,
//             "assets/images/livreurdecolis.svg",
//             Coleur().couleurE0E0E0),
//       body: Container(
//         padding: const EdgeInsets.all(15),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//             //   SizedBox(
//             //   height: MediaQuery.of(context).size.height / 2,
//             //   width: MediaQuery.of(context).size.width,
//             //   child: Column(
//             //       children : [
//             //         Expanded(
//             //           child: GridView.builder(
//             //                 itemCount: imageFiles!.isEmpty ? 1 : imageFiles!.length,
//             //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             //                     crossAxisCount: 2,
//             //                     mainAxisSpacing: 5.0,
//             //                     crossAxisSpacing: 5.0
//             //                 ),
//             //                 itemBuilder: (context, index) => Container(decoration: BoxDecoration(
//             //                     color: Colors.white,
//             //                     border: Border.all(
//             //                         color: Colors.grey.withOpacity(0.9))),
//             //                     child: imageFiles!.isEmpty? Icon(
//             //                       CupertinoIcons.camera,
//             //                       color: Colors.grey.withOpacity(0.5),
//             //                     ): Image.file(imageFiles[index],))),
//             //         ),
//             //         SizedBox(height: 15,),
//             //         Container(
//             //           width: MediaQuery.of(context).size.width,
//             //           decoration: BoxDecoration(
//             //               color: Coleur().couleur114521,
//             //               borderRadius: BorderRadius.circular(10)
//             //           ),
//             //           child: TextButton(
//             //               onPressed: (){
//             //                 takeSnapshot();
//             //               },
//             //               child: Text("Prendre une liste des photo",
//             //                 style: TextStyle(
//             //                     color: Coleur().couleurWhite
//             //                 ),
//             //               )
//             //           ),
//             //         ),
//             //       ]
//             //   ),
//             // ),
//             //   SizedBox(height: 10,),
//             //   SizedBox(
//             //     height: MediaQuery.of(context).size.height / 3 ,
//             //     width: MediaQuery.of(context).size.width,
//             //     child: Column(
//             //         children : [
//             //           Expanded(
//             //             child: InkWell(
//             //               onTap: () {
//             //                 selectImages();
//             //               },
//             //               child: GridView.builder(
//             //                   itemCount: imageFileList!.isEmpty ? 1 : imageFileList!.length,
//             //                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             //                       crossAxisCount: 2,
//             //                       mainAxisSpacing: 5.0,
//             //                       crossAxisSpacing: 5.0
//             //                   ),
//             //                   itemBuilder: (context, index) => Container(decoration: BoxDecoration(
//             //                       color: Colors.white,
//             //                       border: Border.all(
//             //                           color: Colors.grey.withOpacity(0.9))),
//             //                       child: imageFileList!.isEmpty? Icon(
//             //                         CupertinoIcons.camera,
//             //                         color: Colors.grey.withOpacity(0.5),
//             //                       ): Image.file(imageFiles[index],))),
//             //             ),
//             //           )
//             //         ]
//             //     ),
//             //   ),
//               const SizedBox(height: 10,),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _image == null
//                       ? const Text('Aucune image sélectionnée.')
//                       : Image.file(_image!,
//                     height: 150,
//                     width: 150,
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(height: 15,),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                         color: Coleur().couleur114521,
//                         borderRadius: BorderRadius.circular(10)
//                     ),
//                     child: TextButton(
//                         onPressed: () => _pickImage(ImageSource.camera),
//                         child: Text("Prendre une photo",
//                           style: TextStyle(
//                               color: Coleur().couleurWhite
//                           ),
//                         )
//                     ),
//                   ),
//                   const SizedBox(height: 10,),
//                 ],
//               ),
//               const SizedBox(height: 10,),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _image == null
//                       ? const Text('Aucune image sélectionnée.')
//                       : Image.file(_image!,
//                     height: 150,
//                     width: 150,
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(height: 15,),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                         color: Coleur().couleur114521,
//                         borderRadius: BorderRadius.circular(10)
//                     ),
//                     child: TextButton(
//                         onPressed: () => _pickImage(ImageSource.gallery),
//                         child: Text("Photo dans la galerie",
//                           style: TextStyle(
//                               color: Coleur().couleurWhite
//                           ),
//                         )
//                     ),
//                   ),
//                   const SizedBox(height: 10,),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
// }
