import 'dart:ui';
import 'package:vertical_vampires/game/life_component.dart';
import 'package:vertical_vampires/game/weapon/bullet/abstract_bullet.dart';

class BigBullet extends AbstractBullet {
  final Paint _paint = Paint()..color = const Color(0xFF0000FF);

  BigBullet() : super() {
    size = 8; 
    speed = 200.0; 
  }

  @override
  AbstractBullet createNewInstance() {
    return BigBullet();
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
  void move(double dt) {}

  @override
  void hitTarget(LifeComponent life) {
    life.takeDamage(300);
    removeFromParent();
  }
}
