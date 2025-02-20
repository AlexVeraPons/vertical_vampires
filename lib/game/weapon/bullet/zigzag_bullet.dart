import 'dart:ui';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:vertical_vampires/game/life_component.dart';
import 'package:vertical_vampires/game/weapon/bullet/abstract_bullet.dart';

class ZigZagBullet extends AbstractBullet {
  final Paint _paint = Paint()..color = const Color(0xFF00FF00);
  double time = 0.0;

  ZigZagBullet() : super() {
    size = 5;
    speed = 300.0;
  }

  double zigzagFrequency = 20;
  double zigzagSpeed = 100;

  @override
  AbstractBullet createNewInstance() {
    return ZigZagBullet();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      Offset.zero,
      size,
      _paint,
    );
  }

  @override
  void move(double dt) {
    time += dt;
    double offsetMagnitude = sin(time * zigzagFrequency) * zigzagSpeed;

    final double angle = body.angle;
    final lateral = Vector2(-sin(angle), cos(angle));

    final velocity = (initialDirection ?? Vector2.zero()) * speed +
        lateral * offsetMagnitude;

    body.linearVelocity = velocity;
  }

  @override
  void hitTarget(LifeComponent life) {
    life.takeDamage(100);
  }
}
