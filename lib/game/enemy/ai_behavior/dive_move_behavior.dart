import 'package:flame_forge2d/flame_forge2d.dart';
import 'ai_behavior.dart';

class DiveMoveBehavior extends AiBehavior {
  double _timer = 0.0;
  bool _isDiving = false;
  double _diveTimer = 0.0;

  final double diveInterval;
  final double diveDuration;
  final double leftBound;
  final double rightBound;

  int _horizontalDirection = 1;

  DiveMoveBehavior(
    Body target,
    Body body,
    double speed, {
    this.diveInterval = 5.0,
    this.diveDuration = 3.0,
    required this.leftBound,
    required this.rightBound,
  }) : super(target, body, speed);

  @override
  void move(double dt) {
    if (_isDiving) {
      final currentPos = body.position;
      final playerPos = target.position;
      final diveDirection = (playerPos - currentPos).normalized();
      final force = diveDirection * speed * 50;
      body.linearVelocity = force;

      // Update dive timer and check if dive duration has been reached
      _diveTimer += dt;
      if (_diveTimer >= diveDuration) {
        _isDiving = false;
        _diveTimer = 0.0;
        _timer = 0.0;
      }
    } else {
      // Change horizontal direction if bounds are reached
      if (body.position.x <= leftBound) {
        _horizontalDirection = 1;
      } else if (body.position.x >= rightBound) {
        _horizontalDirection = -1;
      }

      body.linearVelocity = Vector2(_horizontalDirection * speed * 20, 0);

      _timer += dt;
      if (_timer >= diveInterval) {
        _isDiving = true;
        _timer = 0.0;
      }
    }
  }
}
