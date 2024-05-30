
import 'package:intl/intl.dart';

String formaterUnMontant(double montant) {
  String montantFormate = NumberFormat("#,###.##", "en_US").format(montant);
  return "${montantFormate.replaceAll(',', ' ')} GNF";
}
