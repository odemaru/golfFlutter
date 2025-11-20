import '../models/hole.dart';
import '../models/shot.dart';

class GirCalculator {
  static double triangleArea(Shot a, Shot b, Shot c) {
    return ((a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)) / 2.0).abs();
  }

  static bool inTriangle(Shot point, Shot a, Shot b, Shot c) {
    double mainArea = triangleArea(a, b, c);
    double area1 = triangleArea(point, a, b);
    double area2 = triangleArea(point, b, c);
    double area3 = triangleArea(point, c, a);
    
    return (area1 + area2 + area3 - mainArea).abs() < 0.01;
  }

  // static bool isTriangle(Shot point, Shot a, Shot b, Shot c) {
  //   int sign(Shot p1, Shot p2, Shot p3) {
  //     return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
  //   }
  //
  //   int d1 = sign(point, a, b);
  //   int d2 = sign(point, b, c);
  //   int d3 = sign(point, c, a);
  //
  //   bool hasNeg = (d1 < 0) || (d2 < 0) || (d3 < 0);
  //   bool hasPos = (d1 > 0) || (d2 > 0) || (d3 > 0);
  //
  //   return !(hasNeg && hasPos);
  // }

  static bool checkGIR(Hole hole) {
    int maxShots = hole.par - 2;
    
    for (int i = 0; i < hole.shots.length; i++) {
      Shot shot = hole.shots[i];
      bool onGreen = inTriangle(
        shot, 
        hole.green.front, 
        hole.green.middle, 
        hole.green.back
      );
      
      if (onGreen) {
        return (i + 1) <= maxShots;
      }
    }
    
    return false;
  }
}
