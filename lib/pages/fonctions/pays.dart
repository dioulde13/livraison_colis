class Pays {
  final String nom;
  Pays({required this.nom});

  factory Pays.fromJson(Map<String, dynamic> json) {
    return Pays(nom: json['vcPays']);
  }
}