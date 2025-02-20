import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

abstract class MovementStrategy {
  void updateMovement(double dt, Vector2 input, {bool jumpPressed = false});
  void onEnterStrategy();
  void onExitStrategy();
}
