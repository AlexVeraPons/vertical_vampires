// fast_red_bullet.dart

import 'dart:ui';
import 'package:vertical_vampires/game/life_component.dart';
import 'package:vertical_vampires/game/weapon/bullet/abstract_bullet.dart';

class FastBullet extends AbstractBullet {
  late bool shouldRender = true;
  final Color color = Color(0xFFFF0000); // Red color

  FastBullet() : super() {
    size = 3;
    speed = 500.0;
  }

  @override
  AbstractBullet createNewInstance() {
    return FastBullet();
  }

  @override
  void render(Canvas canvas) {
    if (shouldRender) {
      final paint = Paint()..color = color;
      canvas.drawCircle(Offset.zero, size, paint);
    }
  }

  @override
  void executeOnShoot() {
    super.executeOnShoot();
    shouldRender = true;
  }

  @override
  void move(double dt) {}

  @override
  void hitTarget(LifeComponent life) {
    life.takeDamage(50);
    shouldRender = false;
  }
}
