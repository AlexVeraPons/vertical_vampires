import 'package:vertical_vampires/game/enemy/ai_behavior/ai_behavior.dart';

class SeekMoveBehavior extends AiBehavior {
  SeekMoveBehavior(super.target, super.body, super.speed);

  @override
  void move(dt) {
    //follow the player
    final batPos = body.position;
    final playerPos = target.position;

    final direction = (playerPos - batPos).normalized();

    final force = direction * speed * 20;
    body.linearVelocity = force;
  }
}
