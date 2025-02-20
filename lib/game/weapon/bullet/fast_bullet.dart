// fast_red_bullet.dart

import 'dart:ui';
import 'package:vertical_vampires/game/life_component.dart';
import 'package:vertical_vampires/game/weapon/bullet/abstract_bullet.dart';

class FastRedBullet extends AbstractBullet {
  late bool shouldRender = true;
  FastRedBullet() : super() {
    size = 3;
    speed = 500.0;
  }

  @override
  AbstractBullet createNewInstance() {
    return FastRedBullet();
  }

  @override
  void render(Canvas canvas) {
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
