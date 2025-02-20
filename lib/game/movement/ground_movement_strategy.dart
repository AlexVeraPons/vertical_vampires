import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:vertical_vampires/game/movement/movement_strategy.dart';

class GroundMovementStrategy implements MovementStrategy {
  GroundMovementStrategy({
    required this.playerBody,
    this.maxSpeed = 1000,
    this.acceleration = 2000,
    this.deceleration = 500,
    this.jumpImpulse = 70000,
    this.extraGravityForce = 800,
  });

  final Body playerBody;
  final double maxSpeed;
  final double acceleration;
  final double deceleration;
  final double jumpImpulse;
  final double extraGravityForce;

  @override
  void onEnterStrategy() {}

  @override
  void onExitStrategy() {}

  @override
  void updateMovement(double dt, Vector2 input, {bool jumpPressed = false}) {
    final velocity = playerBody.linearVelocity;
    var vx = velocity.x;

    //Adjust horizontal speed based on player input.
    if (input.x != 0) {
      vx += input.x * acceleration * dt;
    } else {
      if (vx.abs() < deceleration * dt) {
        vx = 0;
      } else if (vx > 0) {
        vx -= deceleration * dt;
      } else {
        vx += deceleration * dt;
      }
    }

    vx = vx.clamp(-maxSpeed, maxSpeed);
    playerBody.linearVelocity = Vector2(vx, playerBody.linearVelocity.y);

    //Determine if the player is on the ground.
    final isOnGround = playerBody.linearVelocity.y.abs() < 0.1;
    if (jumpPressed && isOnGround) {
      playerBody.applyLinearImpulse(
        Vector2(0, -jumpImpulse),
        point: playerBody.worldCenter,
      );
    }
    //When airborne, apply an extra gravitational force proportional to vertical speed.
    if (!isOnGround) {
      final double verticalSpeed = playerBody.linearVelocity.y.abs();
      playerBody.applyForce(Vector2(0, extraGravityForce * dt * verticalSpeed));
    }
  }
}
