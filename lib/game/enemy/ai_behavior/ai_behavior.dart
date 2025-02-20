import 'package:flame_forge2d/flame_forge2d.dart';

abstract class AiBehavior {
  final Body target;
  final Body body;
  final double speed;
  AiBehavior(this.target, this.body, this.speed);

  void move(double dt);
}
