import 'green.dart';
import 'shot.dart';

class Hole {
  final int par;
  final Green green;
  final List<Shot> shots;

  Hole({required this.par, required this.green, required this.shots});
}
